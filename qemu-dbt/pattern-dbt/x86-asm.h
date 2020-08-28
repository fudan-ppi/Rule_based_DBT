#ifndef X86_ASM_H
#define X86_ASM_H

#include "x86-instr.h"
#include "rule-translate.h"

typedef struct {
    X86Register sym;
    TCGReg reg;
} HostRegisterMapping;

typedef struct {
    char sym[4];
    TCGLabel *label;
} HostLabelMapping;

typedef struct {
    TCGReg base;
    TCGReg index;
    int scale;
    int offset;
} X86MemoryAddress;

void reset_asm_buffer(void);
void sync_dead_register(TCGContext *, uint32_t *);

void assemble_x86_instruction(TCGContext *, TranslationBlock *, X86Instruction *,
                              uint32_t *, RuleRecord *);
void assemble_x86_exit_tb(TCGContext *, target_ulong);

#endif
