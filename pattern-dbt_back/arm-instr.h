#ifndef ARM_INSTR_H
#define ARM_INSTR_H

#define ARM_MAX_OPERAND_NUM 4

#define ARM_REG_NUM 21 /* invalid, r0 - r15, CF, NF, VF, and ZF */

typedef enum {
    ARM_REG_INVALID = 0,

    /* Physical registers for disasmed instrucutions */
    ARM_REG_R0, ARM_REG_R1, ARM_REG_R2, ARM_REG_R3,
    ARM_REG_R4, ARM_REG_R5, ARM_REG_R6, ARM_REG_R7,
    ARM_REG_R8, ARM_REG_R9, ARM_REG_R10,
    ARM_REG_R11, // fp
    ARM_REG_R12,
    ARM_REG_R13, // sp
    ARM_REG_R14, // lr
    ARM_REG_R15, // pc

    /* Conditional Code */
    ARM_REG_CF, ARM_REG_NF, ARM_REG_VF, ARM_REG_ZF,

    /* Symbolic registers for rule instructions */
    ARM_REG_REG0, ARM_REG_REG1, ARM_REG_REG2, ARM_REG_REG3,
    ARM_REG_REG4, ARM_REG_REG5, ARM_REG_REG6, ARM_REG_REG7,
    ARM_REG_REG8, ARM_REG_REG9, ARM_REG_REG10, ARM_REG_REG11,
    ARM_REG_REG12, ARM_REG_REG13, ARM_REG_REG14, ARM_REG_REG15,

    ARM_REG_END
} ARMRegister;

typedef enum {
    ARM_CC_INVALID,
    ARM_CC_EQ,  // 0000 Equal
    ARM_CC_NE,  // 0001 Not equal
    ARM_CC_CS,  // 0010 Carry set/unsigned higher or same
    ARM_CC_CC,  // 0011 Carry clear/unsigned lower
    ARM_CC_MI,  // 0100 Minus/negative
    ARM_CC_PL,  // 0101 Plus/positive or zero
    ARM_CC_VS,  // 0110 Overflow
    ARM_CC_VC,  // 0111 No overflow
    ARM_CC_HI,  // 1000 Unsigned higher
    ARM_CC_LS,  // 1001 Unsigned lower or same
    ARM_CC_GE,  // 1010 Signed greater than or equal
    ARM_CC_LT,  // 1011 Signed less than
    ARM_CC_GT,  // 1100 Signed greater than
    ARM_CC_LE,  // 1101 Signed less than or equal
    ARM_CC_AL,  // 1110 Always (unconditional)
    ARM_CC_XX,  // 1111 Not used currently
    ARM_CC_END
} ARMConditionCode;

typedef enum {
    ARM_OPC_INVALID = 0,

    ARM_OPC_LDRB,
    ARM_OPC_LDRSB,
    ARM_OPC_LDRH,
    ARM_OPC_LDRSH,
    ARM_OPC_LDR,
    ARM_OPC_STRB,
    ARM_OPC_STRH,
    ARM_OPC_STR,

    ARM_OPC_MOV,
    ARM_OPC_MOVS,
    ARM_OPC_MVN,
    ARM_OPC_MVNS,

    ARM_OPC_AND,
    ARM_OPC_ANDS,
    ARM_OPC_ORR,
    ARM_OPC_ORRS,
    ARM_OPC_EOR,
    ARM_OPC_EORS,
    ARM_OPC_BIC,
    ARM_OPC_BICS,

    ARM_OPC_LSL,
    ARM_OPC_LSR,
    ARM_OPC_ASR,
    ARM_OPC_RRX,
    ARM_OPC_LSRS,

    ARM_OPC_ADD,
    ARM_OPC_ADC,
    ARM_OPC_SUB,
    ARM_OPC_SBC,
    ARM_OPC_RSC,
    ARM_OPC_ADDS,
    ARM_OPC_ADCS,
    ARM_OPC_SUBS,
    ARM_OPC_SBCS,
    ARM_OPC_RSCS,
    ARM_OPC_MUL,
    ARM_OPC_UMULL,
    ARM_OPC_UMLAL,
    ARM_OPC_SMULL,
    ARM_OPC_SMLAL,
    ARM_OPC_MLA,
    ARM_OPC_RSB,
    ARM_OPC_RSBS,

    ARM_OPC_CLZ,

    ARM_OPC_TST,
    ARM_OPC_TEQ,
    ARM_OPC_CMP,
    ARM_OPC_CMN,

    ARM_OPC_B,
    ARM_OPC_BL,
    ARM_OPC_BX,

    ARM_OPC_PUSH,
    ARM_OPC_POP,

// parameterized opcode
    ARM_OPC_OP1,
    ARM_OPC_OP2,
    ARM_OPC_OP3,
    ARM_OPC_OP4,
    ARM_OPC_OP5,

    ARM_OPC_END
} ARMOpcode;

typedef enum {
    ARM_OPD_TYPE_INVALID = 0,
    ARM_OPD_TYPE_IMM,
    ARM_OPD_TYPE_REG,
    ARM_OPD_TYPE_MEM
} ARMOperandType;

typedef enum {
    ARM_OPD_SCALE_TYPE_NONE = 0,
    ARM_OPD_SCALE_TYPE_IMM,      /* The scale value is from imm */
    ARM_OPD_SCALE_TYPE_REG       /* The scale value is from reg */
} ARMOperandScaleType;

typedef enum {
    ARM_OPD_SCALE_NONE = 0,
    ARM_OPD_SCALE_LSL,
    ARM_OPD_SCALE_LSR,
    ARM_OPD_SCALE_ASR,
    ARM_OPD_SCALE_ROR,
    ARM_OPD_SCALE_RRX,
    ARM_OPD_SCALE_END
} ARMOperandScaleDirect;

typedef enum {
    ARM_IMM_TYPE_NONE = 0,
    ARM_IMM_TYPE_VAL,
    ARM_IMM_TYPE_SYM
} ARMImmType;

typedef struct {
    ARMImmType type;
    union {
        int32_t val;    /* For disasmed instructions, this value is the scaled value */
        char sym[20];   /* For rule instructions, format: "imm_xxx" */
    } content;
} ARMImm;

typedef ARMImm ARMImmOperand;

typedef struct {
    ARMOperandScaleType type;
    ARMOperandScaleDirect direct;
    union {
        ARMImm imm;
        ARMRegister reg;
    } content;
} ARMOperandScale;

typedef struct {
    ARMRegister num;
    ARMOperandScale scale;
} ARMRegOperand;

typedef enum {
    ARM_MEM_INDEX_TYPE_NONE = 0,
    ARM_MEM_INDEX_TYPE_PRE,
    ARM_MEM_INDEX_TYPE_POST
} ARMMemIndexType;

typedef enum {
    ARM_MEM_ADDR_OP_TYPE_NONE = 0,
    ARM_MEM_ADDR_OP_TYPE_ADD,
    ARM_MEM_ADDR_OP_TYPE_SUB
} ARMMemAddrOpType;

typedef struct {
    ARMRegister base;
    ARMRegister index;
    ARMImm offset;

    ARMOperandScale scale;
    ARMMemIndexType pre_post;
    ARMMemAddrOpType addr_op; /* operation between base and offset/index:
                                 add(default) or subtract */
} ARMMemOperand;

typedef struct {
    ARMOperandType type;

    union {
        ARMImmOperand imm;
        ARMRegOperand reg;
        ARMMemOperand mem;
    } content;
} ARMOperand;

typedef struct ARMInstruction {
    target_ulong pc;    /* simulated PC of this instruction */

    ARMConditionCode cc;    /* Condition code of this instruction */
    ARMOpcode opc;      /* Opcode of this instruction */

    ARMOperand opd[ARM_MAX_OPERAND_NUM];    /* Operands of this instruction */
    uint32_t opd_num;       /* number of operands of this instruction */

    struct ARMInstruction *prev; /* previous instruction in this block */
    struct ARMInstruction *next; /* next instruction in this block */

    bool reg_liveness[ARM_REG_NUM]; /* liveness of each register after this instruction.
                                       True: this register will be used
                                       False: this regsiter will not be used
                                   Currently, we only maitain this for the four condition codes */

    bool save_cc;   /* If this instruction defines conditon code, save_cc indicates if it is necessary to
                        save the condition code when do rule translation. */
    uint32_t raw_binary; /* raw binary code of this instruction */
} ARMInstruction;

void arm_instr_buffer_init(void);

void print_arm_instr_seq(ARMInstruction *instr_seq);
ARMInstruction *create_arm_instr(TranslationBlock *tb, target_ulong pc, uint32_t raw);

void set_arm_instr_cc(ARMInstruction *instr, uint32_t cond);
void set_arm_instr_opc(ARMInstruction *instr, ARMOpcode opc);
void set_arm_instr_cc_opc_str(ARMInstruction *instr, char *opc_str);

void set_arm_instr_opd_num(ARMInstruction *instr, uint32_t num);

void set_arm_instr_opd_type(ARMInstruction *instr, int opd_index, ARMOperandType type);
void set_arm_instr_opd_imm(ARMInstruction *instr, int opd_index, uint32_t val);

void set_arm_instr_opd_reg(ARMInstruction *instr, int opd_index, int regno);
void set_arm_instr_opd_reg_str(ARMInstruction *instr, int opd_index, char *reg_str);
void set_arm_instr_opd_reg_scale_imm(ARMInstruction *instr, int opd_index, uint32_t shift_op, uint32_t shift);
void set_arm_instr_opd_reg_scale_reg(ARMInstruction *instr, int opd_index, uint32_t shift_op, int regno);

ARMOperandScaleDirect set_arm_instr_opd_scale_direct_str(ARMOperandScale *, char *);
void set_arm_instr_opd_scale_imm_str(ARMOperandScale *, char *);
void set_arm_instr_opd_scale_reg_str(ARMOperandScale *, char *);

void set_arm_instr_opd_mem_base(ARMInstruction *instr, int opd_index, int regno);
void set_arm_instr_opd_mem_base_str(ARMInstruction *instr, int opd_index, char *reg_str);
void set_arm_instr_opd_mem_index(ARMInstruction *instr, int opd_index, int regno);
void set_arm_instr_opd_mem_index_str(ARMInstruction *instr, int opd_index, char *reg_str);

void set_arm_instr_opd_mem_index_type(ARMInstruction *, int, ARMMemIndexType);

void set_arm_opd_type(ARMOperand *opd, ARMOperandType type);

void set_arm_opd_imm_val_str(ARMOperand *, char *);
void set_arm_opd_imm_sym_str(ARMOperand *, char *);

void set_arm_opd_mem_off_val(ARMOperand *opd, int32_t off);
void set_arm_opd_mem_off_str(ARMOperand *opd, char *off_str);

void set_arm_opd_mem_index_reg(ARMOperand *, int);
void set_arm_opd_mem_scale_imm(ARMOperand *, uint32_t, uint32_t);
void set_arm_opd_mem_addr_op(ARMOperand *, ARMMemAddrOpType);

const char *get_arm_instr_opc(ARMOpcode);
const char *get_arm_reg_str(ARMRegister);
ARMRegister get_arm_reg(int regno);
ARMInstruction *get_arm_insn(ARMInstruction *, target_ulong);
bool modify_host_cc(ARMInstruction *);

bool arm_instr_test_branch(ARMInstruction *);

void decide_reg_liveness(int, ARMInstruction *);
#endif
