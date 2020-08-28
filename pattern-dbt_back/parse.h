#ifndef PARSE_H
#define PARSE_H

#include "arm-instr.h"
#include "x86-instr.h"

#define ARM_CC_NUM 4

#define ARM_VF 0
#define ARM_NF 1
#define ARM_CF 2
#define ARM_ZF 3

#define MAX_GUEST_LEN 500

typedef struct TranslationRule {
    int index;                  /* index of this rule */

    ARMInstruction *arm_guest;  /* guest code */
    X86Instruction *x86_host;   /* host code */

    uint32_t guest_instr_num;    /* number of guest instructions */
    struct TranslationRule *next;   /* next rule in this hash entry */
    struct TranslationRule *prev;   /* previous rule in this hash entry */
    char *intermediate_regs;
    /* ARM_VF, ARM_NF, ARM_CF, ARM_ZF */
    int arm_cc_mapping[ARM_CC_NUM]; /* Mapping between arm condition code and x86 condition code
                              0: arm cc is not defined 
                              1: arm cc is emulated by the corresponding x86 cc
                                 ARM_VF -> x86_OF, ARM_NF -> x86_SF, ARM_CF -> x86_CF, ARM_ZF -> x86_ZF 
                              2: arm cc is emulated by the negation of the corresponding x86 cc 
                                 ARM_CF -> !x86_CF */
    
    #ifdef PROFILE_RULE_TRANSLATION
    uint64_t hit_num;   /* number of hit to this rule (static) */
    int print_flag;     /* flag used to print hit number */
    #endif

    int match_counter;  /*counter the match times for each rule
                        used in rule ordering */

} TranslationRule;

int rule_hash_key(ARMInstruction *, int);

TranslationRule *get_rule(void);
void parse_translation_rules(void);

extern TranslationRule *rule_table[];
extern TranslationRule *cache_rule_table[];

#endif
