#ifndef RULE_TRANSLATE_H
#define RULE_TRANSLATE_H

#include "parse.h"

typedef struct ImmMapping {
    char imm_str[20];
    int32_t imm_val;
    struct ImmMapping *next;
} ImmMapping;

typedef struct GuestRegisterMapping {
    ARMRegister sym;    /* symbolic register in a rule */
    ARMRegister num;    /* real register in guest instruction */

    struct GuestRegisterMapping *next;
} GuestRegisterMapping;

typedef struct LabelMapping {
    char lab_str[20];
    target_ulong target;
    target_ulong fallthrough;

    struct LabelMapping *next;
} LabelMapping;

typedef struct {
    target_ulong pc; /* Simulated guest pc */
    target_ulong target_pc; /* Branch target pc.
                               Only valid if the last instruction of current tb is not branch
                               and covered by this rule */
    TranslationRule *rule; /* Translation rule for this instruction sequence.
                              Only valid at the first instruction */
    int icount;             /* Number of guest instructions matched by this rule */
    target_ulong next_pc;  /* Guest pc after this rule record */
    bool update_cc;        /* If guest instructions in this rule update condition codes */
    bool save_cc;          /* If the condition code needs to be saved */
    ImmMapping *imm_map;
    GuestRegisterMapping *g_reg_map;
    LabelMapping *l_map;
    int para_opc[20];
} RuleRecord;

bool instr_is_match(target_ulong);
bool instrs_is_match(target_ulong);
bool tb_rule_matched(void);
RuleRecord *get_translation_rule(target_ulong);

bool check_translation_rule(target_ulong);
bool guest_insn_to_revise(TCGContext *, ARMInstruction *, target_ulong, ARMRegister);
void revise_guest_register_operand(ARMInstruction *, target_ulong, ARMRegister, ARMRegister, TCGOpcode, int);
void swap_guest_operands(ARMInstruction *, target_ulong, TCGOpcode);
void revise_guest_instruction(ARMInstruction *, target_ulong, TCGOpcode, TCGOpcode, tcg_target_ulong);
void remove_guest_instruction(TranslationBlock *, target_ulong);

/* Try to match instructions in this tb to existing rules */
void match_translation_rule(TranslationBlock *, int *);
void do_rule_translation(TCGContext *, TranslationBlock *, RuleRecord *, uint32_t *);

void get_label_map(char *, target_ulong *, target_ulong *);
int32_t get_imm_map(char *);
int32_t get_offset_map(char *);
ARMRegister get_guest_reg_map(X86Register);
bool is_last_access(X86Instruction *, X86Register);
#endif
