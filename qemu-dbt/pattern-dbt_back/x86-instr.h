#ifndef X86_INSTR_H
#define X86_INSTR_H

#include "qemu/osdep.h"                                                                                                             
#include "qemu-common.h"

#include <stdint.h>
#include <stddef.h>

#define X86_MAX_OPERAND_NUM 3 // 2 for integer and 3 for AVX

typedef enum {
    X86_REG_INVALID = 0,

    /* Physical registers */
    X86_REG_CS, X86_REG_DS, X86_REG_ES,
    X86_REG_FS, X86_REG_GS, X86_REG_SS,
    X86_REG_EAX, X86_REG_EBX, X86_REG_ECX, X86_REG_EDX,
    X86_REG_ESI, X86_REG_EDI, X86_REG_EBP, X86_REG_ESP,

    /* Eflags */
    X86_REG_OF, X86_REG_SF, X86_REG_CF, X86_REG_ZF,

    /* Symbolic registers for rule instructions, synchronized with guest */
    X86_REG_REG0, X86_REG_REG1, X86_REG_REG2, X86_REG_REG3,
    X86_REG_REG4, X86_REG_REG5, X86_REG_REG6, X86_REG_REG7,
    X86_REG_REG8, X86_REG_REG9, X86_REG_REG10, X86_REG_REG11,
    X86_REG_REG12, X86_REG_REG13, X86_REG_REG14, X86_REG_REG15,

    /* Symbolic registers for rule instructions, temporary registers */
    X86_REG_TEMP0, X86_REG_TEMP1, X86_REG_TEMP2, X86_REG_TEMP3,

    X86_REG_END
} X86Register;

typedef enum {
    X86_OPC_INVALID = 0,

    X86_OPC_MOVB, X86_OPC_MOVZBL, X86_OPC_MOVSBL,
    X86_OPC_MOVW, X86_OPC_MOVZWL,
    X86_OPC_MOVSWL,
    X86_OPC_MOVL,

    X86_OPC_LEAL,

    X86_OPC_NOTL,

    X86_OPC_ANDB,
    X86_OPC_ORB,
    X86_OPC_XORB,
    X86_OPC_ANDW,
    X86_OPC_ORW,
    X86_OPC_ANDL,
    X86_OPC_ORL,
    X86_OPC_XORL,
    X86_OPC_NEGL,

    X86_OPC_INCB,
    X86_OPC_INCL,
    X86_OPC_DECB,
    X86_OPC_DECW,
    X86_OPC_INCW,
    X86_OPC_DECL,

    X86_OPC_ADDB,
    X86_OPC_ADDW,
    X86_OPC_ADDL,
    X86_OPC_ADCL,
    X86_OPC_SUBL,
    X86_OPC_SBBL,

    X86_OPC_MULL,
    X86_OPC_IMULL,

    X86_OPC_SHLB,
    X86_OPC_SHRB,
    X86_OPC_SHLW,
    X86_OPC_SHLL,
    X86_OPC_SHRL,
    X86_OPC_SARL,
    X86_OPC_SHLDL,
    X86_OPC_SHRDL,

    X86_OPC_BTL,
    X86_OPC_TESTW,
    X86_OPC_TESTB,
    X86_OPC_CMPB,
    X86_OPC_CMPW,
    X86_OPC_TESTL,
    X86_OPC_CMPL,

    X86_OPC_CMOVNEL,
    X86_OPC_CMOVAL,
    X86_OPC_CMOVBL,
    X86_OPC_CMOVLL,

    X86_OPC_SETE,

    X86_OPC_CWT,

    X86_OPC_JMP,
    X86_OPC_JA,
    X86_OPC_JAE,
    X86_OPC_JB,
    X86_OPC_JBE,
    X86_OPC_JL, X86_OPC_JLE,
    X86_OPC_JG, X86_OPC_JGE,
    X86_OPC_JE, X86_OPC_JNE,
    X86_OPC_JS, X86_OPC_JNS,

    X86_OPC_PUSH,
    X86_OPC_POP,

    X86_OPC_CALL,
    X86_OPC_RET,

    X86_OPC_SET_LABEL, // fake instruction to generate label

    //parameterized opcode
    X86_OPC_OP1,    
    X86_OPC_OP2,   
    X86_OPC_OP3,   
    X86_OPC_OP4,   
    X86_OPC_OP5,   

    X86_OPC_END
} X86Opcode;

typedef enum{
    X86_IMM_TYPE_NONE = 0,
    X86_IMM_TYPE_VAL,
    X86_IMM_TYPE_SYM
} X86ImmType;

typedef struct {
    X86ImmType type;
    union {
        int32_t val; 
        char sym[20]; /* this symbol might contain expression */
    } content;
} X86Imm;

typedef X86Imm X86ImmOperand;

typedef struct {
    X86Register num;
} X86RegOperand;

typedef struct {
    X86Register segment; /* not used now */

    X86Register base;
    X86Register index;
    X86Imm scale;
    X86Imm offset;
} X86MemOperand;

typedef enum {
    X86_OPD_TYPE_NONE = 0,
    X86_OPD_TYPE_IMM,
    X86_OPD_TYPE_REG,
    X86_OPD_TYPE_MEM
} X86OperandType;

typedef struct {
    X86OperandType type;

    union {
        X86ImmOperand imm;
        X86RegOperand reg;
        X86MemOperand mem;
    } content;
} X86Operand;

typedef struct X86Instruction {
    target_ulong pc;    /* simulated PC of this instruction */

    X86Opcode opc;      /* Opcode of this instruction */
    X86Operand opd[X86_MAX_OPERAND_NUM];    /* Operands of this instruction */
    uint32_t opd_num;   /* number of operands of this instruction */

    size_t size; /* size of operands: 1, 2, or 4 bytes */

    struct X86Instruction *next;    /* next instruction */
} X86Instruction;

const char *get_x86_opc_str(X86Opcode opc);
void print_x86_instr_seq(X86Instruction *instr_seq);

void set_x86_instr_opc(X86Instruction *instr, X86Opcode opc);
void set_x86_instr_opc_str(X86Instruction *instr, char *opc_str);
void set_x86_instr_opd_num(X86Instruction *instr, uint32_t num);

void set_x86_opd_type(X86Operand *opd, X86OperandType type);
void set_x86_opd_imm_val_str(X86Operand *opd, char *imm_str);
void set_x86_opd_imm_sym_str(X86Operand *opd, char *imm_str);
void set_x86_opd_reg_str(X86Operand *opd, char *reg_str);

void set_x86_opd_mem_off(X86Operand *, int32_t val);

void set_x86_opd_mem_base_str(X86Operand *opd, char *reg_str);
void set_x86_opd_mem_index_str(X86Operand *, char *);
void set_x86_opd_mem_scale_str(X86Operand *, char *);
void set_x86_opd_mem_off_str(X86Operand *opd, char *off_str);

const char *get_x86_reg_str(X86Register );
#endif
