#include <stdio.h>
#include <string.h>
#include <assert.h>

#include "qemu/osdep.h"
#include "qemu-common.h"
#include "exec/cpu-common.h"
#include "cpu.h"
#include "exec/exec-all.h"

#include "arm-instr.h"
#include "arm-parse.h"

#define RULE_ARM_INSTR_BUF_LEN 1000000

static ARMInstruction *rule_arm_instr_buf;
static int rule_arm_instr_buf_index;

void rule_arm_instr_buf_init(void)
{
    rule_arm_instr_buf = g_new(ARMInstruction, RULE_ARM_INSTR_BUF_LEN);
    if (rule_arm_instr_buf == NULL)
        fprintf(stderr, "Cannot allocate memory for rule_arm_instr_buf!\n");

    rule_arm_instr_buf_index = 0;
}

static ARMInstruction *rule_arm_instr_alloc(target_ulong pc)
{
    ARMInstruction *instr = &rule_arm_instr_buf[rule_arm_instr_buf_index++];
    if (rule_arm_instr_buf_index >= RULE_ARM_INSTR_BUF_LEN)
        fprintf(stderr, "Error: rule_arm_instr_buf is not enought!\n");

    instr->pc = pc;
    instr->next = NULL;
    return instr;
}

static int parse_rule_arm_opcode(char *line, ARMInstruction *instr)
{
    char opc_str[20] = "\0";
    int i = 0; 

    while(line[i] == ' ' || line[i] == '\t') // skip the first spaces
        i++;

    while(line[i] != ' ' && line[i] != '\n')
        strncat(opc_str, &line[i++], 1);

    set_arm_instr_cc_opc_str(instr, opc_str);

    if (line[i] == ' ')
        return i+1;
    else
        return i;
}

static int parse_scale(char *line, int idx, ARMOperandScale *pscale)
{
    char direct_str[10] = "\0";
    char scale_str[10] = "\0";
    int iix, i;

    if (line[idx] != ',')
        return idx;

    iix = idx + 2; // skip , and space
    for (i = 0; i < 3; i++) {
        if (line[iix] == '\n')
            break;
        strncat(direct_str, &line[iix++], 1);
    }

    //fprintf(stderr, "==== direct str: %s\n", direct_str);

    /* Try to set the scale direct based on the string, may fail-- */
    if (set_arm_instr_opd_scale_direct_str(pscale, direct_str) == ARM_OPD_SCALE_NONE)
        return idx;

    //fprintf(stderr, "\thas scale\n");

    /* This is a scale, parse the following immediate or register */
    idx = iix + 1; // skip the space
    if (line[idx] == '#') {
        /* scale value is an immediate */
        idx++; // skip #
        while(line[idx] != ',' && line[idx] != ']' && line[idx] != '\n')
            strncat(scale_str, &line[idx++], 1);
        set_arm_instr_opd_scale_imm_str(pscale, scale_str);
    } else if (line[idx] == 'r') {
        /* scale value is a register */
        while(line[idx] != ',' && line[idx] != ']' && line[idx] != '\n')
            strncat(scale_str, &line[idx++], 1);
        set_arm_instr_opd_scale_reg_str(pscale, scale_str);
    } else
        fprintf(stderr, "Error to parsing operand scale value.\n");

    return idx;
}

static int parse_rule_arm_operand(char *line, int idx, ARMInstruction *instr, int opd_idx)
{
    ARMOperand *opd = &instr->opd[opd_idx];
    char fc = line[idx];

    if (fc == '#') {
        /* Immediate Operand
           1. Read immediate value, #XXX*/
        set_arm_opd_type(opd, ARM_OPD_TYPE_IMM);
        idx++; // skip '#'
        fc = line[idx];
        char imm_str[20] = "\0";

        while (line[idx] != ',' && line[idx] != '\n')
            strncat(imm_str, &line[idx++], 1);

        if (fc == 'i' || fc == 'L')
            set_arm_opd_imm_sym_str(opd, imm_str);
        else
            set_arm_opd_imm_val_str(opd, imm_str);
    } else if (fc == 'r' || fc == 'p') {
        /* Register Operand
           1. Read register string, e.g., "reg0", "reg1".
           2. Check the scale type and content */
        char reg_str[20] = "\0";

        while (line[idx] != ',' && line[idx] != '\n')
            strncat(reg_str, &line[idx++], 1);

        set_arm_instr_opd_type(instr, opd_idx, ARM_OPD_TYPE_REG);
        set_arm_instr_opd_reg_str(instr, opd_idx, reg_str);

        idx = parse_scale(line, idx, &(instr->opd[opd_idx].content.reg.scale));
    } else if (fc == '[') {
        /* Memory Operand
           1. Read base register string, e.g., "reg0", "reg1".
           2. Read immediate value or index register string.
           3. Read Suffix, e.g., '!' for pre-indexing.*/
        char reg_str[20] = "\0";

        idx++; // skip '['
        while (line[idx] != ',' && line[idx] != ']' && line[idx] != '\n')
            strncat(reg_str, &line[idx++], 1);

        set_arm_instr_opd_type(instr, opd_idx, ARM_OPD_TYPE_MEM);
        set_arm_instr_opd_mem_base_str(instr, opd_idx, reg_str);

        //post-index 
        if ((line[idx] == ']') && (line[idx+1] == ',')){
                set_arm_instr_opd_mem_index_type(instr, opd_idx, ARM_MEM_INDEX_TYPE_POST);
                idx++;
        }

        if (line[idx] == ',') {
            

            idx += 2;

            if (line[idx] == '#') { /* This is an immediate offset (#imm_xxx symbolic chars) */
                char off_str[10] = "\0";
                char tfc;

                idx++;
                tfc = line[idx];
                assert(tfc == 'i');
                strncat(off_str, &line[idx], 7);
                idx += 7;
                set_arm_opd_mem_off_str(opd, off_str);
            } else if (line[idx] == 'r') { /* This is an index register */
                char index_reg_str[20] = "\0";
                while (line[idx] != ',' && line[idx] != ']' && line[idx] != '\n')
                    strncat(index_reg_str, &line[idx++], 1);

                set_arm_instr_opd_mem_index_str(instr, opd_idx, index_reg_str);

                idx = parse_scale(line, idx, &(instr->opd[opd_idx].content.mem.scale));
            } else
                fprintf(stderr, "Error in parsing memory operand.\n");
        }
        while (line[idx] != ']' && line[idx] != '\n')
            idx++;
        // fprintf(stderr, "%c %c\n", line[idx], line[idx+1]);
        //pre-index
        if ((line[idx] == ']') && (line[idx+1] == '!')){
            set_arm_instr_opd_mem_index_type(instr, opd_idx, ARM_MEM_INDEX_TYPE_PRE);
            idx += 2;
        }
    } else
        fprintf(stderr, "Error in parsing arm operand: unknown operand type: %s.\n", line);

    if (line[idx] == ',')
        return idx+2;
    else if (line[idx] == ']')
        return idx+1; 
    else
        return idx;
}

static void adjust_arm_instr(ARMInstruction *instr)
{
    if (instr->opc != ARM_OPC_ASR && instr->opc != ARM_OPC_LSL &&
        instr->opc != ARM_OPC_LSR && instr->opc != ARM_OPC_LSRS &&
        instr->opc != ARM_OPC_RRX)
        return;

    if (instr->opc == ARM_OPC_RRX) {
        instr->opc = ARM_OPC_MOV;
        instr->opd[1].content.reg.scale.type = ARM_OPD_SCALE_TYPE_IMM;
        instr->opd[1].content.reg.scale.content.imm = instr->opd[2].content.imm;
        instr->opd[1].content.reg.scale.direct = ARM_OPD_SCALE_RRX;
    } else if (instr->opd[2].type == ARM_OPD_TYPE_IMM) { /* immediate shift */
        instr->opd[1].content.reg.scale.type = ARM_OPD_SCALE_TYPE_IMM;
        instr->opd[1].content.reg.scale.content.imm = instr->opd[2].content.imm;
        switch (instr->opc) {
            case ARM_OPC_ASR:
                instr->opc = ARM_OPC_MOV;
                instr->opd[1].content.reg.scale.direct = ARM_OPD_SCALE_ASR;
                break;
            case ARM_OPC_LSL:
                instr->opc = ARM_OPC_MOV;
                instr->opd[1].content.reg.scale.direct = ARM_OPD_SCALE_LSL;
                break;
            case ARM_OPC_LSR:
                instr->opc = ARM_OPC_MOV;
                instr->opd[1].content.reg.scale.direct = ARM_OPD_SCALE_LSR;
                break;
            case ARM_OPC_LSRS:
                instr->opc = ARM_OPC_MOVS;
                instr->opd[1].content.reg.scale.direct = ARM_OPD_SCALE_LSR;
                break;
            default:
                fprintf(stderr, "[ARM] error: unsupported opcode: %d.\n", instr->opc);
                exit(0);
        }
    } else {
        fprintf(stderr, "[ARM] error: unsupported shift type.\n");
        exit(0);
    }
    set_arm_instr_opd_num(instr, 2); 
}

static ARMInstruction *parse_rule_arm_instruction(char *line, target_ulong pc)
{
    ARMInstruction *instr = rule_arm_instr_alloc(pc);
    int opd_idx;
    int i;

    i = parse_rule_arm_opcode(line, instr);

    opd_idx = 0;
    while (line[i] != '\n')
        i = parse_rule_arm_operand(line, i, instr, opd_idx++);

    set_arm_instr_opd_num(instr, opd_idx);

    /* adjust lsl, asr, and etc instructions to mov instructions with two operands */
    adjust_arm_instr(instr);

    return instr;
}

void parse_rule_arm_code(FILE *fp, TranslationRule *rule)
{
    target_ulong pc = 0;
    ARMInstruction *code_head = NULL;
    ARMInstruction *code_tail = NULL;
    char line[500];

    /* parse arm instructions in this rule */
    while(fgets(line, 500, fp)) {
        if (strstr(line, ".Host:\n")) {
            fseek(fp, (0-strlen(line)), SEEK_CUR);
            break;
        }

        /* check if this line is a comment */
        char fs = line[0];
        if (fs == '#')
            continue;
        ARMInstruction *cur = parse_rule_arm_instruction(line, pc);
        if (!code_head) {
            code_head = code_tail = cur;
        } else {
            code_tail->next = cur;
            code_tail = cur;
        }
        pc += 4; // fake value
        rule->guest_instr_num++;
    }

    #if 0
    if (rule->index == 750)
    {
        fprintf(stderr, "\n\n**** Guest %d ****\n", rule->index);
        print_arm_instr_seq(code_head);
    }
    #endif

    rule->arm_guest = code_head;
}
