#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

#include "qemu/osdep.h"
#include "qemu-common.h"
#include "exec/cpu-common.h"
#include "cpu.h"
#include "exec/exec-all.h"

#include "arm-parse.h"
#include "x86-parse.h"

#include "parse.h"

#define RULE_BUF_LEN 10000

static const ARMOpcode opc_set[] = {
    [ARM_OPC_LDRB]  = ARM_OPC_OP3,
    [ARM_OPC_LDRSB] = ARM_OPC_OP3,
    [ARM_OPC_LDRH]  = ARM_OPC_OP3,
    [ARM_OPC_LDRSH] = ARM_OPC_OP3,
    [ARM_OPC_LDR]   = ARM_OPC_OP3,
    [ARM_OPC_STRB]  = ARM_OPC_OP4,
    [ARM_OPC_STRH]  = ARM_OPC_OP4,
    [ARM_OPC_STR]   = ARM_OPC_OP4,
    [ARM_OPC_MOV]   = ARM_OPC_OP2,
    [ARM_OPC_MOVS]  = ARM_OPC_INVALID,
    [ARM_OPC_MVN]   = ARM_OPC_INVALID,
    [ARM_OPC_MVNS]  = ARM_OPC_INVALID,
    [ARM_OPC_AND]   = ARM_OPC_OP1,
    [ARM_OPC_ANDS]  = ARM_OPC_OP5,
    [ARM_OPC_ORR]   = ARM_OPC_OP1,
    [ARM_OPC_ORRS]  = ARM_OPC_OP5,
    [ARM_OPC_EOR]   = ARM_OPC_OP1,
    [ARM_OPC_EORS]  = ARM_OPC_OP5,
    [ARM_OPC_BIC]   = ARM_OPC_OP12,
    [ARM_OPC_BICS]  = ARM_OPC_OP12,
    [ARM_OPC_LSL]   = ARM_OPC_INVALID,
    [ARM_OPC_LSR]   = ARM_OPC_INVALID,
    [ARM_OPC_RRX]   = ARM_OPC_INVALID,
    [ARM_OPC_LSRS]  = ARM_OPC_INVALID,
    [ARM_OPC_ASR]   = ARM_OPC_INVALID,
    [ARM_OPC_ADD]   = ARM_OPC_OP1,
    [ARM_OPC_ADC]   = ARM_OPC_OP8,
    [ARM_OPC_SUB]   = ARM_OPC_OP6,
    [ARM_OPC_SBC]   = ARM_OPC_OP9,
    [ARM_OPC_RSC]   = ARM_OPC_OP10,
    [ARM_OPC_ADDS]  = ARM_OPC_OP5,
    [ARM_OPC_ADCS]  = ARM_OPC_OP8,
    [ARM_OPC_SUBS]  = ARM_OPC_OP7,
    [ARM_OPC_SBCS]  = ARM_OPC_OP9,
    [ARM_OPC_RSCS]  = ARM_OPC_OP10,
    [ARM_OPC_MUL]   = ARM_OPC_OP1,
    [ARM_OPC_UMULL] = ARM_OPC_INVALID,
    [ARM_OPC_UMLAL] = ARM_OPC_INVALID,
    [ARM_OPC_SMULL] = ARM_OPC_INVALID,
    [ARM_OPC_SMLAL] = ARM_OPC_INVALID,
    [ARM_OPC_MLA]   = ARM_OPC_INVALID,
    [ARM_OPC_RSB]   = ARM_OPC_OP11,
    [ARM_OPC_RSBS]  = ARM_OPC_OP11,
    [ARM_OPC_CLZ]   = ARM_OPC_INVALID,
    [ARM_OPC_TST]   = ARM_OPC_INVALID,
    [ARM_OPC_TEQ]   = ARM_OPC_INVALID,
    [ARM_OPC_CMP]   = ARM_OPC_INVALID,
    [ARM_OPC_CMN]   = ARM_OPC_INVALID,
    [ARM_OPC_B]     = ARM_OPC_INVALID,
    [ARM_OPC_BL]    = ARM_OPC_INVALID,
    [ARM_OPC_BX]    = ARM_OPC_INVALID,
    [ARM_OPC_PUSH]  = ARM_OPC_INVALID,
    [ARM_OPC_POP]   = ARM_OPC_INVALID,
    [ARM_OPC_OP1]   = ARM_OPC_OP1,
    [ARM_OPC_OP2]   = ARM_OPC_OP2,
    [ARM_OPC_OP3]   = ARM_OPC_OP3,
    [ARM_OPC_OP4]   = ARM_OPC_OP4,
    [ARM_OPC_OP5]   = ARM_OPC_OP5,
    [ARM_OPC_OP6]   = ARM_OPC_OP6,
    [ARM_OPC_OP7]   = ARM_OPC_OP7,
    [ARM_OPC_OP8]   = ARM_OPC_OP8,
    [ARM_OPC_OP9]   = ARM_OPC_OP9,
    [ARM_OPC_OP10]   = ARM_OPC_OP10,
    [ARM_OPC_OP11]   = ARM_OPC_OP11,
    [ARM_OPC_OP12]   = ARM_OPC_OP12
};

static const int cache_index[] = {2483,
896,
2,
7,
121,
252,
2484,
37,
2482,
138,
446,
101,
2485,
176,
111,
46,
79,
23,
876,
189,
44,
88,
5,
212,
437,
339,
51,
1873,
218,
58,
299,
39,
675,
1026,
2349,
59,
753,
2216,
611,
64,
820,
2492,
300,
317,
1659,
794,
1237,
440,
206,
720,
1647,
9,
549,
2079,
1089,
33,
940,
167,
78,
2488,
328,
2490,
22,
170,
186,
1950,
11,
585,
24,
1401,
2295,
12,
191,
1239,
183,
482,
201,
655,
2486,
2375,
2491,
226,
2449,
840,
102,
2487,
844,
1336,
68,
53,
1875,
462,
2204};

static TranslationRule *rule_buf;
static int rule_buf_index;

int cache_counter = 0;

TranslationRule *rule_table[MAX_GUEST_LEN] = {NULL};
TranslationRule *cache_rule_table[MAX_GUEST_LEN] = {NULL};

static void rule_buf_init(void)
{
    rule_buf = g_new(TranslationRule, RULE_BUF_LEN);
    if (rule_buf == NULL)
        fprintf(stderr, "Cannot allocate memory for rule_buf!\n");

    rule_buf_index = 0;
}

static TranslationRule *rule_alloc(void)
{
    TranslationRule *rule = &rule_buf[rule_buf_index++];
    int i;

    if (rule_buf_index >= RULE_BUF_LEN)
        fprintf(stderr, "Error: rule_buf is not enough!\n");

    rule->index = 0;
    rule->arm_guest = NULL;
    rule->x86_host = NULL;
    rule->guest_instr_num = 0;
    rule->next = NULL;
    rule->prev = NULL;
    rule->intermediate_regs=NULL;
    #ifdef PROFILE_RULE_TRANSLATION
    rule->hit_num = 0;
    rule->print_flag = 0;
    #endif

    for (i = 0; i < ARM_CC_NUM; i++)
        rule->arm_cc_mapping[i] = 0;

    rule->match_counter = 0;

    return rule;
}

static void init_buf(void)
{
    rule_arm_instr_buf_init();
    rule_x86_instr_buf_init();

    rule_buf_init();
}

static void install_rule(TranslationRule *rule)
{
    int index = rule_hash_key(rule->arm_guest, rule->guest_instr_num);


    // fprintf(stderr, "%d\n", index);
    assert(index < MAX_GUEST_LEN);

    int i;
    for (i = 0; i < 93; i++){
        if (cache_index[i] == rule->index){
            ++cache_counter;
            rule->next = cache_rule_table[index];
            cache_rule_table[index] = rule;
            return;
        }
    }

    rule->next = rule_table[index];
    if (rule_table[index])
        rule_table[index]->prev = rule;
    rule_table[index] = rule;

}

int rule_hash_key(ARMInstruction *arm_insn, int num)
{
    ARMInstruction *p_arm_insn = arm_insn;
    int sum = 0;
    int i;

    for (i = 0; i < num; i++) {
        sum += opc_set[p_arm_insn->opc];
        p_arm_insn = p_arm_insn->next;
    }

    return (sum/num);
}

TranslationRule *get_rule(void)
{
    return &rule_buf[0];
}

void parse_translation_rules(void)
{
    const char rule_file[] = "/home/ppi/dbt/pattern-dbt/rules4all";
    TranslationRule *rule = NULL;
    int counter = 0;
    int install_counter = 0;
    int i;
    char line[500];
    char *substr;
    FILE *fp;

    /* 1. init environment */
    init_buf();

    fprintf(stderr, "== Loading translation rules from %s...\n", rule_file);
    /* 2. open the rule file and parse it */
    fp = fopen(rule_file, "r");
    if (fp == NULL) {
        fprintf(stderr, "== No translation rule file found.\n");
        return;
    }

    while(!feof(fp)) {
        if(fgets(line, 500, fp) == NULL)
            break;

        /* check if this line is a comment */
        char fs = line[0];
        if (fs == '#' || fs == '\n')
            continue;

        if ((substr = strstr(line, ".Guest:\n")) != NULL) {
            char idx[20] = "\0";

            rule = rule_alloc();
            counter++;
            // fprintf(stderr, "find rule");            
            /* get the index of this rule */
            strncpy(idx, line, strlen(line) - strlen(substr));
            rule->index = atoi(idx);


            // fprintf(stderr, "===== Parsing guest with index: %d, idx: %s=====\n", rule->index, idx);
            parse_rule_arm_code(fp, rule);

            // if (rule->index == 112){
            //     fprintf(stderr, "%d %d\n", rule->arm_guest->opc, rule->guest_instr_num);
            //     fprintf(stderr, "parse 112\n");
            // }

        } else if (strstr(line, ".Host:\n")) {
            // fprintf(stderr, "===== Parsing host =====\n");
            if (parse_rule_x86_code(fp, rule) /*&& rule->arm_cc_mapping[ARM_VF] == 1 &&
                rule->arm_cc_mapping[ARM_NF] == 1 && rule->arm_cc_mapping[ARM_CF] == 2 &&
                rule->arm_cc_mapping[ARM_ZF] == 1*/) {
                /* install this rule to the hash table*/
        // pass if (install_counter < 1547)
        // fail if (install_counter < 1548)
                //if (install_counter < 1548)
                // fprintf(stderr, "===== Installing rule =====\n");
                install_rule(rule);
                //if (install_counter == 1547)
                //    fprintf(stderr, "===============rule idx: %d\n", rule->index);
                install_counter++;
            }
            //fprintf(stderr, "===== Finish parsing host =====\n");
        } else
            fprintf(stderr, "Error in parsing rule file: %s.\n", line);
    }

    fprintf(stderr, "== Ready: %d translation rules loaded, %d installed, %d cached.\n\n", counter, install_counter, cache_counter);
    for (i = 0; i < MAX_GUEST_LEN;i++){
        if (cache_rule_table[i]){
            TranslationRule *temp = cache_rule_table[i];
            while(temp->next){
                temp = temp->next;
            }
            temp->next = rule_table[i];
        }
        else
        {
            cache_rule_table[i] = rule_table[i];
        }
        
    }
    // int i;
    // int hash_counter;
    // TranslationRule *p;
    // for (i = 0; i < MAX_GUEST_LEN; i++){
    //     hash_counter = 0;
    //     p = rule_table[i];
    //     while (p){
    //         ++hash_counter;
    //         p = p->next;
    //     }
    //     fprintf(stderr, "== hash table %d: %d\n==", i, hash_counter);
    // }
}

#ifdef PROFILE_RULE_TRANSLATION
void print_rule_hit_num(void );
void print_rule_hit_num(void)
{
    TranslationRule *cur_max;
    int zero_counter = 0;
    int counter[5] = {0};
    int i;

    for (i = 0; i < MAX_GUEST_LEN; i++) {
        TranslationRule *cur_rule = rule_table[i];
        while(cur_rule) {
            if (cur_rule->hit_num == 0)
                zero_counter++;
            cur_rule = cur_rule->next;
        }
    }

    fprintf(stderr, "Rule hit information: %d rules has zero hit.\n", zero_counter);
    fprintf(stderr, "Index  #Guest  #Hit\n");
    while(1) {
        cur_max = NULL;
        for (i = 0; i < MAX_GUEST_LEN; i++) {
            TranslationRule *cur_rule = rule_table[i];
            while(cur_rule) {
                if (cur_rule->print_flag == 0 && 
                    ((cur_max != NULL && cur_rule->hit_num > cur_max->hit_num) ||
                     (cur_max == NULL && cur_rule->hit_num > 0)))
                    cur_max = cur_rule;
                cur_rule = cur_rule->next;
            }
        }
        if (cur_max) {
            fprintf(stderr, "  %u\t%u\t%llu\n", 
                    cur_max->index, cur_max->guest_instr_num, cur_max->hit_num);
            cur_max->print_flag = 1;
            if (cur_max->guest_instr_num > 4)
                counter[4]++;
            else
                counter[cur_max->guest_instr_num-1]++;
        }
        else
            break;
    }
    fprintf(stderr, "\n#Guest    #RuleCounter\n");
    for (i = 0; i < 5; i++)
        if (i == 4)
            fprintf(stderr, " >4           %d\n", counter[i]);
        else
            fprintf(stderr, "  %d           %d\n", i+1, counter[i]);
}
#endif
