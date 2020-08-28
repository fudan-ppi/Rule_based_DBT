#include "qemu/osdep.h"
#include "qemu-common.h"
#include "exec/cpu-common.h"
#include "cpu.h"
#include "exec/exec-all.h"

#include "x86-instr.h"

static const char *x86_opc_str[] = {
    [X86_OPC_INVALID] = "**** unsupported (x86) ****",
    [X86_OPC_MOVB] = "movb",
    [X86_OPC_MOVZBL] = "movzbl",
    [X86_OPC_MOVSBL] = "movsbl",
    [X86_OPC_MOVW] = "movw",
    [X86_OPC_MOVZWL] = "movzwl",
    [X86_OPC_MOVSWL] = "movswl",
    [X86_OPC_MOVL] = "movl",
    [X86_OPC_LEAL] = "leal",
    [X86_OPC_NOTL] = "notl",
    [X86_OPC_ANDB] = "andb",
    [X86_OPC_ANDW] = "andw",
    [X86_OPC_ANDL] = "andl",
    [X86_OPC_ORB] = "orb",
    [X86_OPC_XORB] = "xorb",
    [X86_OPC_ORW] = "orw",
    [X86_OPC_ORL] = "orl",
    [X86_OPC_XORL] = "xorl",
    [X86_OPC_NEGL] = "negl",
    [X86_OPC_INCB] = "incb",
    [X86_OPC_INCW] = "incw",
    [X86_OPC_INCL] = "incl",
    [X86_OPC_DECB] = "decb",
    [X86_OPC_DECW] = "decw",
    [X86_OPC_DECL] = "decl",
    [X86_OPC_ADDB] = "addb",
    [X86_OPC_ADDW] = "addw",
    [X86_OPC_ADDL] = "addl",
    [X86_OPC_ADCL] = "adcl",
    [X86_OPC_SUBL] = "subl",
    [X86_OPC_SBBL] = "sbbl",
    [X86_OPC_MULL] = "mull",
    [X86_OPC_IMULL] = "imull",
	[X86_OPC_SMULL] = "smull",
	[X86_OPC_UMLAL] = "umlal",
    [X86_OPC_SHLB] = "shlb",
    [X86_OPC_SHRB] = "shrb",
    [X86_OPC_SHLW] = "shlw",
    [X86_OPC_SHLL] = "shll",
    [X86_OPC_SHRL] = "shrl",
    [X86_OPC_SARL] = "sarl",
    [X86_OPC_SHLDL] = "shldl",
    [X86_OPC_SHRDL] = "shrdl",
    [X86_OPC_BTL] = "btl",
    [X86_OPC_TESTB] = "testb",
    [X86_OPC_TESTW] = "testw",
    [X86_OPC_TESTL] = "testl",
    [X86_OPC_CMPB] = "cmpb",
    [X86_OPC_CMPW] = "cmpw",
    [X86_OPC_CMPL] = "cmpl",
    [X86_OPC_CMOVNEL] = "cmovnel",
    [X86_OPC_CMOVAL] = "cmoval",
    [X86_OPC_CMOVBL] = "cmovbl",
    [X86_OPC_CMOVLL] = "cmovll",
    [X86_OPC_SETE] = "sete",
    [X86_OPC_CWT] = "cwt",
    [X86_OPC_JMP] = "jmp",
    [X86_OPC_JA]  = "ja",
    [X86_OPC_JAE] = "jae",
    [X86_OPC_JB] = "jb",
    [X86_OPC_JBE] = "jbe",
    [X86_OPC_JL] = "jl",
    [X86_OPC_JLE] = "jle",
    [X86_OPC_JG] = "jg",
    [X86_OPC_JGE] = "jge",
    [X86_OPC_JE] = "je",
    [X86_OPC_JNE] = "jne",
    [X86_OPC_JS] = "js",
    [X86_OPC_JNS] = "jns",
    [X86_OPC_PUSH] = "push",
    [X86_OPC_POP] = "pop",
    [X86_OPC_CALL] = "call",
    [X86_OPC_RET] = "ret",
    [X86_OPC_SET_LABEL] = "set label",

    //parameterized opcode
    [X86_OPC_OP1] = "op1",
    [X86_OPC_OP2] = "op2",
    [X86_OPC_OP3] = "op3",
    [X86_OPC_OP4] = "op4",
    [X86_OPC_OP5] = "op5",
    [X86_OPC_OP6] = "op6",
    [X86_OPC_OP7] = "op7",
    [X86_OPC_OP8] = "op8",
    [X86_OPC_OP9] = "op9",
    [X86_OPC_OP10] = "op10",
    [X86_OPC_OP11] = "op11",
    [X86_OPC_OP12] = "op12",
    
    [X86_OPC_SYNC_M] = "sync_m",
    [X86_OPC_SYNC_R] = "sync_r",
	
	[X86_OPC_PC_IR] = "pc_ir",
	[X86_OPC_PC_RR] = "pc_rr",
	[X86_OPC_JMPL] = "jmpl",
	[X86_OPC_CLZ] = "clz"
};

static const char *x86_reg_str[] = {
    "none",
    "cs", "ds", "es", "fs", "gs", "ss",
    "eax", "ebx", "ecx", "edx", "esi", "edi", "ebp", "esp",

    "of", "sf", "cf", "zf",

    "reg0", "reg1", "reg2", "reg3", "reg4", "reg5", "reg6", "reg7",
    "reg8", "reg9", "reg10", "reg11", "reg12", "reg13", "reg14", "reg15",

    "temp0", "temp1", "temp2", "temp3"
};

static X86Opcode get_x86_opcode(char *opc_str)
{
    X86Opcode i;
    for (i = X86_OPC_INVALID; i < X86_OPC_END; i++) {
        if (!strcmp(opc_str, x86_opc_str[i]))
            return i;
    }
    fprintf(stderr, "==== [X86] unsupported opcode: %s\n", opc_str);
    exit(-1);
    return X86_OPC_INVALID;
}

static X86Register get_x86_register(char *str)
{
    X86Register reg;
    for (reg = X86_REG_INVALID; reg < X86_REG_END; reg++) {
        if(!strcmp(str, x86_reg_str[reg]))
            return reg;
    }
    return X86_REG_INVALID;
}

const char *get_x86_opc_str(X86Opcode opc)
{
    return x86_opc_str[opc];
}

void print_x86_instr_seq(X86Instruction *instr_seq)
{
    X86Instruction *head = instr_seq;
    int i;

    while(head) {
        fprintf(stderr, "0x%x: %s \n", head->pc, x86_opc_str[head->opc]);
        for (i = 0; i < head->opd_num; i++) {
            X86Operand *opd = &head->opd[i];
            if (opd->type == X86_OPD_TYPE_IMM) {
                X86ImmOperand *imm = &opd->content.imm;
                if (imm->type == X86_IMM_TYPE_VAL)
                    fprintf(stderr, "     imm: 0x%x\n", imm->content.val);
                else if (imm->type == X86_IMM_TYPE_SYM)
                    fprintf(stderr, "     imm: %s\n", imm->content.sym);
            } else if (opd->type == X86_OPD_TYPE_REG)
                fprintf(stderr, "     reg: %s\n", x86_reg_str[opd->content.reg.num]);
            else if (opd->type == X86_OPD_TYPE_MEM) {
                fprintf(stderr, "     mem: base(%s)", x86_reg_str[opd->content.mem.base]);
                if (opd->content.mem.index != X86_REG_INVALID)
                    fprintf(stderr, ", index(%s)", x86_reg_str[opd->content.mem.index]);
                if (opd->content.mem.scale.type == X86_IMM_TYPE_SYM)
                    fprintf(stderr, ", scale(%s)", opd->content.mem.scale.content.sym);
                else if (opd->content.mem.scale.type == X86_IMM_TYPE_VAL)
                    fprintf(stderr, ", scale(0x%x)", opd->content.mem.scale.content.val);
                if (opd->content.mem.offset.type == X86_IMM_TYPE_SYM)
                    fprintf(stderr, ", offset(%s)", opd->content.mem.offset.content.sym);
                else if (opd->content.mem.offset.type == X86_IMM_TYPE_VAL)
                    fprintf(stderr, ", offset(0x%x)", opd->content.mem.offset.content.val);
                fprintf(stderr, "\n");
            }
        }
        head = head->next;
    }
}

void set_x86_instr_opc(X86Instruction *instr, X86Opcode opc)
{
    instr->opc = opc;
}

/* set the opcode of this insturction */
void set_x86_instr_opc_str(X86Instruction *instr, char *opc_str)
{
    instr->opc = get_x86_opcode(opc_str);
}

/* set the number of operands of this instruction */
void set_x86_instr_opd_num(X86Instruction *instr, uint32_t num)
{
    instr->opd_num = num;
}

/* set the type of this operand */
void set_x86_opd_type(X86Operand *opd, X86OperandType type)
{
    switch(type) {
        case X86_OPD_TYPE_IMM:
            opd->content.imm.type = X86_IMM_TYPE_NONE;
            break;
        case X86_OPD_TYPE_REG:
            opd->content.reg.num = X86_REG_INVALID;
            break;
        case X86_OPD_TYPE_MEM:
            opd->content.mem.base = X86_REG_INVALID;
            opd->content.mem.index = X86_REG_INVALID;
            opd->content.mem.scale.type = X86_IMM_TYPE_NONE;
            opd->content.mem.offset.type = X86_IMM_TYPE_NONE;
            break;
        default:
            fprintf(stderr, "Unsupported operand type in X86: %d\n", type);
    }

    opd->type = type;
}

/* set immediate operand using given string */
void set_x86_opd_imm_val_str(X86Operand *opd, char *imm_str)
{
    X86ImmOperand *iopd = &opd->content.imm;

    iopd->type = X86_IMM_TYPE_VAL;
    iopd->content.val = strtol(imm_str, NULL, 0);
    //iopd->content.val = atoi(imm_str);
}

void set_x86_opd_imm_sym_str(X86Operand *opd, char *imm_str)
{
    X86ImmOperand *iopd = &opd->content.imm;

    iopd->type = X86_IMM_TYPE_SYM;
    strcpy(iopd->content.sym, imm_str);
}

/* set register operand using given string */
void set_x86_opd_reg_str(X86Operand *opd, char *reg_str)
{
    opd->content.reg.num = get_x86_register(reg_str); 
}

void set_x86_opd_mem_base_str(X86Operand *opd, char *reg_str)
{
    opd->content.mem.base = get_x86_register(reg_str);
}

void set_x86_opd_mem_index_str(X86Operand *opd, char *reg_str)
{
    opd->content.mem.index = get_x86_register(reg_str);
}

void set_x86_opd_mem_scale_str(X86Operand *opd, char *scale_str)
{
    if (strstr(scale_str, "imm")) {
        opd->content.mem.scale.type = X86_IMM_TYPE_SYM;
        strcpy(opd->content.mem.scale.content.sym, scale_str);
    } else {
        opd->content.mem.scale.type = X86_IMM_TYPE_VAL;
        opd->content.mem.scale.content.val = atoi(scale_str);
    }
}

void set_x86_opd_mem_off(X86Operand *opd, int32_t val)
{
    opd->content.mem.offset.type = X86_IMM_TYPE_VAL;
    opd->content.mem.offset.content.val = val;
}

void set_x86_opd_mem_off_str(X86Operand *opd, char *off_str)
{
    if (strstr(off_str, "imm")) { /* offset is a symbol */
        opd->content.mem.offset.type = X86_IMM_TYPE_SYM;
        strcpy(opd->content.mem.offset.content.sym, off_str); 
    } else { /* offset is a constant integer */
        opd->content.mem.offset.type = X86_IMM_TYPE_VAL;
        if(off_str[0] == '-') /* negative value */
            opd->content.mem.offset.content.val = 0 - strtol(&off_str[1], NULL, 0);
        else
            opd->content.mem.offset.content.val = strtol(off_str, NULL, 0);
    }
}

const char *get_x86_reg_str(X86Register reg)
{
    return x86_reg_str[reg];
}
