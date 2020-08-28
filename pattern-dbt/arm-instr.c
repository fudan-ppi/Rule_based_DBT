#include "qemu/osdep.h"
#include "qemu-common.h"
#include "exec/cpu-common.h"
#include "cpu.h"
#include "exec/exec-all.h"

#include "arm-instr.h"

#define MAX_INSTR_NUM 1000000

static ARMInstruction *instr_buffer;
static int instr_buffer_index;

static const ARMRegister arm_reg_table[] = {
    ARM_REG_R0, ARM_REG_R1, ARM_REG_R2, ARM_REG_R3,
    ARM_REG_R4, ARM_REG_R5, ARM_REG_R6, ARM_REG_R7,
    ARM_REG_R8, ARM_REG_R9, ARM_REG_R10, ARM_REG_R11,
    ARM_REG_R12, ARM_REG_R13, ARM_REG_R14, ARM_REG_R15,
};

static const ARMConditionCode arm_cc_table[] = {
    ARM_CC_EQ, ARM_CC_NE, ARM_CC_CS, ARM_CC_CC, ARM_CC_MI,
    ARM_CC_PL, ARM_CC_VS, ARM_CC_VC, ARM_CC_HI, ARM_CC_LS,
    ARM_CC_GE, ARM_CC_LT, ARM_CC_GT, ARM_CC_LE, ARM_CC_AL,
    ARM_CC_XX
};

static const char *arm_reg_str[] = {
    "none",
    "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7",
    "r8", "r9", "r10", "r11", "r12", "sp", "lr", "pc",
    "cf", "nf", "vf", "zf",
    "reg0", "reg1", "reg2", "reg3", "reg4", "reg5", "reg6", "reg7",
    "reg8", "reg9", "reg10", "reg11", "reg12", "reg13", "reg14", "reg15"
};

static const char *arm_cc_str[] = {
    "ERROR",
    "eq", "ne", "cs", "cc", "mi", "pl", "vs", "vc",
    "hi", "ls", "ge", "lt", "gt", "le", "al", "xx"
};

static const char *arm_index_type_str[] = {
    "ERROR", "PRE", "POST"
};

static const char *arm_scale_str[] = {
    "ERROR", "lsl", "lsr", "asr", "ror", "rrx"
};

static const char *arm_opc_str[] = {
    [ARM_OPC_INVALID] = "**** unsupported (arm) ****",
    [ARM_OPC_LDRB]  = "ldrb",
    [ARM_OPC_LDRSB] = "ldrsb",
    [ARM_OPC_LDRH]  = "ldrh",
    [ARM_OPC_LDRSH] = "ldrsh",
    [ARM_OPC_LDR]   = "ldr",
    [ARM_OPC_STRB]  = "strb",
    [ARM_OPC_STRH]  = "strh",
    [ARM_OPC_STR]   = "str",
    [ARM_OPC_MOV]   = "mov",
    [ARM_OPC_MOVS]  = "movs",
    [ARM_OPC_MVN]   = "mvn",
    [ARM_OPC_MVNS]  = "mvns",
    [ARM_OPC_AND]   = "and",
    [ARM_OPC_ANDS]  = "ands",
    [ARM_OPC_ORR]   = "orr",
    [ARM_OPC_ORRS]  = "orrs",
    [ARM_OPC_EOR]   = "eor",
    [ARM_OPC_EORS]  = "eors",
    [ARM_OPC_BIC]   = "bic",
    [ARM_OPC_BICS]  = "bics",
    [ARM_OPC_LSL]   = "lsl",
    [ARM_OPC_LSR]   = "lsr",
    [ARM_OPC_RRX]   = "rrx",
    [ARM_OPC_LSRS]  = "lsrs",
    [ARM_OPC_ASR]   = "asr",
    [ARM_OPC_ADD]   = "add",
    [ARM_OPC_ADC]   = "adc",
    [ARM_OPC_SUB]   = "sub",
    [ARM_OPC_SBC]   = "sbc",
    [ARM_OPC_RSC]   = "rsc",
    [ARM_OPC_ADDS]  = "adds",
    [ARM_OPC_ADCS]  = "adcs",
    [ARM_OPC_SUBS]  = "subs",
    [ARM_OPC_SBCS]  = "sbcs",
    [ARM_OPC_RSCS]  = "rscs",
    [ARM_OPC_MUL]   = "mul",
    [ARM_OPC_UMULL] = "umull",
    [ARM_OPC_UMLAL] = "umlal",
    [ARM_OPC_SMULL] = "smull",
    [ARM_OPC_SMLAL] = "smlal",
    [ARM_OPC_MLA]   = "mla",
    [ARM_OPC_RSB]   = "rsb",
    [ARM_OPC_RSBS]  = "rsbs",
    [ARM_OPC_CLZ]   = "clz",
    [ARM_OPC_TST]   = "tst",
    [ARM_OPC_TEQ]   = "teq",
    [ARM_OPC_CMP]   = "cmp",
    [ARM_OPC_CMN]   = "cmn",
    [ARM_OPC_B]     = "b",
    [ARM_OPC_BL]    = "bl",
    [ARM_OPC_BX]    = "bx",
    [ARM_OPC_PUSH]  = "push",
    [ARM_OPC_POP]   = "pop",
    [ARM_OPC_OP1]   = "op1",
    [ARM_OPC_OP2]   = "op2",
    [ARM_OPC_OP3]   = "op3",
    [ARM_OPC_OP4]   = "op4",
    [ARM_OPC_OP5]   = "op5",
    [ARM_OPC_OP6]   = "op6",
    [ARM_OPC_OP7]   = "op7",
    [ARM_OPC_OP8]   = "op8",
    [ARM_OPC_OP9]   = "op9",
    [ARM_OPC_OP10]   = "op10",
    [ARM_OPC_OP11]   = "op11",
    [ARM_OPC_OP12]   = "op12"
};

static void print_instr_cc(ARMInstruction *instr)
{
    if (instr->cc != ARM_CC_INVALID)
        fprintf(stderr, "%s ", arm_cc_str[instr->cc]);
}

void print_imm_opd(ARMImmOperand *opd)
{
    if (opd->type == ARM_IMM_TYPE_VAL)
        fprintf(stderr, "0x%x ", opd->content.val);
    else if (opd->type == ARM_IMM_TYPE_SYM)
        fprintf(stderr, "%s ", opd->content.sym);
}

static void print_opd_index_type(ARMMemIndexType pre_post)
{
    if (pre_post != ARM_MEM_INDEX_TYPE_NONE)
        fprintf(stderr, ", index type: %s", arm_index_type_str[pre_post]);
    fprintf(stderr, " ");
}

void print_opd_scale(ARMOperandScale *scale)
{
    if (scale->type == ARM_OPD_SCALE_TYPE_IMM) {
        ARMImm *imm = &scale->content.imm;
        if (imm->type == ARM_IMM_TYPE_VAL) {
            if (imm->content.val != 0)
                fprintf(stderr, ", %s %d ", arm_scale_str[scale->direct], imm->content.val);
        } else
            fprintf(stderr, ", %s %s ", arm_scale_str[scale->direct], imm->content.sym);
    }
    else if (scale->type == ARM_OPD_SCALE_TYPE_REG)
        fprintf(stderr, ", %s %s ", arm_scale_str[scale->direct], arm_reg_str[scale->content.reg]);
}

void print_reg_opd(ARMRegOperand *opd)
{
    fprintf(stderr, "%s ", arm_reg_str[opd->num]);
    print_opd_scale(&opd->scale);
    // fprintf(stderr, "\n");
}

void print_mem_opd(ARMMemOperand *opd)
{
    fprintf(stderr, "[%s", arm_reg_str[opd->base]);
    if (opd->index != ARM_REG_INVALID)
        fprintf(stderr, ", %s", arm_reg_str[opd->index]);
    if (opd->offset.type == ARM_IMM_TYPE_VAL)
        fprintf(stderr, ", 0x%x", opd->offset.content.val);
    else if (opd->offset.type == ARM_IMM_TYPE_SYM)
        fprintf(stderr, ", %s", opd->offset.content.sym);    
    print_opd_scale(&opd->scale);
    fprintf(stderr, "] ");
    print_opd_index_type(opd->pre_post);
}

static void print_reg_liveness(bool *reg_liveness)
{
    ARMRegister reg;

    fprintf(stderr, "    ");
    for (reg = ARM_REG_CF; reg < ARM_REG_NUM; reg++)
        fprintf(stderr, " %s: %s ",
                arm_reg_str[reg], reg_liveness[reg] ? "true" : "false");
    fprintf(stderr, "\n");
}

void print_arm_instr_seq(ARMInstruction *instr_seq)
{
    ARMInstruction *head = instr_seq;
    int i;

    while(head) {
        fprintf(stderr, "0x%x: %s (%d)", head->pc, 
                arm_opc_str[head->opc], head->opd_num);
        // fprintf(stderr, "%s ", arm_opc_str[head->opc]);
        print_instr_cc(head);
        for (i = 0; i < head->opd_num; i++) {
            ARMOperand *opd = &head->opd[i];
            if (opd->type == ARM_OPD_TYPE_INVALID)
                continue;

            if (opd->type == ARM_OPD_TYPE_IMM)
                print_imm_opd(&opd->content.imm);
            else if (opd->type == ARM_OPD_TYPE_REG)
                print_reg_opd(&opd->content.reg);
            else if (opd->type == ARM_OPD_TYPE_MEM)
                print_mem_opd(&opd->content.mem);
        }
        fprintf(stderr, "\n");
        // print_reg_liveness(head->reg_liveness);
        // fprintf(stderr, "     save_cc: %s\n", head->save_cc ? "true" : "false");
        head = head->next;
    }
}

void print_arm_instr(ARMInstruction *instr_seq)
{
    ARMInstruction *head = instr_seq;
    int i;
        // fprintf(stderr, "0x%x: %s (%d)\n", head->pc, 
        //         arm_opc_str[head->opc], head->opd_num);
        fprintf(stderr, "%s ", arm_opc_str[head->opc]);
        print_instr_cc(head);
        for (i = 0; i < head->opd_num; i++) {
            ARMOperand *opd = &head->opd[i];
            if (opd->type == ARM_OPD_TYPE_INVALID)
                continue;

            if (opd->type == ARM_OPD_TYPE_IMM)
                print_imm_opd(&opd->content.imm);
            else if (opd->type == ARM_OPD_TYPE_REG)
                print_reg_opd(&opd->content.reg);
            else if (opd->type == ARM_OPD_TYPE_MEM)
                print_mem_opd(&opd->content.mem);
        }
        fprintf(stderr, "\n");
        // print_reg_liveness(head->reg_liveness);
        // fprintf(stderr, "     save_cc: %s\n", head->save_cc ? "true" : "false");
}

static ARMOperandScaleDirect get_scale_direct(uint32_t shiftop, uint32_t shift, ARMOperandScaleType type)
{
    ARMOperandScaleDirect ret = ARM_OPD_SCALE_NONE;
    switch (shiftop) {
        case 0: ret = ARM_OPD_SCALE_LSL; break;
        case 1: ret = ARM_OPD_SCALE_LSR; break;
        case 2: ret = ARM_OPD_SCALE_ASR; break;
        case 3:
            if (type == ARM_OPD_SCALE_TYPE_REG)
                ret = ARM_OPD_SCALE_ROR;
            else if (shift != 0)
                ret = ARM_OPD_SCALE_ROR;
            else
                ret = ARM_OPD_SCALE_RRX;
    }
    return ret;
}

void arm_instr_buffer_init(void)
{
    instr_buffer = g_new(ARMInstruction, MAX_INSTR_NUM);
    if (instr_buffer == NULL)
        fprintf(stderr, "Cannot allocate memory for instruction buffer!\n");

    instr_buffer_index = 0;
}

const char *get_arm_instr_opc(ARMOpcode opc)
{
    return arm_opc_str[opc];
}

static ARMInstruction *instr_buffer_alloc(target_ulong pc, uint32_t raw)
{
    ARMInstruction *instr = &instr_buffer[instr_buffer_index++];
    if (instr_buffer_index >= MAX_INSTR_NUM)
        fprintf(stderr, "Instruction buffer is not enough!\n");

    instr->pc = pc;
    instr->raw_binary = raw;
    instr->prev = NULL;
    instr->next = NULL;

    return instr;
}

static inline void init_instr(ARMInstruction *instr)
{
    int i;
    for (i = 0; i < ARM_MAX_OPERAND_NUM; i++)
        instr->opd[i].type = ARM_OPD_TYPE_INVALID;
    instr->opc = ARM_OPC_INVALID;
    for (i = 0; i < ARM_REG_NUM; i++)
        instr->reg_liveness[i] = true;
    instr->save_cc = true;
}

static ARMConditionCode get_arm_cc(char *opc_str)
{
    ARMConditionCode i;
    size_t len = strlen(opc_str);

    /* Less than 2, so guess it is always executed */
    if (len < 2)
        return ARM_CC_AL;

    if (!strcmp(opc_str, "teq") || !strcmp(opc_str, "movs") || !strcmp(opc_str, "umlal"))
        return ARM_CC_AL;

    for (i = ARM_CC_INVALID; i < ARM_CC_END; i++) {
        if(!strcmp(arm_cc_str[i], &opc_str[len-2])) {
            opc_str[len-2] = '\0';
            return i;
        }
    }

    /* No conditional code, so always executed */
    return ARM_CC_AL;
}

static ARMOpcode get_arm_opcode(char *opc_str)
{
    ARMOpcode i;
    for (i = ARM_OPC_INVALID; i < ARM_OPC_END; i++) {
        if (!strcmp(opc_str, arm_opc_str[i]))
            return i;
    }
    fprintf(stderr, "[ARM] Error: unsupported opcode: %s\n", opc_str);
    exit(0);
    return ARM_OPC_INVALID;
}

static ARMRegister get_arm_register(char *reg_str)
{
    ARMRegister reg;
    for (reg = ARM_REG_INVALID; reg < ARM_REG_END; reg++) {
        if (!strcmp(reg_str, arm_reg_str[reg]))
            return reg;
    }
    return ARM_REG_INVALID;
}

static ARMOperandScaleDirect get_arm_direct(char *direct_str)
{
    ARMOperandScaleDirect direct;
    for (direct = ARM_OPD_SCALE_LSL; direct < ARM_OPD_SCALE_END; direct++) {
        if (!strcmp(direct_str, arm_scale_str[direct]))
            return direct;
    }
    return ARM_OPD_SCALE_NONE;
}

/* create an ARM instruction and insert it to tb */
ARMInstruction *create_arm_instr(TranslationBlock *tb, target_ulong pc, uint32_t raw)
{
    ARMInstruction *instr = instr_buffer_alloc(pc, raw);
    ARMInstruction *head = (ARMInstruction *)tb->guest_instr;

    if (head == NULL)
        tb->guest_instr = instr;
    else {
        while(head->next)
            head = head->next;

        head->next = instr;
        instr->prev = head;
    }

    init_instr(instr);

    return instr;
}

/* set condition code of this instruction */
void set_arm_instr_cc(ARMInstruction *instr, uint32_t cond)
{
    instr->cc = arm_cc_table[cond];
}

/* set the opcode of this instruction */
void set_arm_instr_opc(ARMInstruction *instr, ARMOpcode opc)
{
    instr->opc = opc;
}

/* set the opcode of this instruction based on the given string */
void set_arm_instr_cc_opc_str(ARMInstruction *instr, char *opc_str)
{
    instr->cc = get_arm_cc(opc_str);
    instr->opc = get_arm_opcode(opc_str);
}

/* set the number of operands of this instruction */
void set_arm_instr_opd_num(ARMInstruction *instr, uint32_t num)
{
    instr->opd_num = num;
}

void set_arm_instr_opd_type(ARMInstruction *instr, int opd_index, ARMOperandType type)
{
    set_arm_opd_type(&instr->opd[opd_index], type);
}

void set_arm_instr_opd_imm(ARMInstruction *instr, int opd_index, uint32_t val)
{
    ARMOperand *opd = &instr->opd[opd_index];

    opd->type = ARM_OPD_TYPE_IMM;

    opd->content.imm.type = ARM_IMM_TYPE_VAL;
    opd->content.imm.content.val = val;
}

void set_arm_instr_opd_reg(ARMInstruction *instr, int opd_index, int regno)
{
    ARMOperand *opd = &instr->opd[opd_index];

    opd->type = ARM_OPD_TYPE_REG;
    opd->content.reg.num = arm_reg_table[regno];
}

/* Set register type operand using register string */
void set_arm_instr_opd_reg_str(ARMInstruction *instr, int opd_index, char *reg_str)
{
    ARMOperand *opd = &instr->opd[opd_index];

    opd->type = ARM_OPD_TYPE_REG;
    opd->content.reg.num = get_arm_register(reg_str);
}

void set_arm_instr_opd_reg_scale_imm(ARMInstruction *instr, int opd_index, uint32_t shiftop, uint32_t shift)
{
    ARMRegOperand *ropd = &(instr->opd[opd_index].content.reg);
    ARMOperandScale *scale = &ropd->scale;

    /* shift is 0 means no shift, so just return */
    if (shift == 0 && shiftop != 3)
        return;

    scale->type = ARM_OPD_SCALE_TYPE_IMM;
    scale->direct = get_scale_direct(shiftop, shift, scale->type); 
    scale->content.imm.type = ARM_IMM_TYPE_VAL;
    if (scale->direct == ARM_OPD_SCALE_RRX)
        scale->content.imm.content.val = 1;
    else
        scale->content.imm.content.val = shift;
}

void set_arm_instr_opd_reg_scale_reg(ARMInstruction *instr, int opd_index, uint32_t shiftop, int regno)
{
    ARMRegOperand *ropd = &(instr->opd[opd_index].content.reg);
    ARMOperandScale *scale = &ropd->scale;

    scale->type = ARM_OPD_SCALE_TYPE_REG;
    scale->direct = get_scale_direct(shiftop, 0, scale->type);
    scale->content.reg = arm_reg_table[regno];
}

ARMOperandScaleDirect set_arm_instr_opd_scale_direct_str(ARMOperandScale *pscale, char *direct_str)
{
    pscale->direct = get_arm_direct(direct_str);

    return pscale->direct;
}

void set_arm_instr_opd_scale_imm_str(ARMOperandScale *pscale, char *scale_str)
{
    pscale->type = ARM_OPD_SCALE_TYPE_IMM;
    if (strstr(scale_str, "imm")) { /* this is a symbol scale: imm_xxx */
        pscale->content.imm.type = ARM_IMM_TYPE_SYM;
        strcpy(pscale->content.imm.content.sym, scale_str);
    } else { /* this is a value scale */
        pscale->content.imm.type = ARM_IMM_TYPE_VAL;
        pscale->content.imm.content.val = atoi(scale_str);
    }
}

void set_arm_instr_opd_scale_reg_str(ARMOperandScale *pscale, char *scale_str)
{
    pscale->type = ARM_OPD_SCALE_TYPE_REG;
    pscale->content.reg = get_arm_register(scale_str);
}

void set_arm_instr_opd_mem_base(ARMInstruction *instr, int opd_index, int regno)
{
    ARMMemOperand *mopd = &(instr->opd[opd_index].content.mem);

    mopd->base = arm_reg_table[regno];
}

void set_arm_instr_opd_mem_base_str(ARMInstruction *instr, int opd_index, char *reg_str)
{
    ARMMemOperand *mopd = &(instr->opd[opd_index].content.mem);

    mopd->base = get_arm_register(reg_str);

}

void set_arm_instr_opd_mem_index(ARMInstruction *instr, int opd_index, int regno)
{
    ARMMemOperand *mopd = &(instr->opd[opd_index].content.mem);

    mopd->index = arm_reg_table[regno];
}

void set_arm_instr_opd_mem_index_str(ARMInstruction *instr, int opd_index, char *reg_str)
{
    ARMMemOperand *mopd = &(instr->opd[opd_index].content.mem);

    mopd->index = get_arm_register(reg_str);
}

void set_arm_instr_opd_mem_index_type(ARMInstruction *instr, int opd_index, ARMMemIndexType type)
{
    ARMMemOperand *mopd = &(instr->opd[opd_index].content.mem);

    mopd->pre_post = type;
}

void set_arm_opd_type(ARMOperand *opd, ARMOperandType type)
{
    ARMMemOperand *mopd;

    /* Do some intialization work here */
    switch(type) {
        case ARM_OPD_TYPE_IMM:
            opd->content.imm.type = ARM_IMM_TYPE_NONE;
            break;
        case ARM_OPD_TYPE_REG:
            opd->content.reg.num = ARM_REG_INVALID;
            opd->content.reg.scale.type = ARM_OPD_SCALE_TYPE_NONE;
            break;
        case ARM_OPD_TYPE_MEM:
            mopd = &opd->content.mem;
            mopd->base = ARM_REG_INVALID;
            mopd->index = ARM_REG_INVALID;
            mopd->offset.type = ARM_IMM_TYPE_NONE;
            mopd->scale.type = ARM_OPD_SCALE_TYPE_NONE;
            mopd->pre_post = ARM_MEM_INDEX_TYPE_NONE;
            mopd->addr_op = ARM_MEM_ADDR_OP_TYPE_ADD;
            break;
        default:
            fprintf(stderr, "Unsupported operand type in ARM: %d\n", type);
    }

    opd->type = type;
}

void set_arm_opd_mem_addr_op(ARMOperand *opd, ARMMemAddrOpType op)
{
    ARMMemOperand *mopd = &opd->content.mem;

    mopd->addr_op = op;
}

void set_arm_opd_imm_val_str(ARMOperand *opd, char *imm_str)
{
    ARMImmOperand *iopd = &opd->content.imm;

    iopd->type = ARM_IMM_TYPE_VAL;
    iopd->content.val = atoi(imm_str);
}

void set_arm_opd_imm_sym_str(ARMOperand *opd, char *imm_str)
{
    ARMImmOperand *iopd = &opd->content.imm;

    iopd->type = ARM_IMM_TYPE_SYM;
    strcpy(iopd->content.sym, imm_str);
}

void set_arm_opd_mem_off_val(ARMOperand *opd, int32_t off)
{
    ARMMemOperand *mopd = &opd->content.mem;

    mopd->offset.type = ARM_IMM_TYPE_VAL;
    mopd->offset.content.val = off;
}

void set_arm_opd_mem_off_str(ARMOperand *opd, char *off_str)
{
    ARMMemOperand *mopd = &(opd->content.mem);

    mopd->offset.type = ARM_IMM_TYPE_SYM;
    strcpy (mopd->offset.content.sym, off_str);
}

void set_arm_opd_mem_index_reg(ARMOperand *opd, int regno)
{
    ARMMemOperand *mopd = &(opd->content.mem);

    mopd->index = arm_reg_table[regno];
}

void set_arm_opd_mem_scale_imm(ARMOperand *opd, uint32_t shiftop, uint32_t shift)
{
    ARMOperandScale *scale = &opd->content.mem.scale;

    if (shift == 0)
        return;

    scale->type = ARM_OPD_SCALE_TYPE_IMM;
    scale->direct = get_scale_direct(shiftop, shift, scale->type); 
    scale->content.imm.type = ARM_IMM_TYPE_VAL;
    scale->content.imm.content.val = shift;
}

ARMRegister get_arm_reg(int regno)
{
    return arm_reg_table[regno];
}

const char *get_arm_reg_str(ARMRegister reg)
{
    return arm_reg_str[reg];
}

bool arm_instr_test_branch(ARMInstruction *instr)
{
    if (instr->opc == ARM_OPC_B || instr->opc == ARM_OPC_BL)
        return true;
    else
        return false;
}

ARMInstruction *get_arm_insn(ARMInstruction *insn_seq, target_ulong pc)
{
    ARMInstruction *insn = insn_seq;

    while(insn) {
        if (insn->pc == pc)
            return insn;

        insn = insn->next;
    }
    return NULL;
}

/* The translated code of these instructions 
   might modify the host condition codes */
bool modify_host_cc(ARMInstruction *insn)
{
    if (!insn)
        return false;

    if (/*insn->opc == ARM_OPC_ADD ||*/ insn->opc == ARM_OPC_ADC ||
        insn->opc == ARM_OPC_SUB || insn->opc == ARM_OPC_SUBS ||
        insn->opc == ARM_OPC_SBC || insn->opc == ARM_OPC_RSB || 
        insn->opc == ARM_OPC_ORR || insn->opc == ARM_OPC_ORRS || insn->opc == ARM_OPC_EOR ||
        insn->opc == ARM_OPC_BIC || insn->opc == ARM_OPC_MLA || insn->opc == ARM_OPC_SMLAL ||
        insn->opc == ARM_OPC_MUL ||
        insn->opc == ARM_OPC_AND || insn->opc == ARM_OPC_ANDS ||
        insn->opc == ARM_OPC_CMP || insn->opc == ARM_OPC_TST ||
        insn->opc == ARM_OPC_MVN ||
        ((insn->opc == ARM_OPC_MOV || insn->opc == ARM_OPC_MOVS)
         && insn->opd[1].type == ARM_OPD_TYPE_REG 
         && insn->opd[1].content.reg.scale.direct != ARM_OPD_SCALE_NONE) ||
        ((insn->opc == ARM_OPC_LDR || insn->opc == ARM_OPC_STR) && 
         (insn->opd[1].content.mem.scale.type == ARM_OPD_SCALE_TYPE_REG ||
          (insn->opd[1].content.mem.scale.type == ARM_OPD_SCALE_TYPE_IMM &&
           insn->opd[1].content.mem.scale.content.imm.content.val > 1))) ||
        (insn->opc == ARM_OPC_STRB &&
         (insn->opd[1].content.mem.addr_op == ARM_MEM_ADDR_OP_TYPE_SUB)))
        return true;
    return false;
}

static inline bool insn_define_cc(ARMOpcode opc)
{
    if (opc == ARM_OPC_TST || opc == ARM_OPC_TEQ || opc == ARM_OPC_CMP ||
        opc == ARM_OPC_CMN || opc == ARM_OPC_ADDS || opc == ARM_OPC_ADCS ||
        opc == ARM_OPC_BICS || opc == ARM_OPC_ORRS || opc == ARM_OPC_ANDS ||
        opc == ARM_OPC_SUBS || opc == ARM_OPC_SBCS || opc == ARM_OPC_MOVS)
        return true;
    return false;
}

void decide_reg_liveness(int succ_define_cc, ARMInstruction *insn_seq)
{
    bool cur_liveness[ARM_REG_NUM];
    ARMInstruction *tail;
    ARMInstruction *insn;
    bool cc_revised;
    int i;

    for (i = 0; i < ARM_REG_NUM; i++)
        cur_liveness[i] = true;

    if (succ_define_cc == 3) {
        for (i = ARM_REG_CF; i < ARM_REG_NUM; i++)
            cur_liveness[i] = false;
    }

    /* Find out the tail */
    tail = insn_seq;
    while (tail && tail->next)
        tail = tail->next;

    /* Decide register liveness */
    insn = tail;
    while(insn) {
        for (i = 0; i < ARM_REG_NUM; i++)
            insn->reg_liveness[i] = cur_liveness[i];

        /* Check if this instruciton uses any condition code */
        /* 1. Conditional execution */
        switch (insn->cc) {
            case ARM_CC_EQ:
            case ARM_CC_NE:
                cur_liveness[ARM_REG_ZF] = true;
                break;
            case ARM_CC_CS:
            case ARM_CC_CC:
                cur_liveness[ARM_REG_CF] = true;
                break;
            case ARM_CC_MI:
            case ARM_CC_PL:
                cur_liveness[ARM_REG_NF] = true;
                break;
            case ARM_CC_VS:
            case ARM_CC_VC:
                cur_liveness[ARM_REG_VF] = true;
                break;
            case ARM_CC_HI:
            case ARM_CC_LS:
                cur_liveness[ARM_REG_CF] = true;
                cur_liveness[ARM_REG_ZF] = true;
                break;
            case ARM_CC_GE:
            case ARM_CC_LT:
                cur_liveness[ARM_REG_NF] = true;
                cur_liveness[ARM_REG_VF] = true;
                break;
            case ARM_CC_GT:
            case ARM_CC_LE:
                cur_liveness[ARM_REG_ZF] = true;
                cur_liveness[ARM_REG_NF] = true;
                cur_liveness[ARM_REG_VF] = true;
                break;
            case ARM_CC_AL:
                break;
            default:
                fprintf(stderr, "Error: unexpected condition code: %d\n", insn->cc);
        }
        /* 2. Condition code as an operand */
        if (insn->opc == ARM_OPC_ADC || insn->opc == ARM_OPC_ADCS ||
            insn->opc == ARM_OPC_SBC || insn->opc == ARM_OPC_SBCS ||
            ((insn->opc == ARM_OPC_MOV || insn->opc == ARM_OPC_MOVS)
              && insn->opd[1].type == ARM_OPD_TYPE_REG 
              && insn->opd[1].content.reg.scale.direct == ARM_OPD_SCALE_RRX))
            cur_liveness[ARM_REG_CF] = true;

        if (insn->cc != ARM_CC_AL)
            goto next;

        /* 3. Update the liveness if this instruciton defines condition code */
        if (insn_define_cc(insn->opc)) {
            for (i = ARM_REG_CF; i < ARM_REG_NUM; i++)
                cur_liveness[i] = false;
        }

        next:
        insn = insn->prev;
    }

    /* Decide if we need to save condition codes for instructions that define condtion codes */
    insn = tail;
    cc_revised = false;
    while (insn) {
        if ((insn->opd_num > 1) &&
            ((insn->opd[1].type == ARM_OPD_TYPE_REG && insn->opd[1].content.reg.scale.direct != ARM_OPD_SCALE_NONE) ||
             (insn->opd[2].type == ARM_OPD_TYPE_REG && insn->opd[2].content.reg.scale.direct != ARM_OPD_SCALE_NONE)) &&
            (insn->reg_liveness[ARM_REG_CF] || insn->reg_liveness[ARM_REG_ZF] ||
             insn->reg_liveness[ARM_REG_NF] || insn->reg_liveness[ARM_REG_VF]))
            cc_revised = true;

        /* update the save_cc if this instruction defines condition code */
        if (insn_define_cc(insn->opc))
            insn->save_cc = cc_revised;
        else
            insn->save_cc = false;

        if (modify_host_cc(insn) &&
            (insn->reg_liveness[ARM_REG_CF] || insn->reg_liveness[ARM_REG_ZF] ||
             insn->reg_liveness[ARM_REG_NF] || insn->reg_liveness[ARM_REG_VF]))
            cc_revised = true;

        if (insn_define_cc(insn->opc) && insn->cc == ARM_CC_AL)
            cc_revised = false;

        insn = insn->prev;
    }
}
