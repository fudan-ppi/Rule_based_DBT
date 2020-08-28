#ifndef X86_PARSE_H
#define X86_PARSE_H

#include "parse.h"

void rule_x86_instr_buf_init(void);
bool parse_rule_x86_code(FILE *fp, TranslationRule *rule);

#endif
