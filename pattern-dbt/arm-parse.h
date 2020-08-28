#ifndef ARM_PARSE_H
#define ARM_PARSE_H

#include "parse.h"

void rule_arm_instr_buf_init(void);
void parse_rule_arm_code(FILE *fp, TranslationRule *rule);

#endif
