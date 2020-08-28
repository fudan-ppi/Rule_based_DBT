#include "qemu/osdep.h"
#include "qemu-common.h"
#include "exec/cpu-common.h"
#include "cpu.h"
#include "exec/exec-all.h"
#include "tcg-op.h"

#include "rule-translate.h"
#include "x86-asm.h"

#define JCC_JMP (-1)
#define JCC_JO  0x0
#define JCC_JNO 0x1
#define JCC_JB  0x2
#define JCC_JAE 0x3
#define JCC_JE  0x4
#define JCC_JNE 0x5
#define JCC_JBE 0x6
#define JCC_JA  0x7
#define JCC_JS  0x8
#define JCC_JNS 0x9
#define JCC_JP  0xa
#define JCC_JNP 0xb
#define JCC_JL  0xc
#define JCC_JGE 0xd
#define JCC_JLE 0xe
#define JCC_JG  0xf

#define DEAD_FLAG(x) (((x) >> 1) & 0x1)
#define SYNC_FLAG(x) ((x) & 0x1)

extern tcg_insn_unit *tb_ret_addr;
extern TCGTemp *get_reg_tcg_temp(TCGContext *s, ARMRegister reg);

#define MAX_BUF_SIZE 20

static HostRegisterMapping h_reg_map_buf[MAX_BUF_SIZE];
static int h_reg_map_buf_index = 0;

static HostLabelMapping h_label_map_buf[MAX_BUF_SIZE];
static int h_label_map_buf_index = 0;

static inline bool is_x86_temp(X86Register reg)
{
    if (reg >= X86_REG_TEMP0 && reg <= X86_REG_TEMP3)
        return true;
    else
        return false;
}

static void remove_host_reg_map(TCGReg reg)
{
    int i, j;
    for (i = 0; i < h_reg_map_buf_index; i++) {
        HostRegisterMapping *rmap = &h_reg_map_buf[i];
        if (rmap->reg != reg)
            continue;
        for (j = i; j < h_reg_map_buf_index - 1; j++) {
            h_reg_map_buf[j] = h_reg_map_buf[j+1];
        }
        h_reg_map_buf_index--;
        break;
    }
}

static void add_host_reg_map(X86Register sym, TCGReg reg)
{
    HostRegisterMapping *rmap = &h_reg_map_buf[h_reg_map_buf_index++];

    assert(h_reg_map_buf_index < MAX_BUF_SIZE);

    rmap->sym = sym;
    rmap->reg = reg;
}

static TCGReg get_host_reg_map(TCGContext *s, X86Register sym, 
                               TCGRegSet desired_regs, TCGRegSet a_regs,
                               bool source)
{
    TCGRegSet allocated_regs;
    TCGReg ret;
    int i;

    if (sym == X86_REG_INVALID)
        return -1;

    for (i = 0; i < h_reg_map_buf_index; i++) {
        HostRegisterMapping *rmap = &h_reg_map_buf[i];
        if (rmap->sym == sym) {
            //TCGTemp *ts = s->reg_to_temp[rmap->reg];
            //if (!ts || ts->val_type != TEMP_VAL_REG)
            //    fprintf(stderr, "[x86] Something wrong when get host register map!\n");
            return rmap->reg;
        }
    }

    /* If we cannot find it, try to add the map based on the type */
    TCGTemp *ts;
    tcg_regset_set(allocated_regs, s->reserved_regs);
    tcg_regset_or(allocated_regs, allocated_regs, a_regs);
    if (!is_x86_temp(sym)) {
        ts = get_reg_tcg_temp(s, get_guest_reg_map(sym));
        //fprintf(stderr, "ts: %p, reg_to_temp: %p\n", ts, s->reg_to_temp[3]);
        /* Might introduce unexpected register spill,
           so do not spill registers used in the same instruction */
        temp_load_rule(s, ts, desired_regs, allocated_regs, source);
    } else
        ts = tcg_temp_alloc_rule(s, desired_regs, allocated_regs);

    ret = ts->reg;
    remove_host_reg_map(ret);
    add_host_reg_map(sym, ret);

    return ret;
}

static TCGLabel *get_host_label_map(TCGContext *s, X86ImmOperand *imm)
{
    int i;

    /*TODO: add L to label oeprand */
    //if (imm->type != X86_IMM_TYPE_SYM)
    //    fprintf(stderr, "[x86] Something wrong when get x86 label map.\n");

    for (i = 0; i < h_label_map_buf_index; i++) {
        HostLabelMapping *lmap = &h_label_map_buf[i];
        if (!strcmp(lmap->sym, imm->content.sym))
            return lmap->label;
    }

    /* We need to generate a new label */
    HostLabelMapping *lmap = &h_label_map_buf[h_label_map_buf_index++];
    strcpy(lmap->sym, imm->content.sym);
    lmap->label = gen_new_label();

    assert(h_label_map_buf_index < MAX_BUF_SIZE);

    return lmap->label;
}


void sync_dead_register(TCGContext *s, uint32_t *reg_liveness)
{
    int i;
    for (i = 1; i < s->nb_globals; i++) {
        TCGTemp *ts = &s->temps[i];

        /* sync this register to memory */
        if (SYNC_FLAG(reg_liveness[i])) {
            tcg_sync_global(s, ts);
        }
        /* mark this register to be dead*/
        if (DEAD_FLAG(reg_liveness[i])) {
            if (ts->val_type == TEMP_VAL_REG && 
                s->reg_to_temp[ts->reg] == ts)
                s->reg_to_temp[ts->reg] = NULL;
            ts->val_type = TEMP_VAL_MEM;
        }
    }
}

#if 0
static void update_mem_coherent_flag(TCGContext *s, TCGReg reg, uint32_t sync_flag)
{
    TCGTemp *ts = s->reg_to_temp[reg];

    if (!ts)
        return;
    if (sync_flag)
        tcg_sync_global(s, ts); 
    else
        ts->mem_coherent = 0;
}
#endif

static void clear_mem_coherent_flag(TCGContext *s, TCGReg reg)
{
    TCGTemp *ts = s->reg_to_temp[reg];

    if (!ts)
        return;
    ts->mem_coherent = 0;
}

#if 0
static int get_offset_map_wrapper(X86Imm *poff)
{
    if (poff->type == X86_IMM_TYPE_VAL)
        return poff->content.val;

    return get_offset_map(poff->content.sym);
}
#endif

static int get_imm_map_wrapper(X86Imm *imm)
{
    if (imm->type == X86_IMM_TYPE_NONE)
        return 0;

    if (imm->type == X86_IMM_TYPE_VAL)
        return imm->content.val;

    return get_imm_map(imm->content.sym);
}

static void get_memory_address(TCGContext *s, X86MemOperand *mopd,
                               X86MemoryAddress *mem_addr, TCGRegSet *p_alloc_regs)
{
    TCGRegSet allocated_regs, desired_regs;
    TCGReg base, index;
    int offset = 0;
    int scale;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    
    base = get_host_reg_map(s, mopd->base, desired_regs, allocated_regs, true);
    tcg_regset_set_reg(allocated_regs, base);

    scale = get_imm_map_wrapper(&mopd->scale);
    if(scale == 0)
        scale = 1;

    /* If index is a constant and not allocated for host register, we can put it into offset
       to reduce register allocation pressure */
    index = -1;
    if (mopd->index != X86_REG_INVALID) {
        assert(!is_x86_temp(mopd->index));
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(mopd->index));
        if (ts->val_type == TEMP_VAL_CONST) {
            offset = ts->val * scale;
            scale = 1;
            index = -1;
        } else {
            index = get_host_reg_map(s, mopd->index, desired_regs, allocated_regs, true);
            if (index != -1)
                tcg_regset_set_reg(allocated_regs, index);
        }
    }
    offset += get_imm_map_wrapper(&mopd->offset);
    
    mem_addr->base = base;
    mem_addr->index = index;
    mem_addr->scale = scale;
    mem_addr->offset = offset;

    tcg_regset_or((*p_alloc_regs), (*p_alloc_regs), allocated_regs);
}

static void assemble_movb(TCGContext *s, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    X86MemoryAddress mem_addr;
    TCGReg data;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_MEM && opd1->type == X86_OPD_TYPE_REG) {
        /* movb from memory to register */
        get_memory_address(s, &opd0->content.mem, &mem_addr, &allocated_regs);
        assert(mem_addr.scale <= 8);

        /* check if data is already in a register that is not eax, ebx, ecx, and edx */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd1->content.reg.num));
        if (ts->val_type == TEMP_VAL_REG &&
            ts->reg != TCG_REG_EAX && ts->reg != TCG_REG_EBX &&
            ts->reg != TCG_REG_ECX && ts->reg != TCG_REG_EDX) {
            if (s->reg_to_temp[TCG_REG_EAX] == NULL)
                data = TCG_REG_EAX;
            else if (s->reg_to_temp[TCG_REG_EBX] == NULL)
                data = TCG_REG_EBX;
            else if (s->reg_to_temp[TCG_REG_ECX] == NULL)
                data = TCG_REG_ECX;
            else if (s->reg_to_temp[TCG_REG_EDX] == NULL)
                data = TCG_REG_EDX;
            else
                assert(0);
            tcg_out_movl_rr_rule(s, ts->reg, data);
            s->reg_to_temp[ts->reg] = NULL;
            s->reg_to_temp[data] = ts;
            ts->reg = data;
        } else {
            tcg_regset_clear(desired_regs);
            tcg_regset_set_reg(desired_regs, TCG_REG_EAX);
            tcg_regset_set_reg(desired_regs, TCG_REG_EBX);
            tcg_regset_set_reg(desired_regs, TCG_REG_ECX);
            tcg_regset_set_reg(desired_regs, TCG_REG_EDX);
            data = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        }
        tcg_out_movb_ld_rule(s, data, mem_addr.base, mem_addr.index, mem_addr.scale, mem_addr.offset);
        clear_mem_coherent_flag(s, data);
    } else if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_MEM) {
        /* movb from register to memory */
        get_memory_address(s, &opd1->content.mem, &mem_addr, &allocated_regs);
        assert(mem_addr.scale <= 8);

        /* check if data is already in a register that is not eax, ebx, ecx, and edx */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd0->content.reg.num));
        if (ts->val_type == TEMP_VAL_REG &&
            ts->reg != TCG_REG_EAX && ts->reg != TCG_REG_EBX &&
            ts->reg != TCG_REG_ECX && ts->reg != TCG_REG_EDX) {
            if (s->reg_to_temp[TCG_REG_EAX] == NULL)
                data = TCG_REG_EAX;
            else if (s->reg_to_temp[TCG_REG_EBX] == NULL)
                data = TCG_REG_EBX;
            else if (s->reg_to_temp[TCG_REG_ECX] == NULL)
                data = TCG_REG_ECX;
            else if (s->reg_to_temp[TCG_REG_EDX] == NULL)
                data = TCG_REG_EDX;
            else {
                /* free a register for movb */
                if (!tcg_regset_test_reg(allocated_regs, TCG_REG_EAX)) {
                    free_reg(s, TCG_REG_EAX);
                    data = TCG_REG_EAX;
                } else if (!tcg_regset_test_reg(allocated_regs, TCG_REG_EBX)) {
                    free_reg(s, TCG_REG_EBX);
                    data = TCG_REG_EBX;
                } else if (!tcg_regset_test_reg(allocated_regs, TCG_REG_ECX)) {
                    free_reg(s, TCG_REG_ECX);
                    data = TCG_REG_ECX;
                } else
                    assert(0);
            }
            tcg_out_movl_rr_rule(s, ts->reg, data);
        } else {
            tcg_regset_clear(desired_regs);
            tcg_regset_set_reg(desired_regs, TCG_REG_EAX);
            tcg_regset_set_reg(desired_regs, TCG_REG_EBX);
            tcg_regset_set_reg(desired_regs, TCG_REG_ECX);
            tcg_regset_set_reg(desired_regs, TCG_REG_EDX);
            data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
        }
        tcg_out_movb_st_rule(s, data, mem_addr.base, mem_addr.index, mem_addr.scale, mem_addr.offset);
    } else if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_MEM) {
        get_memory_address(s, &opd1->content.mem, &mem_addr, &allocated_regs);
        int32_t imm = get_imm_map_wrapper(&opd0->content.imm);

        tcg_out_movb_im_rule(s, imm, mem_addr.base, mem_addr.index, mem_addr.scale, mem_addr.offset);
    } else
        fprintf(stderr, "[x86] Unsupported operand type for movb instruction.\n");
}

static void assemble_movzbl(TCGContext *s, X86Instruction *instr, uint32_t *reg_liveness)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    X86MemoryAddress mem_addr;
    TCGReg data, dest;

    tcg_regset_clear(allocated_regs);
    tcg_regset_set(allocated_regs, s->reserved_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_MEM && opd1->type == X86_OPD_TYPE_REG) {
        /* movzbl from memory to register */
        get_memory_address(s, &opd0->content.mem, &mem_addr, &allocated_regs);

        /* If the base register is dead after this instrution,
           we can allocate it as the dest register to reduce register allocation pressure */
        if (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd0->content.mem.base)]) &&
            is_last_access(instr, opd0->content.mem.base) && opd0->content.mem.base != opd1->content.reg.num) {
            tcg_regset_reset_reg(allocated_regs, mem_addr.base);
            if (SYNC_FLAG(reg_liveness[get_guest_reg_map(opd0->content.mem.base)]) &&
                s->reg_to_temp[mem_addr.base]->mem_coherent == 0) {
                tcg_sync_global(s, s->reg_to_temp[mem_addr.base]);
            }
            s->reg_to_temp[mem_addr.base]->val_type = TEMP_VAL_MEM;
            s->reg_to_temp[mem_addr.base] = NULL;
        }

        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, false);
        tcg_regset_set_reg(allocated_regs, dest);

        if (mem_addr.scale > 8) {
            TCGReg index_reg;
            int tscale;
            for (tscale = 4; tscale < 15; tscale++) {
                if ((1 << tscale) == mem_addr.scale)
                    break;
            }
            assert(tscale > 3 && tscale < 15);
            if (!DEAD_FLAG(reg_liveness[get_guest_reg_map(opd0->content.mem.index)])) {
                /* allocate a temporary register to hold the value after shift */
                tcg_regset_set_reg(allocated_regs, mem_addr.base);
                index_reg = tcg_reg_alloc_rule(s, desired_regs, allocated_regs);
                tcg_out_movl_rr_rule(s, mem_addr.index, index_reg);
            } else
                index_reg = mem_addr.index;
            tcg_out_shll_ir_rule(s, tscale, index_reg);
            tcg_out_qemu_ld_rule(s, dest, mem_addr.base, index_reg,
                                 1, mem_addr.offset, MO_UB);
        } else
            tcg_out_qemu_ld_rule(s, dest, mem_addr.base, mem_addr.index, mem_addr.scale,
                             mem_addr.offset, MO_UB);
        //update_mem_coherent_flag(s, dest, SYNC_FLAG(reg_liveness[get_guest_reg_map(opd1->content.reg.num)]));
        clear_mem_coherent_flag(s, dest);
    } else if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG) {
        /* movzbl from register to register */

        /* check if data is already in a register that is not eax, ebx, ecx, and edx */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd0->content.reg.num));
        if (ts->val_type == TEMP_VAL_REG && 
            ts->reg != TCG_REG_EAX && ts->reg != TCG_REG_EBX &&
            ts->reg != TCG_REG_ECX && ts->reg != TCG_REG_EDX) {
            if (s->reg_to_temp[TCG_REG_EAX] == NULL)
                data = TCG_REG_EAX;
            else if (s->reg_to_temp[TCG_REG_EBX] == NULL)
                data = TCG_REG_EBX;
            else if (s->reg_to_temp[TCG_REG_ECX] == NULL)
                data = TCG_REG_ECX;
            else if (s->reg_to_temp[TCG_REG_EDX] == NULL)
                data = TCG_REG_EDX;
            else {
                fprintf(stderr, "Cannot allocate reg for movzbl\n");
                exit(0);
            }
            tcg_out_movl_rr_rule(s, ts->reg, data);
        } else {
            tcg_regset_clear(desired_regs);
            tcg_regset_set_reg(desired_regs, TCG_REG_EAX);
            tcg_regset_set_reg(desired_regs, TCG_REG_EBX);
            tcg_regset_set_reg(desired_regs, TCG_REG_ECX);
            tcg_regset_set_reg(desired_regs, TCG_REG_EDX);
            data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
            tcg_regset_set(allocated_regs, data);
        }
        /* If the source register is dead, then we can allocate it for dest register */
        if (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd0->content.reg.num)]) &&
            opd0->content.reg.num != opd1->content.reg.num) {
            /* Sync the source regsiter if necessary */
            if (SYNC_FLAG(reg_liveness[get_guest_reg_map(opd0->content.reg.num)]))
                tcg_sync_global(s, ts);
            tcg_regset_reset_reg(allocated_regs, data);
            if (s->reg_to_temp[data]) {
                s->reg_to_temp[data]->val_type = TEMP_VAL_MEM;
                s->reg_to_temp[data] = NULL;
            }
        }
        desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, false);
        tcg_out_movzbl_rr_rule(s, data, dest);
        clear_mem_coherent_flag(s, dest);
    } else
        fprintf(stderr, "[x86] Unsupported operand type for movzbl instruction.\n");
}

static void assemble_movw(TCGContext *s, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    X86MemoryAddress mem_addr;
    TCGReg data;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_MEM) {
        /* movw from register to memory */
        get_memory_address(s, &opd1->content.mem, &mem_addr, &allocated_regs);
        data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);

        // fprintf(stderr, "%d %d %d %d\n", mem_addr.base, mem_addr.index, mem_addr.scale,
                            //  mem_addr.offset);

        tcg_out_movw_st_rule(s, data, mem_addr.base, mem_addr.index, mem_addr.scale,
                             mem_addr.offset);
    } else
        fprintf(stderr, "[x86] Unsupported operand type for movw instruction.\n");
}

static void assemble_movzwl(TCGContext *s, X86Instruction *instr, uint32_t *reg_liveness)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    X86MemoryAddress mem_addr;
    TCGReg dest;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_MEM && opd1->type == X86_OPD_TYPE_REG) {
        /* movzwl from memory to register */
        get_memory_address(s, &opd0->content.mem, &mem_addr, &allocated_regs);

        /* If the base register is dead after this instrution,
           we can allocate it as the dest register to reduce register allocation pressure */
        if (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd0->content.mem.base)]) &&
            is_last_access(instr, opd0->content.mem.base) && opd0->content.mem.base != opd1->content.reg.num) {
            /* sync the source register if required */
            if (SYNC_FLAG(reg_liveness[get_guest_reg_map(opd0->content.mem.base)]))
                tcg_sync_global(s, s->reg_to_temp[mem_addr.base]);
            tcg_regset_reset_reg(allocated_regs, mem_addr.base);
            s->reg_to_temp[mem_addr.base]->val_type = TEMP_VAL_MEM;
            s->reg_to_temp[mem_addr.base] = NULL;
        }

        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, false);

        tcg_out_qemu_ld_rule(s, dest, mem_addr.base, mem_addr.index, mem_addr.scale,
                             mem_addr.offset, MO_UW);
        //update_mem_coherent_flag(s, dest, SYNC_FLAG(reg_liveness[get_guest_reg_map(opd1->content.reg.num)]));
        clear_mem_coherent_flag(s, dest);
    } else
        fprintf(stderr, "[x86] Unsupported operand type for movzwl instruction.\n");
}

static void assemble_movl(TCGContext *s, TranslationBlock *tb, X86Instruction *instr, uint32_t *reg_liveness)
{
    X86Operand *opd1 = &instr->opd[0];
    X86Operand *opd2 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    X86MemoryAddress mem_addr;
    TCGReg data, dest;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd1->type == X86_OPD_TYPE_MEM && opd2->type == X86_OPD_TYPE_REG) {
        /* movl from memory to register */
        tcg_regset_set(allocated_regs, s->reserved_regs);
        get_memory_address(s, &opd1->content.mem, &mem_addr, &allocated_regs);

        /* If the base register is dead after this instrution,
           we can allocate it as the dest register to reduce register allocation pressure */
        if (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd1->content.mem.base)])
            && is_last_access(instr, opd1->content.mem.base)
            && opd1->content.mem.base != opd2->content.reg.num
            && opd1->content.mem.base != opd1->content.mem.index) {
            /* sync the source register if required */
            if (SYNC_FLAG(reg_liveness[get_guest_reg_map(opd1->content.mem.base)]))
                tcg_sync_global(s, s->reg_to_temp[mem_addr.base]);
            tcg_regset_reset_reg(allocated_regs, mem_addr.base);
            s->reg_to_temp[mem_addr.base]->val_type = TEMP_VAL_MEM;
            s->reg_to_temp[mem_addr.base] = NULL;
        }
        data = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, false);
        tcg_regset_set_reg(allocated_regs, data);
        if (mem_addr.scale > 8) {
            TCGReg index_reg;
            int tscale;
            for (tscale = 4; tscale < 15; tscale++) {
                if ((1 << tscale) == mem_addr.scale)
                    break;
            }
            assert(tscale > 3 && tscale < 15);
            if (!DEAD_FLAG(reg_liveness[get_guest_reg_map(opd1->content.mem.index)]) ||
                !is_last_access(instr, opd1->content.mem.index)) {
                /* allocate a temporary register to hold the value after shift */
                tcg_regset_set_reg(allocated_regs, mem_addr.base);
                index_reg = tcg_reg_alloc_rule(s, desired_regs, allocated_regs);
                tcg_out_movl_rr_rule(s, mem_addr.index, index_reg);
            } else
                index_reg = mem_addr.index;
            tcg_out_shll_ir_rule(s, tscale, index_reg);
            tcg_out_qemu_ld_rule(s, data, mem_addr.base, index_reg,
                                 1, mem_addr.offset, MO_UL);
        } else
            tcg_out_qemu_ld_rule(s, data, mem_addr.base, mem_addr.index,
                                 mem_addr.scale, mem_addr.offset, MO_UL);
        clear_mem_coherent_flag(s, data);
    } else if (opd1->type == X86_OPD_TYPE_REG && opd2->type == X86_OPD_TYPE_MEM) {
        /* movl from register to memory */
        tcg_regset_set(allocated_regs, s->reserved_regs);
        get_memory_address(s, &opd2->content.mem, &mem_addr, &allocated_regs);
        data = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        tcg_regset_set_reg(allocated_regs, data);
        if (mem_addr.scale > 8) {
            #if 0
            TCGTemp *ts = &s->temps[get_guest_reg_map(opd2->content.mem.index)];
            if (ts->val_type == TEMP_VAL_CONST) {
                mem_addr.offset += ts->val * mem_addr.scale;
                tcg_out_qemu_st_rule(s, data, mem_addr.base, -1,
                                1, mem_addr.offset, MO_UL, 0);
            } else
            #endif
            {
                TCGReg index_reg;
                int tscale;
                for (tscale = 4; tscale < 15; tscale++) {
                    if ((1 << tscale) == mem_addr.scale)
                        break;
                }
                //fprintf(stderr, "==========mem_addr.scale: %d, tb->pc: %x\n", mem_addr.scale, tb->pc);
                assert(tscale > 3 && tscale < 15);
                if (!DEAD_FLAG(reg_liveness[get_guest_reg_map(opd2->content.mem.index)])) {
                    /* allocate a temporary register to hold the value after shift */
                    index_reg = tcg_reg_alloc_rule(s, desired_regs, allocated_regs);
                    tcg_out_movl_rr_rule(s, mem_addr.index, index_reg);
                } else
                    index_reg = mem_addr.index;
                tcg_out_shll_ir_rule(s, tscale, index_reg);
                tcg_out_qemu_st_rule(s, data, mem_addr.base, index_reg,
                                1, mem_addr.offset, MO_UL, 0);
                if (s->cur_cc_source == 1)
                    s->cur_cc_source = 2;
                else if (s->cur_cc_source == 3)
                    s->cur_cc_source = 4;
            }
        } else
            tcg_out_qemu_st_rule(s, data, mem_addr.base, mem_addr.index,
                             mem_addr.scale, mem_addr.offset, MO_UL, 0);
    } else if (opd1->type == X86_OPD_TYPE_IMM && opd2->type == X86_OPD_TYPE_REG) {
        /* movl from immediate to register */
        int32_t imm = get_imm_map_wrapper(&opd1->content.imm);

        /* If the register is in memory, we can suppress a mov */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd2->content.reg.num));
        if (ts->val_type == TEMP_VAL_MEM
            || DEAD_FLAG(reg_liveness[get_guest_reg_map(opd2->content.reg.num)])) {
            if (ts->val_type == TEMP_VAL_REG)
                s->reg_to_temp[ts->reg] = NULL;
            ts->mem_coherent = 0;
            if (!SYNC_FLAG(reg_liveness[get_guest_reg_map(opd2->content.reg.num)])) {
                ts->val_type = TEMP_VAL_CONST;
                ts->val = imm;
            } else {
                tcg_out_qemu_st_rule(s, imm, ts->mem_base->reg, -1, 1, ts->mem_offset, MO_UL, 1);
                ts->val_type = TEMP_VAL_MEM;
            }
        } else {
            data = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, false);
        
            tcg_out_movl_ir_rule(s, imm, data);
            clear_mem_coherent_flag(s, data);
        }
    } else if (opd1->type == X86_OPD_TYPE_REG && opd2->type == X86_OPD_TYPE_REG) {
        /* movl from register to register */
        if (opd1->content.reg.num == opd2->content.reg.num)
            return;
        #if 0
        fprintf(stderr, "=============src r%d dead flag: %d\n", get_guest_reg_map(opd1->content.reg.num) - 1,
                    DEAD_FLAG(reg_liveness[get_guest_reg_map(opd1->content.reg.num)]));
        fprintf(stderr, "============dest r%d sync flag: %d\n", get_guest_reg_map(opd2->content.reg.num) - 1,
                    SYNC_FLAG(reg_liveness[get_guest_reg_map(opd2->content.reg.num)]));
        #endif
        data = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        /* If the source register is dead after this instruction, we can suppress a mov */
        if (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd1->content.reg.num)]) && 
            is_last_access(instr, opd1->content.reg.num)) {
            TCGTemp *ots = &s->temps[get_guest_reg_map(opd2->content.reg.num)];
            TCGTemp *ts = &s->temps[get_guest_reg_map(opd1->content.reg.num)];
            #if 1
            /* sync the source register if required */
            if (SYNC_FLAG(reg_liveness[get_guest_reg_map(opd1->content.reg.num)]))
                tcg_sync_global(s, ts);
            #endif
            if (ots->val_type == TEMP_VAL_REG)
                s->reg_to_temp[ots->reg] = NULL;
            dest = ots->reg = ts->reg;
            if (ts->val_type == TEMP_VAL_REG)
                s->reg_to_temp[ts->reg] = NULL;
            ts->val_type = TEMP_VAL_MEM;
            ots->val_type = TEMP_VAL_REG;
            ots->mem_coherent = 0;
            s->reg_to_temp[ots->reg] = ots;
            clear_mem_coherent_flag(s, dest);
        } else {
            if (SYNC_FLAG(reg_liveness[get_guest_reg_map(opd2->content.reg.num)]) &&
                DEAD_FLAG(reg_liveness[get_guest_reg_map(opd2->content.reg.num)]) &&
                is_last_access(instr, opd2->content.reg.num)) {
                /* No need to allocate a new register, just use the source register and sync it */
                TCGTemp *ots = &s->temps[get_guest_reg_map(opd2->content.reg.num)];
                if (ots->val_type == TEMP_VAL_REG)
                    s->reg_to_temp[ots->reg] = NULL;
                ots->val_type = TEMP_VAL_REG;
                ots->mem_coherent = 0;
                ots->reg = data;
                tcg_sync_global(s, ots);
                ots->val_type = TEMP_VAL_MEM;
            } else {
                tcg_regset_set_reg(allocated_regs, data);
                dest = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, false);
                if (data != dest)
                    tcg_out_movl_rr_rule(s, data, dest);
                clear_mem_coherent_flag(s, dest);
            }
        }
        //update_mem_coherent_flag(s, dest, SYNC_FLAG(reg_liveness[get_guest_reg_map(opd2->content.reg.num)]));
        //clear_mem_coherent_flag(s, dest);
    } else if (opd1->type == X86_OPD_TYPE_IMM && opd2->type == X86_OPD_TYPE_MEM) {
        /* movl from immediate to memory */
        int32_t imm = get_imm_map_wrapper(&opd1->content.imm);
        get_memory_address(s, &opd2->content.mem, &mem_addr, &allocated_regs);
        tcg_out_qemu_st_rule(s, imm, mem_addr.base, mem_addr.index,
                             mem_addr.scale, mem_addr.offset, MO_UL, 1);
    } else
        fprintf(stderr, "Unsupported operand type for movl instruction.\n");
}

static void assemble_leal(TCGContext *s, TranslationBlock *tb, X86Instruction *instr, uint32_t *reg_liveness)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    X86MemoryAddress mem_addr;
    TCGReg data;

    tcg_regset_set(allocated_regs, s->reserved_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_MEM && opd1->type == X86_OPD_TYPE_REG) {
        /* leal memory address to a register */

        /* check if we can suppress ld/st ops, only for add two register */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd1->content.reg.num));
        if (SYNC_FLAG(reg_liveness[get_guest_reg_map(opd1->content.reg.num)])
            && ts->val_type == TEMP_VAL_MEM
            && opd0->content.mem.index == X86_REG_INVALID
            && opd0->content.mem.base == opd1->content.reg.num
            && (s->cur_cc_source != 1 && s->cur_cc_source != 3)) {
            int imm = get_imm_map_wrapper(&opd0->content.mem.offset);
            tcg_out_addl_im_rule(s, imm, ts->mem_base->reg, ts->mem_offset);
            return;
        }
        if (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd1->content.reg.num)])
            && (ts->val_type == TEMP_VAL_MEM
                || (ts->val_type == TEMP_VAL_REG && ts->mem_coherent == 1))
            && is_last_access(instr, opd1->content.reg.num)
            && s->cur_cc_source != 1 && s->cur_cc_source != 3) {
            if (opd0->content.mem.index != X86_REG_INVALID
                && opd0->content.mem.scale.type == X86_IMM_TYPE_NONE
                && (opd0->content.mem.base == opd1->content.reg.num
                    || opd0->content.mem.index == opd1->content.reg.num)
                && (opd0->content.mem.offset.type == X86_IMM_TYPE_NONE
                    || (opd0->content.mem.offset.type == X86_IMM_TYPE_VAL
                        && opd0->content.mem.offset.content.val == 0))) {
                TCGReg data;
                if (opd0->content.mem.base == opd1->content.reg.num)
                    data = get_host_reg_map(s, opd0->content.mem.index, desired_regs, allocated_regs, true);
                else
                    data = get_host_reg_map(s, opd0->content.mem.base, desired_regs, allocated_regs, true);
                tcg_out_addm_rule(s, data, ts->mem_base->reg, ts->mem_offset);
                if (ts->val_type == TEMP_VAL_REG) {
                    ts->val_type = TEMP_VAL_MEM;
                    ts->mem_coherent = 0;
                    s->reg_to_temp[ts->reg] = NULL;
                }
                return;
            } else if (opd0->content.mem.index == X86_REG_INVALID
                       && opd0->content.mem.base == opd1->content.reg.num
                       && s->cur_cc_source != 1 && s->cur_cc_source != 3) {
                int imm = get_imm_map_wrapper(&opd0->content.mem.offset);
                tcg_out_addl_im_rule(s, imm, ts->mem_base->reg, ts->mem_offset);
                if (ts->val_type == TEMP_VAL_REG) {
                    ts->val_type = TEMP_VAL_MEM;
                    ts->mem_coherent = 0;
                    s->reg_to_temp[ts->reg] = NULL;
                }
                return;
            }
        }

        get_memory_address(s, &opd0->content.mem, &mem_addr, &allocated_regs);
        /* If the base register is dead after this instruciton, we can use it as the dest register
           to reduce register allocation pressure */
        if (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd0->content.mem.base)]) &&
            opd0->content.mem.base != opd1->content.reg.num &&
            is_last_access(instr, opd1->content.mem.base)) {
            tcg_regset_reset_reg(allocated_regs, mem_addr.base);
            if (SYNC_FLAG(reg_liveness[get_guest_reg_map(opd0->content.mem.base)]) &&
                s->reg_to_temp[mem_addr.base]->mem_coherent == 0) {
                tcg_sync_global(s, s->reg_to_temp[mem_addr.base]);
            }
            s->reg_to_temp[mem_addr.base]->val_type = TEMP_VAL_MEM;
            s->reg_to_temp[mem_addr.base] = NULL;
        }
        data = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, false);
        tcg_regset_set_reg(allocated_regs, data);
        //fprintf(stderr, "==== leal scale: %d\n", mem_addr.scale);
        if(mem_addr.scale > 8) {
            TCGReg index_reg;
            int tscale;
            for (tscale = 4; tscale < 30; tscale++) {
                if ((1 << tscale) == mem_addr.scale)
                    break;
            }
            //fprintf(stderr, "============scale: %d, tb->pc: %x\n", mem_addr.scale, tb->pc);
            assert(tscale > 3 && tscale < 30);
            if ((!DEAD_FLAG(reg_liveness[get_guest_reg_map(opd0->content.mem.index)]) &&
                opd0->content.mem.index != opd1->content.reg.num) ||
                (opd0->content.mem.index == opd0->content.mem.base)) {
                // allocate a temporary register to hold the value after shift
                //if (opd0->content.mem.index == opd0->content.mem.base)
                    tcg_regset_set_reg(allocated_regs, mem_addr.base);
                index_reg = tcg_reg_alloc_rule(s, desired_regs, allocated_regs);
                tcg_out_movl_rr_rule(s, mem_addr.index, index_reg);
            } else
                index_reg = mem_addr.index;
            tcg_out_shll_ir_rule(s, tscale, index_reg);
            tcg_out_leal_rule(s, data, mem_addr.base, index_reg,
                          1, mem_addr.offset);
            if (s->cur_cc_source == 1 || s->cur_cc_source == 3)
                s->cur_cc_source ++;
        } else {
            tcg_out_leal_rule(s, data, mem_addr.base, mem_addr.index,
                          mem_addr.scale, mem_addr.offset);
        }
        //update_mem_coherent_flag(s, data, SYNC_FLAG(reg_liveness[get_guest_reg_map(opd1->content.reg.num)]));
        clear_mem_coherent_flag(s, data);
    } else
        fprintf(stderr, "[x86] Unsupported operand type for leal instruction.\n");
}

static void assemble_negl(TCGContext *s, TranslationBlock *tb, X86Instruction *instr,
                          RuleRecord *rrule)
{
    X86Operand *opd0 = &instr->opd[0];
    TCGRegSet allocated_regs, desired_regs;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_REG) {
        /* negl register */
        TCGReg dest = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);

        tcg_out_negl_r_rule(s, dest);
        clear_mem_coherent_flag(s, dest);
    } else
        fprintf(stderr, "[x86] Unsupported operand type for negl instruction.\n");

    if (rrule->update_cc) {
        s->cur_cc_source = 1;
        if (rrule->save_cc || (s->succ_define_cc != 3 && is_last_cc_definition(s, rrule->next_pc))) {
            tcg_out_set_cc_source(s, tb);
            /* Here cur_cc_source is delayed to be set to 2 in case there are instructions that use 
               host condition codes before they are modified */
        }
    }
}

static void assemble_andb(TCGContext *s, TranslationBlock *tb, X86Instruction *instr,
                          RuleRecord *rrule)
{
    X86Operand *opd1 = &instr->opd[0];
    X86Operand *opd2 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];                                                                   
    if (opd1->type == X86_OPD_TYPE_IMM && opd2->type == X86_OPD_TYPE_REG) {
        TCGReg dreg = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, true);
        int32_t imm = get_imm_map_wrapper(&opd1->content.imm);
        tcg_out_andb_ir_rule(s, dreg, imm);
        clear_mem_coherent_flag(s, dreg);
    } else
        fprintf(stderr, "Unsupported operand type for andb instruction.\n");
}

static void assemble_andl(TCGContext *s, TranslationBlock *tb, X86Instruction *instr,
                          RuleRecord *rrule)
{
    X86Operand *opd1 = &instr->opd[0];
    X86Operand *opd2 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    X86MemoryAddress mem_addr;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd1->type == X86_OPD_TYPE_IMM && opd2->type == X86_OPD_TYPE_REG) {
        /* andl immediate with register */
        TCGReg dreg = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, true);
        int32_t imm = get_imm_map_wrapper(&opd1->content.imm);

        tcg_out_and_ir_rule(s, dreg, imm);
        clear_mem_coherent_flag(s, dreg);
    } else if (opd1->type == X86_OPD_TYPE_MEM && opd2->type == X86_OPD_TYPE_REG) {
        /* andl memory with register */
        get_memory_address(s, &opd1->content.mem, &mem_addr, &allocated_regs);
        TCGReg dest = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, true);
        tcg_out_and_mr_rule(s, dest, mem_addr.base, mem_addr.index,
                             mem_addr.scale, mem_addr.offset);
        clear_mem_coherent_flag(s, dest);
    } else if (opd1->type == X86_OPD_TYPE_REG && opd2->type == X86_OPD_TYPE_REG) {
        /* andl register with register */
        TCGReg data = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        tcg_regset_set_reg(allocated_regs, data);
        TCGReg dest = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, true);

        tcg_out_andl_rr_rule(s, data, dest);
        clear_mem_coherent_flag(s, dest);
    } else
        fprintf(stderr, "Unsupported operand type for andl instruction.\n");

    if (rrule->update_cc) {
        s->cur_cc_source = 1;
        if (rrule->save_cc || (s->succ_define_cc != 3 && is_last_cc_definition(s, rrule->next_pc))) {
            tcg_out_set_cc_source(s, tb);
            /* Here cur_cc_source is delayed to be set to 2 in case there are instructions that use 
               host condition codes before they are modified */
        }
    } else if (s->cur_cc_source == 1 || s->cur_cc_source == 3)
        s->cur_cc_source += 1;
}

static void assemble_orl(TCGContext *s, TranslationBlock *tb, X86Instruction *instr,
                         RuleRecord *rrule)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];    
    TCGRegSet allocated_regs, desired_regs;
    X86MemoryAddress mem_addr;
    TCGReg data, dest;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_MEM) {
        /* orl register with memory */
        get_memory_address(s, &opd1->content.mem, &mem_addr, &allocated_regs);
        data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);

        tcg_out_orl_rm_rule(s, data, mem_addr.base, mem_addr.index,
                            mem_addr.scale, mem_addr.offset);
    } else if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG) {
        /* orl register with regsiter */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd0->content.reg.num));
        TCGTemp *ts2 = get_reg_tcg_temp(s, get_guest_reg_map(opd1->content.reg.num));
        if (ts->val_type == TEMP_VAL_MEM) {
            dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
            tcg_out_orl_mr_rule(s, dest, ts->mem_base->reg, -1, 1, ts->mem_offset);
            clear_mem_coherent_flag(s, dest);
        } else if (ts2->val_type == TEMP_VAL_MEM) {
            data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
            tcg_out_orl_rm_rule(s, data, ts2->mem_base->reg, -1, 1, ts2->mem_offset);
        } else {
            dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
            tcg_regset_set(allocated_regs, dest);
            data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
            tcg_regset_set(allocated_regs, data);
            tcg_out_orl_rr_rule(s, data, dest);
            clear_mem_coherent_flag(s, dest);
        }
    } else if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_REG) {
        /* orl immediate with register */
        int32_t imm = get_imm_map_wrapper(&opd0->content.imm);
        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);

        tcg_out_orl_ir_rule(s, imm, dest);
        clear_mem_coherent_flag(s, dest);
    } else if (opd0->type == X86_OPD_TYPE_MEM && opd1->type == X86_OPD_TYPE_REG) {
        /* orl memory with register */
        get_memory_address(s, &opd0->content.mem, &mem_addr, &allocated_regs);
        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);

        assert(mem_addr.scale < 9);
        tcg_out_orl_mr_rule(s, dest, mem_addr.base, mem_addr.index, mem_addr.scale, mem_addr.offset);
        clear_mem_coherent_flag(s, dest);
    } else
        fprintf(stderr, "[x86] Unsupported operand type for orl instruction.\n");    

    if (rrule->update_cc) {
        s->cur_cc_source = 1;
        if (rrule->save_cc || (s->succ_define_cc != 3 && is_last_cc_definition(s, rrule->next_pc))) {
            tcg_out_set_cc_source(s, tb);
            /* Here cur_cc_source is delayed to be set to 2 in case there are instructions that use 
               host condition codes before they are modified */
        }
    } else if (s->cur_cc_source == 1 || s->cur_cc_source == 3)
        s->cur_cc_source += 1;
}

static void assemble_xorl(TCGContext *s, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    TCGReg data, dest;
    int32_t imm;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG) {
        /* xorl register with register */
        data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
        tcg_regset_set(allocated_regs, data);
        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        tcg_out_xorl_rr_rule(s, data, dest);
        clear_mem_coherent_flag(s, dest);
    } else if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_REG) {
        /* xorl immediate with register */
        imm = get_imm_map_wrapper(&opd0->content.imm);
        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);

        tcg_out_xorl_ir_rule(s, imm, dest);
        clear_mem_coherent_flag(s, dest);
    } else
        fprintf(stderr, "[x86] unsupported operand type for xorl instruction.\n");
}

static void assemble_notl(TCGContext *s, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    TCGRegSet allocated_regs, desired_regs;
    TCGReg dest;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_REG) {
        /* notl register */
        dest = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
        tcg_out_notl_r_rule(s, dest);
        clear_mem_coherent_flag(s, dest);
    } else
        fprintf(stderr, "[x86] unsupported operand type for notl instruction.\n");
}

static void assemble_addb(TCGContext *s, X86Instruction *instr, uint32_t *reg_liveness)
{
    X86Operand *opd1 = &instr->opd[0];
    X86Operand *opd2 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd1->type == X86_OPD_TYPE_IMM && opd2->type == X86_OPD_TYPE_REG) {
        /* addb immediate to register */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd2->content.reg.num));
        int32_t imm = get_imm_map_wrapper(&opd1->content.imm);

        if (ts->val_type == TEMP_VAL_MEM ||
            (ts->val_type == TEMP_VAL_REG && ts->mem_coherent == 1)) {
            tcg_out_addb_im_rule(s, imm, ts->mem_base->reg, ts->mem_offset);
            if (ts->val_type == TEMP_VAL_REG) {
                ts->val_type = TEMP_VAL_MEM;
                ts->mem_coherent = 0;
                s->reg_to_temp[ts->reg] = NULL;
            }
        } else {
            TCGReg data;
            if (ts->val_type == TEMP_VAL_REG && ts->reg != TCG_REG_EAX && ts->reg != TCG_REG_EBX &&
                ts->reg != TCG_REG_ECX && ts->reg != TCG_REG_EDX) {
                if (s->reg_to_temp[TCG_REG_EAX] == NULL)
                    data = TCG_REG_EAX;
                else if (s->reg_to_temp[TCG_REG_EBX] == NULL)
                    data = TCG_REG_EBX;
                else if (s->reg_to_temp[TCG_REG_ECX] == NULL)
                    data = TCG_REG_ECX;
                else if (s->reg_to_temp[TCG_REG_EDX] == NULL)
                    data = TCG_REG_EDX;
                else
                    assert(0);
                tcg_out_movl_rr_rule(s, ts->reg, data);
                s->reg_to_temp[ts->reg] = NULL;
                s->reg_to_temp[data] = ts;
                ts->reg = data;
            } else {
                tcg_regset_clear(desired_regs);
                tcg_regset_set_reg(desired_regs, TCG_REG_EAX);
                tcg_regset_set_reg(desired_regs, TCG_REG_EBX);
                tcg_regset_set_reg(desired_regs, TCG_REG_ECX);
                tcg_regset_set_reg(desired_regs, TCG_REG_EDX);
                data = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, true);
            }
            tcg_out_addb_ir_rule(s, imm, data);
            clear_mem_coherent_flag(s, data);
        }
    } else {
        fprintf(stderr, "Unsupported operand type in addb instruction.\n");
    }
}

static void assemble_addl(TCGContext *s, TranslationBlock *tb, X86Instruction *instr,
                          uint32_t *reg_liveness, RuleRecord *rrule)
{
    X86Operand *opd1 = &instr->opd[0];
    X86Operand *opd2 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd1->type == X86_OPD_TYPE_REG && opd2->type == X86_OPD_TYPE_MEM) {
        /* addl register to memory */
        TCGReg data = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        TCGReg base = get_host_reg_map(s, opd2->content.mem.base, desired_regs, allocated_regs, true);
        int32_t off = get_imm_map_wrapper(&opd2->content.mem.offset);

        tcg_out_addm_rule(s, data, base, off);
    } else if (opd1->type == X86_OPD_TYPE_IMM && opd2->type == X86_OPD_TYPE_REG) {
        /* addl immediate to register */
        int32_t imm = get_imm_map_wrapper(&opd1->content.imm);

        if (tb->pc == 0x16670 || tb->pc == 0x16608) {
            TCGReg data = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, true);
            X86MemoryAddress mem_addr;
            mem_addr.base = data;
            mem_addr.index = -1;
            mem_addr.scale = 1;
            mem_addr.offset = imm;
            tcg_out_leal_rule(s, data, mem_addr.base, mem_addr.index,
                                 mem_addr.scale, mem_addr.offset);
            clear_mem_coherent_flag(s, data);
            return;
        }

        /* If this register is dead after this rule, we can suppress the ld/st operations */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd2->content.reg.num));
        if (ts->val_type == TEMP_VAL_MEM
            || (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd2->content.reg.num)])
                && ts->val_type == TEMP_VAL_REG && ts->mem_coherent == 1)) {
            #if 1
            if (ts->val_type == TEMP_VAL_REG && !rrule->update_cc) {
                X86MemoryAddress mem_addr;
                mem_addr.base = ts->reg;
                mem_addr.index = -1;
                mem_addr.scale = 1;
                mem_addr.offset = imm;
                tcg_out_leal_rule(s, ts->reg, mem_addr.base, mem_addr.index,
                                  mem_addr.scale, mem_addr.offset);
                ts->mem_coherent = 0;
            } else {
                tcg_out_addl_im_rule(s, imm, ts->mem_base->reg, ts->mem_offset);
                if (ts->val_type == TEMP_VAL_REG) {
                    ts->val_type = TEMP_VAL_MEM;
                    ts->mem_coherent = 0;
                    s->reg_to_temp[ts->reg] = NULL;
                }
            }
            #else
            tcg_out_addl_im_rule(s, imm, ts->mem_base->reg, ts->mem_offset);
            if (ts->val_type == TEMP_VAL_REG) {
                ts->val_type = TEMP_VAL_MEM;
                ts->mem_coherent = 0;
                s->reg_to_temp[ts->reg] = NULL;
            }
            #endif
        } else {
            TCGReg data = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, true);
            tcg_out_addl_ir_rule(s, imm, data);
            clear_mem_coherent_flag(s, data);
        }
    } else if (opd1->type == X86_OPD_TYPE_REG && opd2->type == X86_OPD_TYPE_REG) {
        /* addl register to register */
        TCGReg data = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        tcg_regset_set_reg(allocated_regs, data);

        if (tb->pc == 0x169bc) {
            TCGReg dest = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, true);
            X86MemoryAddress mem_addr;
            mem_addr.base = dest;
            mem_addr.index = data;
            mem_addr.scale = 1;
            mem_addr.offset = 0;
            tcg_out_leal_rule(s, dest, mem_addr.base, mem_addr.index,
                              mem_addr.scale, mem_addr.offset);
            clear_mem_coherent_flag(s, dest);
            return;
        }

        /* If this register is dead after this rule, we can suppress the ld/st operations */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd2->content.reg.num));
        if (ts->val_type == TEMP_VAL_MEM ||
            (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd2->content.reg.num)]) &&
             ts->val_type == TEMP_VAL_REG && ts->mem_coherent == 1)) {
            tcg_out_addm_rule(s, data, ts->mem_base->reg, ts->mem_offset);
            if (ts->val_type == TEMP_VAL_REG) {
                ts->val_type = TEMP_VAL_MEM;
                ts->mem_coherent = 0;
                s->reg_to_temp[ts->reg] = NULL;
            }
        } else {
            TCGReg dest = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, true);
            tcg_out_addl_rr_rule(s, data, dest);
            //update_mem_coherent_flag(s, dest, SYNC_FLAG(reg_liveness[get_guest_reg_map(opd2->content.reg.num)]));
            clear_mem_coherent_flag(s, dest);
        }
    } else
        fprintf(stderr, "Unsupported operand type in addl instruction.\n");

    if (rrule->update_cc) {
        s->cur_cc_source = 1;
    }
}

static void assemble_adcl(TCGContext *s, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    TCGReg dest, data;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];

    if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_REG)
    {
        /* adc immediate to register */
        int32_t imm = get_imm_map_wrapper(&opd0->content.imm);
        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        if (s->cur_cc_source == 1 || s->cur_cc_source == 3) // CF are in eflags now
            tcg_out_adcl_ir_rule(s, imm, dest);
        else
        {
            TCGTemp *ts = get_reg_tcg_temp(s, ARM_REG_CF);
            temp_load_rule(s, ts, desired_regs, allocated_regs, 1);
            tcg_out_leal_rule(s, dest, dest, ts->reg, 1, imm);
        }
        clear_mem_coherent_flag(s, dest);
    }
    else if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG)
    {
        /*adc register to register*/
        /*TODO:
            if dest register will dead, direct adc to memory `
         */
        data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        if (s->cur_cc_source == 1 || s->cur_cc_source == 3) // CF are in eflags now
            tcg_out_adcl_rr_rule(s, data, dest);
        else
        {
            TCGTemp *ts = get_reg_tcg_temp(s, ARM_REG_CF);
            temp_load_rule(s, ts, desired_regs, allocated_regs, 1);
            tcg_out_leal_rule(s, dest, dest, ts->reg, 1, 0);
            tcg_out_leal_rule(s, dest, data, 0, 0, 0);
        }
        clear_mem_coherent_flag(s, dest);
    }
    else
        fprintf(stderr, "Unsupported operand type in adcl instruction.\n");
}

static void assemble_subl(TCGContext *s, TranslationBlock *tb, X86Instruction *instr,
                          uint32_t *reg_liveness, RuleRecord *rrule)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    X86MemoryAddress mem_addr;
    TCGReg data, dest;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_REG) {
        /* subl immediate from register */
        int32_t imm = get_imm_map_wrapper(&opd0->content.imm); 

        /* If this register is dead after this rule, we can suppress the ld/st operations */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd1->content.reg.num));
        if (ts->val_type == TEMP_VAL_MEM
            || (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd1->content.reg.num)])
                && ts->val_type == TEMP_VAL_REG && ts->mem_coherent == 1)) {
            tcg_out_subl_im_rule(s, imm, ts->mem_base->reg, ts->mem_offset);
            if (ts->val_type == TEMP_VAL_REG) {
                ts->val_type = TEMP_VAL_MEM;
                ts->mem_coherent = 0;
                s->reg_to_temp[ts->reg] = NULL;
            }
        } else {
            dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
            tcg_out_subl_ir_rule(s, imm, dest);
            clear_mem_coherent_flag(s, dest); 
        }
    } else if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG) {
        /* subl register from register */

        /* If this register is dead after this rule, we can suppress the ld/st operations */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd1->content.reg.num));
        if (ts->val_type == TEMP_VAL_MEM ||
            (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd1->content.reg.num)])
             && ts->val_type == TEMP_VAL_REG && ts->mem_coherent == 1)) {
            data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
            tcg_regset_set_reg(allocated_regs, data);
            tcg_out_subl_rm_rule(s, data, ts->mem_base->reg, ts->mem_offset);
            if (ts->val_type == TEMP_VAL_REG) {
                ts->val_type = TEMP_VAL_MEM;
                ts->mem_coherent = 0;
                s->reg_to_temp[ts->reg] = NULL;
            }
        } else {
            dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
            tcg_regset_set_reg(allocated_regs, dest);

            /* Check if we can suppress the ld/st operations */
            ts = get_reg_tcg_temp(s, get_guest_reg_map(opd0->content.reg.num));
            if (ts->val_type == TEMP_VAL_MEM) {
                tcg_out_subl_mr_rule(s, dest, ts->mem_base->reg, -1, 1, ts->mem_offset);
            } else {
                data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
                tcg_regset_set_reg(allocated_regs, data);

                tcg_out_subl_rr_rule(s, data, dest);
            }
            clear_mem_coherent_flag(s, dest);
        }
    } else if (opd0->type == X86_OPD_TYPE_MEM && opd1->type == X86_OPD_TYPE_REG) {
        /* subl memory from register */

        get_memory_address(s, &opd0->content.mem, &mem_addr, &allocated_regs);

        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);

        tcg_out_subl_mr_rule(s, dest, mem_addr.base, mem_addr.index, mem_addr.scale, mem_addr.offset);
        clear_mem_coherent_flag(s, dest);
    } else
        fprintf(stderr, "Unsupported operand type in subl instruction.\n");

    if (rrule->update_cc) {
        s->cur_cc_source = 1;
        if (rrule->save_cc || (s->succ_define_cc != 3 && is_last_cc_definition(s, rrule->next_pc))) {
            tcg_out_set_cc_source(s, tb);
            /* Here cur_cc_source is delayed to be set to 2 in case there are instructions that use 
               host condition codes before they are modified */
        }
    } else if (s->cur_cc_source == 1 || s->cur_cc_source == 3)
        s->cur_cc_source += 1;
}

static void assemble_incl(TCGContext *s, TranslationBlock *tb, X86Instruction *instr, uint32_t *reg_liveness,
                          RuleRecord *rrule)
{
    X86Operand *opd = &instr->opd[0];
    TCGRegSet allocated_regs, desired_regs;
    X86MemoryAddress mem_addr;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd->type == X86_OPD_TYPE_MEM) { /* incl memory */
        get_memory_address(s, &opd->content.mem, &mem_addr, &allocated_regs);

        tcg_out_incl_rule(s, mem_addr.base, mem_addr.index, 
                            mem_addr.scale, mem_addr.offset, 0);
    } else if (opd->type == X86_OPD_TYPE_REG) { /* incl register */
        /* If this register is in the memory, we can suppress the ld/st operations */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd->content.reg.num));
        if (ts->val_type == TEMP_VAL_MEM
            || (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd->content.reg.num)])
                && ts->val_type == TEMP_VAL_REG && ts->mem_coherent == 1)) {
            tcg_out_incl_rule(s, ts->mem_base->reg, -1, 1, ts->mem_offset, 0);
            if (ts->val_type == TEMP_VAL_REG) {
                ts->val_type = TEMP_VAL_MEM;
                ts->mem_coherent = 0;
                s->reg_to_temp[ts->reg] = NULL;
            }
        } else {
            TCGReg data = get_host_reg_map(s, opd->content.reg.num, desired_regs, allocated_regs, true);
            if (rrule->update_cc)
                tcg_out_incl_rule(s, data, 0, 0, 0, 1);
            else {
                /* using leal instead of incl to avoid modifying EFLAGS */
                X86MemoryAddress mem_addr;
                mem_addr.base = data;
                mem_addr.index = -1;
                mem_addr.scale = 1;
                mem_addr.offset = 1;
                tcg_out_leal_rule(s, data, mem_addr.base, mem_addr.index,
                              mem_addr.scale, mem_addr.offset);
            }
            //update_mem_coherent_flag(s, data, SYNC_FLAG(reg_liveness[get_guest_reg_map(opd->content.reg.num)]));
            clear_mem_coherent_flag(s, data);
        }
    } else
        fprintf(stderr, "Unsupported operand type for incl instruction: %d.\n", opd->type);

    if (rrule->update_cc) {
        s->cur_cc_source = 1;
        if (rrule->save_cc || (s->succ_define_cc != 3 && is_last_cc_definition(s, rrule->next_pc))) {
            tcg_out_set_cc_source(s, tb);
            /* Here cur_cc_source is delayed to be set to 2 in case there are instructions that use 
               host condition codes before they are modified */
        }
    }

}

static void assemble_decl(TCGContext *s, TranslationBlock *tb, X86Instruction *instr, uint32_t *reg_liveness,
                          RuleRecord *rrule)
{
    X86Operand *opd = &instr->opd[0];
    TCGRegSet allocated_regs, desired_regs;
    X86MemoryAddress mem_addr;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd->type == X86_OPD_TYPE_MEM) {
        /* decl memory */
        get_memory_address(s, &opd->content.mem, &mem_addr, &allocated_regs);

        tcg_out_decl_rule(s, mem_addr.base, mem_addr.index,
                            mem_addr.scale, mem_addr.offset, 0);
    } else if (opd->type == X86_OPD_TYPE_REG) {
        /* decl register */

        if (tb->pc == 0x16688) {
            TCGReg data = get_host_reg_map(s, opd->content.reg.num, desired_regs, allocated_regs, true);
            X86MemoryAddress mem_addr;
            mem_addr.base = data;
            mem_addr.index = -1;
            mem_addr.scale = 1;
            mem_addr.offset = -1;
            tcg_out_leal_rule(s, data, mem_addr.base, mem_addr.index,
                                 mem_addr.scale, mem_addr.offset);
            clear_mem_coherent_flag(s, data);
            return;
        }

        /* If this register is in memory, we can suppress the ld/st operations */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd->content.reg.num));
        if (ts->val_type == TEMP_VAL_MEM
            || (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd->content.reg.num)])
                && ts->val_type == TEMP_VAL_REG && ts->mem_coherent == 1)) {
            tcg_out_decl_rule(s, ts->mem_base->reg, -1, 1, ts->mem_offset, 0);
            if (ts->val_type == TEMP_VAL_REG) {
                ts->val_type = TEMP_VAL_MEM;
                ts->mem_coherent = 0;
                s->reg_to_temp[ts->reg] = NULL;
            }
        } else {
            TCGReg data = get_host_reg_map(s, opd->content.reg.num, desired_regs, allocated_regs, true);
            tcg_out_decl_rule(s, data, 0, 0, 0, 1);
            //update_mem_coherent_flag(s, data, SYNC_FLAG(reg_liveness[get_guest_reg_map(opd->content.reg.num)]));
            clear_mem_coherent_flag(s, data);
        }
    } else
        fprintf(stderr, "Unsupported operand type for decl instruction.\n");

    if (rrule->update_cc) {
        s->cur_cc_source = 1;
        if (rrule->save_cc || (s->succ_define_cc != 3 && is_last_cc_definition(s, rrule->next_pc))) {
            tcg_out_set_cc_source(s, tb);
            /* Here cur_cc_source is delayed to be set to 2 in case there are instructions that use 
               host condition codes before they are modified */
        }
    }
}

static void assemble_imull(TCGContext *s,  TranslationBlock *tb, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    TCGReg data, dest;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG) {
        data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
        tcg_regset_set_reg(allocated_regs, data);
        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        tcg_out_imull_rr_rule(s, data, dest);
        clear_mem_coherent_flag(s, dest);
    } else
        fprintf(stderr, "[x86] Unsupported operand type in imull instruction.\n");
}

static void assemble_push(TCGContext *s, TranslationBlock *tb, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    TCGRegSet allocated_regs, desired_regs;
    int num_reg = 0;
    int cur_offset = 0;
    int imm = 0;
    int i = 0;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    assert(opd0->type == X86_OPD_TYPE_IMM);
    imm = get_imm_map_wrapper(&opd0->content.imm);

    /* Get sp */
    TCGTemp *ts;
    tcg_regset_set(allocated_regs, s->reserved_regs);
    ts = get_reg_tcg_temp(s, ARM_REG_R13);
    temp_load_rule(s, ts, desired_regs, allocated_regs, true);
    tcg_regset_set_reg(allocated_regs, ts->reg);

    for (i = 0; i < 16; i++) {
        if (imm & (1 << i))
            cur_offset -= 4;
    }

    /* push */
    for (i = 0; i < 16; i++) {
        if (imm & (1 << i)) {
            TCGTemp *tts;
            tts = get_reg_tcg_temp(s, get_arm_reg(i));
            temp_load_rule(s, tts, desired_regs, allocated_regs, true);
            tcg_out_qemu_st_rule(s, tts->reg, ts->reg, -1, 1, cur_offset, MO_UL, 0);
            cur_offset += 4;
            num_reg++;
			
			#ifdef PROFILE_RULE_TRANSLATION_HOST
				tb->num_host_branch_insn += 1;
			#endif 
        }
    }

    assert (cur_offset == 0);

    /* save sp */
    cur_offset = -(num_reg * 4);
    tcg_out_leal_rule(s, ts->reg, ts->reg, -1, 1, cur_offset);
	
	#ifdef PROFILE_RULE_TRANSLATION_HOST
		tb->num_host_branch_insn += 1;
	#endif 
	
    clear_mem_coherent_flag(s, ts->reg);
}

static void assemble_pop(TCGContext *s, TranslationBlock *tb, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    TCGRegSet allocated_regs, desired_regs;
    int cur_offset = 0;
    int imm = 0;
    int i = 0;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    assert(opd0->type == X86_OPD_TYPE_IMM);
    imm = get_imm_map_wrapper(&opd0->content.imm);

    /* Get sp */
    TCGTemp *ts;
    tcg_regset_set(allocated_regs, s->reserved_regs);
    ts = get_reg_tcg_temp(s, ARM_REG_R13);
    temp_load_rule(s, ts, desired_regs, allocated_regs, true);
    tcg_regset_set_reg(allocated_regs, ts->reg);

    /* pop */
    cur_offset = 0;
    for (i = 0; i < 16; i++) {
        if (imm & (1 << i)) {
            TCGTemp *tts;
            tts = get_reg_tcg_temp(s, get_arm_reg(i));
            temp_load_rule(s, tts, desired_regs, allocated_regs, false);
            tcg_out_qemu_ld_rule(s, tts->reg, ts->reg, -1, 1, cur_offset, MO_UL);
            clear_mem_coherent_flag(s, tts->reg);
            cur_offset += 4;
			
			#ifdef PROFILE_RULE_TRANSLATION_HOST
				tb->num_host_branch_insn += 1;
			#endif 
        }
    }

    /* save sp */
    tcg_out_leal_rule(s, ts->reg, ts->reg, -1, 1, cur_offset);
	
	#ifdef PROFILE_RULE_TRANSLATION_HOST
		tb->num_host_branch_insn += 1;
	#endif 
			
    clear_mem_coherent_flag(s, ts->reg);
}

static void assemble_shll(TCGContext *s, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    TCGReg data, dest;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_REG) {
        /* shll register using immediate */
        int32_t imm = get_imm_map_wrapper(&opd0->content.imm);
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd1->content.reg.num));
        if (ts->val_type == TEMP_VAL_MEM ||
            (ts->val_type == TEMP_VAL_REG && ts->mem_coherent == 1)) {
            tcg_out_shll_im_rule(s, imm, ts->mem_base->reg, -1, 1, ts->mem_offset);
            if (ts->val_type == TEMP_VAL_REG)
                s->reg_to_temp[ts->reg] = NULL;
            ts->val_type = TEMP_VAL_MEM;
            ts->mem_coherent = 0;
        } else {
            data = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
            tcg_out_shll_ir_rule(s, imm, data);
            clear_mem_coherent_flag(s, data);
        }
    } else if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG) {
        /* shll register using register (i.e., CL) */
        TCGTemp *ecx_ts = NULL;

        tcg_regset_clear(desired_regs);
        /* check if data is already in ECX register */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd0->content.reg.num));
        if (ts->val_type == TEMP_VAL_REG && ts->reg != TCG_REG_ECX) {
            ecx_ts = s->reg_to_temp[TCG_REG_ECX];
            if (ecx_ts != NULL) /* ecx is occupied by someone, we have to spill it */
                temp_save_rule(s, ecx_ts, allocated_regs);
            tcg_out_movl_rr_rule(s, ts->reg, TCG_REG_ECX);
            data = TCG_REG_ECX;            
        } else {
            tcg_regset_set_reg(desired_regs, TCG_REG_ECX);
            data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
        }
        tcg_regset_set_reg(allocated_regs, TCG_REG_ECX);
        desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);

        tcg_out_shll_rr_rule(s, data, dest);
        clear_mem_coherent_flag(s, dest);

        /* recover original value in ecx */
        if (ecx_ts != NULL) {
            tcg_regset_clear(allocated_regs);
            tcg_regset_clear(desired_regs);
            tcg_regset_set_reg(desired_regs, TCG_REG_ECX);
            temp_load_rule(s, ecx_ts, desired_regs, allocated_regs, true);
        }
    } else
        fprintf(stderr, "[x86] Unsupported operand type in shll instruction.\n");
}

static void assemble_shrl(TCGContext *s, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    TCGReg dest;
    int32_t imm;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (instr->opd_num == 1) {
        dest = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
        tcg_out_shrl_ir_rule(s, 1, dest);
        clear_mem_coherent_flag(s, dest);
        return;
    }

    if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_REG) {
        imm = get_imm_map_wrapper(&opd0->content.imm);
        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        tcg_out_shrl_ir_rule(s, imm, dest);
        clear_mem_coherent_flag(s, dest);
    } else
        fprintf(stderr, "[x86] Unsupported operand type for shrl instruction.\n");
}

static void assemble_shrdl(TCGContext *s, X86Instruction *instr, uint32_t *reg_liveness)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    X86Operand *opd2 = &instr->opd[2];
    TCGRegSet allocated_regs, desired_regs;
    TCGReg data, dest;
    int32_t imm;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_REG 
        && opd2->type == X86_OPD_TYPE_REG) {
        /* shrdl imm, data, dest */
        imm = get_imm_map_wrapper(&opd0->content.imm);
        data = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        tcg_regset_set_reg(allocated_regs, data);

        /* Check if we can suppress the ld/st operation */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd2->content.reg.num));
        if (SYNC_FLAG(reg_liveness[get_guest_reg_map(opd2->content.reg.num)]) &&
            (ts->val_type == TEMP_VAL_MEM || (ts->val_type == TEMP_VAL_REG && ts->mem_coherent == 1))) {
            tcg_out_shrdl_irm_rule(s, imm, data, ts->mem_base->reg, -1, 1, ts->mem_offset);
            if (ts->val_type == TEMP_VAL_REG)
                s->reg_to_temp[ts->reg] = NULL;
            ts->val_type = TEMP_VAL_MEM;
            ts->mem_coherent = 0;
        } else {
            dest = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, true);
            tcg_regset_set_reg(allocated_regs, dest);
            tcg_out_shrdl_irr_rule(s, imm, data, dest);
            clear_mem_coherent_flag(s, dest);
        }
    } else
        fprintf(stderr, "[x86] Unsupported operand type for shrdl instruction.\n");
}

static void assemble_sarl(TCGContext *s, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    TCGReg data;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];

    if (instr->opd_num == 1) {
        data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);

        tcg_out_sarl_ir_rule(s, 1, data);
        clear_mem_coherent_flag(s, data);
        return;
    }

    if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_REG) {
        /* sarl register using immediate */
        data = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        int32_t imm = get_imm_map_wrapper(&opd0->content.imm);

        tcg_out_sarl_ir_rule(s, imm, data);
        clear_mem_coherent_flag(s, data);
    } else
        fprintf(stderr, "[x86] Unsupported operand type in sarl instruction.\n");
}

static void assemble_btl(TCGContext *s, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG) {
        /* btl register with register */
        TCGReg base, offset;
        base = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        tcg_regset_set_reg(allocated_regs, base);
        offset = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);

        tcg_out_btl_rr_rule(s, base, offset);
    } else
        fprintf(stderr, "Unsupported operand type for btl instruction.\n");
}

static void assemble_cmpl(TCGContext *s, TranslationBlock *tb, 
                          X86Instruction *instr, uint32_t *reg_liveness,
                          RuleRecord *rrule)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    X86MemoryAddress mem_addr;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_MEM) {
        /* cmpl immediate with memory */
        get_memory_address(s, &opd1->content.mem, &mem_addr, &allocated_regs);

        int32_t imm = get_imm_map_wrapper(&opd0->content.imm);

        tcg_out_cmp_im_rule(s, imm, mem_addr.base, mem_addr.index,
                            mem_addr.scale, mem_addr.offset);
    } else if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG) {
        /* cmpl register with register */
        TCGReg reg0, reg1;

        #if 1
        /* If one register is dead after this rule, we can suppress a mov */
        TCGTemp *ts0 = get_reg_tcg_temp(s, get_guest_reg_map(opd0->content.reg.num));
        TCGTemp *ts1 = get_reg_tcg_temp(s, get_guest_reg_map(opd1->content.reg.num));
        if (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd1->content.reg.num)])
            && ts1->val_type == TEMP_VAL_MEM) {
            /* change to cmpl register with memory */
            reg0 = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
            tcg_out_cmp_rm_rule(s, reg0, ts1->mem_base->reg, -1, 1, ts1->mem_offset);
        } else if (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd0->content.reg.num)])
                   && ts0->val_type == TEMP_VAL_MEM) {
            /* change to cmpl memory with register */
            reg1 = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
            tcg_out_cmp_mr_rule(s, reg1, ts0->mem_base->reg, -1, 1, ts0->mem_offset);
        } else
        #endif
        {
            reg0 = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
            tcg_regset_set_reg(allocated_regs, reg0);

            reg1 = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);

            tcg_out_cmp_rr_rule(s, reg0, reg1);
        }
    } else if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_REG) {
        /* cmpl immediate with register */
        int32_t imm = get_imm_map_wrapper(&opd0->content.imm);

        /* If the register is dead after this rule, we can suppress a mov */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd1->content.reg.num));
        if (ts->val_type == TEMP_VAL_MEM) {
//DEAD_FLAG(reg_liveness[get_guest_reg_map(opd1->content.reg.num)])
//            && ts->val_type == TEMP_VAL_MEM) {
            tcg_out_cmp_im_rule(s, imm, ts->mem_base->reg, -1, 1, ts->mem_offset);
        } else {
            TCGReg reg0 = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
            tcg_out_cmp_ir_rule(s, imm, reg0);
        }
    } else if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_MEM) {
        /* cmpl register with memory */
        TCGReg reg0;

        get_memory_address(s, &opd1->content.mem, &mem_addr, &allocated_regs);
        reg0 = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);        

        tcg_out_cmp_rm_rule(s, reg0, mem_addr.base, mem_addr.index, mem_addr.scale, mem_addr.offset);
    } else
        fprintf(stderr, "Unsupported operand type for cmpl instruction.\n");

    s->cur_cc_source = 1;
    if (rrule->save_cc || (s->succ_define_cc != 3 && is_last_cc_definition(s, rrule->next_pc))) {
        tcg_out_set_cc_source(s, tb);
        /* Here cur_cc_source is delayed to be set to 2 in case there are instructions that use 
           host condition codes before they are modified */
    }
}

static void assemble_testb(TCGContext *s, TranslationBlock *tb, X86Instruction *instr,
                           RuleRecord *rrule)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    TCGReg data;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_REG) {
        /* testb immediate with register */
        int32_t imm = get_imm_map_wrapper(&opd0->content.imm);
        /* check if the data is already in a register that is not eax, ebx, ecx, and edx */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd1->content.reg.num));
        if (ts->val_type == TEMP_VAL_REG &&
            ts->reg != TCG_REG_EAX && ts->reg != TCG_REG_EBX &&
            ts->reg != TCG_REG_ECX && ts->reg != TCG_REG_EDX) {
            if (s->reg_to_temp[TCG_REG_EAX] == NULL)
                data = TCG_REG_EAX;
            else
                assert(0);
            tcg_out_movl_rr_rule(s, ts->reg, data);
            s->reg_to_temp[ts->reg] = NULL;
            s->reg_to_temp[data] = ts;
            ts->reg = data;
        } else {
            tcg_regset_clear(desired_regs);
            tcg_regset_set_reg(desired_regs, TCG_REG_EAX);
            tcg_regset_set_reg(desired_regs, TCG_REG_EBX);
            tcg_regset_set_reg(desired_regs, TCG_REG_ECX);
            tcg_regset_set_reg(desired_regs, TCG_REG_EDX);
            data = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
        }
        tcg_out_testb_ir_rule(s, imm, data);
    } else if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG) {
        assert(opd0->content.reg.num == opd1->content.reg.num);
        /* check if the data is already in a register that is not eax, ebx, ecx, and edx */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd0->content.reg.num));
        if (ts->val_type == TEMP_VAL_REG &&
            ts->reg != TCG_REG_EAX && ts->reg != TCG_REG_EBX &&
            ts->reg != TCG_REG_ECX && ts->reg != TCG_REG_EDX) {
            if (s->reg_to_temp[TCG_REG_EAX] == NULL)
                data = TCG_REG_EAX;
            else
                assert(0);
            tcg_out_movl_rr_rule(s, ts->reg, data);
            s->reg_to_temp[ts->reg] = NULL;
            s->reg_to_temp[data] = ts;
            ts->reg = data;
        } else {
            tcg_regset_clear(desired_regs);
            tcg_regset_set_reg(desired_regs, TCG_REG_EAX);
            tcg_regset_set_reg(desired_regs, TCG_REG_EBX);
            tcg_regset_set_reg(desired_regs, TCG_REG_ECX);
            tcg_regset_set_reg(desired_regs, TCG_REG_EDX);
            data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
        }
        tcg_out_testb_rr_rule(s, data, data);
    } else if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_MEM) {
        /* testb immediate with register */
        int32_t imm = get_imm_map_wrapper(&opd0->content.imm);
        X86MemoryAddress mem_addr;
        get_memory_address(s, &opd1->content.mem, &mem_addr, &allocated_regs);

        tcg_out_testb_im_rule(s, imm, mem_addr.base, mem_addr.index, mem_addr.scale, mem_addr.offset);
    } else
        fprintf(stderr, "[x86] Unsupported operand type for testb instruction, rule index: %d.\n", rrule->rule->index);

    if (rrule->update_cc) {
        s->cur_cc_source = 1;
        if (rrule->save_cc || (s->succ_define_cc != 3 && is_last_cc_definition(s, rrule->next_pc))) {
            tcg_out_set_cc_source(s, tb);
            /* Here cur_cc_source is delayed to be set to 2 in case there are instructions that use 
               host condition codes before they are modified */
        }
    }
}

static void assemble_testw(TCGContext *s, TranslationBlock *tb, X86Instruction *instr,
                           RuleRecord *rrule)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    TCGReg data, dest;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG) {
        data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
        tcg_regset_set_reg(allocated_regs, data);
        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);

        tcg_out_testw_rr_rule(s, data, dest);
    } else
       fprintf(stderr, "[x86] Unsupported operand type for testw instruction.\n"); 

    if (rrule->update_cc) {
        s->cur_cc_source = 1;
        if (rrule->save_cc || (s->succ_define_cc != 3 && is_last_cc_definition(s, rrule->next_pc))) {
            tcg_out_set_cc_source(s, tb);
            /* Here cur_cc_source is delayed to be set to 2 in case there are instructions that use 
               host condition codes before they are modified */
        }
    }
}

static void assemble_testl(TCGContext *s, TranslationBlock *tb,
                           X86Instruction *instr, uint32_t *reg_liveness,
                           RuleRecord *rrule)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
    if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_MEM) {
        /* testl immediate with memory */
        TCGReg base = get_host_reg_map(s, opd1->content.mem.base, desired_regs, allocated_regs, true);
        int32_t off = get_imm_map_wrapper(&opd1->content.mem.offset);
        int32_t imm = get_imm_map_wrapper(&opd0->content.imm);

        tcg_out_testl_im_rule(s, imm, base, off);
    } else if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG) {
        /* testl register with register */
        TCGReg reg0, reg1;

        reg0 = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
        tcg_regset_set_reg(allocated_regs, reg0);
        reg1 = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);

        tcg_out_testl_rr_rule(s, reg0, reg1); 
    } else if (opd0->type == X86_OPD_TYPE_IMM && opd1->type == X86_OPD_TYPE_REG) {
        /* testl immediate with register */
        int32_t imm = get_imm_map_wrapper(&opd0->content.imm);
        TCGReg reg;

        /* try to suppress a move */
        TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd1->content.reg.num));
        if (DEAD_FLAG(reg_liveness[get_guest_reg_map(opd1->content.reg.num)]) &&
            ts->val_type == TEMP_VAL_MEM) {
            tcg_out_testl_im_rule2(s, imm, ts->mem_base->reg, ts->mem_offset);
        } else {
            reg = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
            tcg_out_testl_ir_rule(s, imm, reg);
        }
    } else
        fprintf(stderr, "[x86] Unsupported operand type for testl instruction.\n");

    s->cur_cc_source = 1;
    if (s->succ_define_cc != 3 && is_last_cc_definition(s, rrule->next_pc))
        tcg_out_set_cc_source(s, tb);
}

static void assemble_cmovnel(TCGContext *s, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    TCGReg data, dest;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];

    if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG) {
        /* cmovnel from register to register */
        data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
        tcg_regset_set_reg(allocated_regs, data);
        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);

        tcg_out_cmovnel_rr_rule(s, data, dest);
        clear_mem_coherent_flag(s, dest);
    } else
        fprintf(stderr, "[x86] Unsupported operand type for cmovnel instruction.\n");
}

static void assemble_cmoval(TCGContext *s, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
    X86Operand *opd1 = &instr->opd[1];
    TCGRegSet allocated_regs, desired_regs;
    TCGReg data, dest;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];

    if (opd0->type == X86_OPD_TYPE_REG && opd1->type == X86_OPD_TYPE_REG) {
        /* cmoval from immediate to register */
        data = get_host_reg_map(s, opd0->content.reg.num, desired_regs, allocated_regs, true);
        tcg_regset_set_reg(allocated_regs, data);
        dest = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);

        tcg_out_cmoval_rr_rule(s, data, dest);
        clear_mem_coherent_flag(s, dest);
    } else
        fprintf(stderr, "[x86] Unsupported operand type for cmoval instruction.\n");
}

static void assemble_jcc(TCGContext *s, TranslationBlock *tb, int opc, X86Instruction *instr)
{
    X86Operand *opd = &instr->opd[0];

    //if (!s->succ_define_cc)
    //    tcg_out_set_cc_source(s);

    if (!instr->next) { /* exit tb */
        //int32_t index = get_imm_map_wrapper(&opd->content.imm);
        target_ulong target, fallthrough;
        tcg_sync_globals(s);
        assert(opd->content.imm.type == X86_IMM_TYPE_SYM);
        get_label_map(opd->content.imm.content.sym, &target, &fallthrough);
        tcg_out_jcc_rule(s, tb, opc, target, fallthrough);
    } else { /* regular jcc, for conditional execution */
        TCGLabel *target = get_host_label_map(s, &opd->content.imm);

        tcg_out_jcc_no_exit_rule(s, opc, target, 1);
    }
}

static void assemble_set_label(TCGContext *s, X86Instruction *instr)
{
    X86Operand *opd = &instr->opd[0];
    TCGLabel *label = get_host_label_map(s, &opd->content.imm);

    tcg_out_label_rule(s, label, s->code_ptr);
}

static void assemble_sync_m(TCGContext *s, X86Instruction *instr)
{    
    X86Operand *opd = &instr->opd[0];
    TCGRegSet allocated_regs, desired_regs;
    TCGReg data;
    TCGTemp *ts;
    
    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];

    if (opd->type == X86_OPD_TYPE_REG){
        data = get_host_reg_map(s, opd->content.reg.num, desired_regs, allocated_regs, true);
        tcg_regset_set_reg(allocated_regs, data);
        ts = get_reg_tcg_temp(s, get_guest_reg_map(opd->content.reg.num));
        if (ts->val_type == TEMP_VAL_REG){
            temp_sync_rule(s, ts, allocated_regs);
            ts->mem_coherent = 0;
        }
    }
    else
        fprintf(stderr, "[x86] Unsupported operand type for sync_m instruction.\n");
}

static void assemble_sync_r(TCGContext *s, X86Instruction *instr)
{
    X86Operand *opd = &instr->opd[0];
    TCGRegSet allocated_regs, desired_regs;
    TCGTemp *ts;
    TCGReg data;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];

    if (opd->type == X86_OPD_TYPE_REG){
        // data = get_host_reg_map(s, opd->content.reg.num, desired_regs, allocated_regs, true);
        ts = get_reg_tcg_temp(s, get_guest_reg_map(opd->content.reg.num));
        temp_dead_rule(s, ts);
        // tcg_regset_set_reg(allocated_regs, data);
        // ts->val_type = TEMP_VAL_MEM;
        // temp_load_rule(s, ts, desired_regs, allocated_regs, true);
    }
    else
        fprintf(stderr, "[x86] Unsupported operand type for sync_r instruction.\n");
}


static void assemble_pc_ir(TCGContext *s, TranslationBlock *tb, X86Instruction *instr)
{
    X86Operand *opd = &instr->opd[0];
	int32_t imm = get_imm_map_wrapper(&opd->content.imm);
	tcg_sync_globals(s);
	tcg_out_pc_ir_rule(s, imm);
	
	#ifdef PROFILE_RULE_TRANSLATION_HOST
		tb->num_host_branch_insn += 7;
	#endif 
}

static void assemble_pc_rr(TCGContext *s, TranslationBlock *tb, X86Instruction *instr)
{
    X86Operand *opd = &instr->opd[0];
	TCGReg data;
	TCGRegSet allocated_regs, desired_regs;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
	
	data = get_host_reg_map(s, opd->content.reg.num, desired_regs, allocated_regs, true);
	
	//sync reg to mem
	int i;
    for (i = 0; i < s->nb_globals; i++) {
        TCGTemp *ts = &s->temps[i];
        if (ts->fixed_reg || ts->reg == data)
            continue;

        if (ts->val_type == TEMP_VAL_REG && !ts->mem_coherent)
            tcg_out_st_rule(s, ts->type, ts->reg, ts->mem_base->reg, ts->mem_offset);
        ts->mem_coherent = 1;
    }
	
	tcg_out_pc_rr_rule(s, data);
	
	#ifdef PROFILE_RULE_TRANSLATION_HOST
		tb->num_host_branch_insn += 7;
	#endif 
}

static void assemble_mull(TCGContext *s, TranslationBlock *tb, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
	X86Operand *opd1 = &instr->opd[1];
	X86Operand *opd2 = &instr->opd[2];
	X86Operand *opd3 = &instr->opd[3];
	
    TCGRegSet allocated_regs, desired_regs;
    TCGReg data;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
	
		
	TCGTemp *tsh = get_reg_tcg_temp(s, get_guest_reg_map(opd3->content.reg.num));
	TCGTemp *tsl = get_reg_tcg_temp(s, get_guest_reg_map(opd0->content.reg.num));
		
	TCGTemp *eax_ts = NULL;
	TCGTemp *edx_ts = NULL;
		
	edx_ts = s->reg_to_temp[TCG_REG_EDX];
	if (edx_ts != NULL) /* edx is occupied by someone, we have to spill it */
	{
		#ifdef PROFILE_RULE_TRANSLATION_HOST
			tb->num_host_branch_insn += 1;
		#endif 
		temp_save_rule(s, edx_ts, allocated_regs);
		remove_host_reg_map(TCG_REG_EDX);
	}
		
	eax_ts = s->reg_to_temp[TCG_REG_EAX];
	if (eax_ts != NULL) /* eax is occupied by someone, we have to spill it */
	{
		#ifdef PROFILE_RULE_TRANSLATION_HOST
			tb->num_host_branch_insn += 1;
		#endif 
		temp_save_rule(s, eax_ts, allocated_regs);	
		remove_host_reg_map(TCG_REG_EAX);
	}

			
	tcg_regset_set_reg(allocated_regs, TCG_REG_EDX);
	tcg_regset_set_reg(allocated_regs, TCG_REG_EAX);	
	TCGReg data2 = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
	tcg_out_movl_rr_rule(s, data2, TCG_REG_EAX);
	tcg_regset_set_reg(allocated_regs, data2);	
	#ifdef PROFILE_RULE_TRANSLATION_HOST
		tb->num_host_branch_insn += 1;
	#endif 
	

		
	data = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, true);
	tcg_regset_set_reg(allocated_regs, data);
	tcg_out_mull_rr_rule(s, data);
	
	#ifdef PROFILE_RULE_TRANSLATION_HOST
		tb->num_host_branch_insn += 3;
	#endif 
					
	if(tsh->val_type == TEMP_VAL_REG){
		tcg_out_movl_rr_rule(s, TCG_REG_EAX, tsh->reg);
		tsh->mem_coherent = 0;
	}
	else{
		tcg_out_st_rule(s, TEMP_VAL_REG, TCG_REG_EAX, tsh->mem_base->reg, tsh->mem_offset);
		remove_host_reg_map(tsh->reg);
		tsh->mem_coherent = 0;
		//s->reg_to_temp[tsh->reg] = NULL;
	}
	if(tsl->val_type == TEMP_VAL_REG){
		tcg_out_movl_rr_rule(s, TCG_REG_EDX, tsl->reg);
		tsl->mem_coherent = 0;
	}
	else{
		tcg_out_st_rule(s, TEMP_VAL_REG, TCG_REG_EDX, tsl->mem_base->reg, tsl->mem_offset);
		remove_host_reg_map(tsl->reg);
		tsl->mem_coherent = 0;
		//s->reg_to_temp[tsl->reg] = NULL;
	}
		
}



static void assemble_smull(TCGContext *s, TranslationBlock *tb, X86Instruction *instr)
{
     X86Operand *opd0 = &instr->opd[0];
	X86Operand *opd1 = &instr->opd[1];
	X86Operand *opd2 = &instr->opd[2];
	X86Operand *opd3 = &instr->opd[3];
	
    TCGRegSet allocated_regs, desired_regs;
    TCGReg data;

    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
	
		
	TCGTemp *tsh = get_reg_tcg_temp(s, get_guest_reg_map(opd3->content.reg.num));
	TCGTemp *tsl = get_reg_tcg_temp(s, get_guest_reg_map(opd0->content.reg.num));
		
	TCGTemp *eax_ts = NULL;
	TCGTemp *edx_ts = NULL;
	
	edx_ts = s->reg_to_temp[TCG_REG_EDX];
	if (edx_ts != NULL) /* edx is occupied by someone, we have to spill it */
	{
		#ifdef PROFILE_RULE_TRANSLATION_HOST
			tb->num_host_branch_insn += 1;
		#endif 
		temp_save_rule(s, edx_ts, allocated_regs);
		remove_host_reg_map(TCG_REG_EDX);
	}
		
	eax_ts = s->reg_to_temp[TCG_REG_EAX];
	if (eax_ts != NULL) /* eax is occupied by someone, we have to spill it */
	{
		#ifdef PROFILE_RULE_TRANSLATION_HOST
			tb->num_host_branch_insn += 1;
		#endif 
		temp_save_rule(s, eax_ts, allocated_regs);	
		remove_host_reg_map(TCG_REG_EAX);
	}
			
	tcg_regset_set_reg(allocated_regs, TCG_REG_EDX);
	tcg_regset_set_reg(allocated_regs, TCG_REG_EAX);	
	TCGReg data2 = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, true);
	tcg_out_movl_rr_rule(s, data2, TCG_REG_EAX);
	tcg_regset_set_reg(allocated_regs, data2);	

		
	data = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
	tcg_regset_set_reg(allocated_regs, data);
	tcg_out_smull_rr_rule(s, data);
	
	#ifdef PROFILE_RULE_TRANSLATION_HOST
		tb->num_host_branch_insn += 4;
	#endif 
					
	if(tsh->val_type == TEMP_VAL_REG){
		tcg_out_movl_rr_rule(s, TCG_REG_EAX, tsh->reg);
		tsh->mem_coherent = 0;
	}
	else{
		tcg_out_st_rule(s, TEMP_VAL_REG, TCG_REG_EAX, tsh->mem_base->reg, tsh->mem_offset);
		remove_host_reg_map(tsh->reg);
		tsh->mem_coherent = 0;
		//s->reg_to_temp[tsh->reg] = NULL;
	}
	if(tsl->val_type == TEMP_VAL_REG){
		tcg_out_movl_rr_rule(s, TCG_REG_EDX, tsl->reg);
		tsl->mem_coherent = 0;
	}
	else{
		tcg_out_st_rule(s, TEMP_VAL_REG, TCG_REG_EDX, tsl->mem_base->reg, tsl->mem_offset);
		remove_host_reg_map(tsl->reg);
		tsl->mem_coherent = 0;
		//s->reg_to_temp[tsl->reg] = NULL;
	}
		
}

static void assemble_umlal(TCGContext *s, TranslationBlock *tb, X86Instruction *instr)
{
    X86Operand *opd0 = &instr->opd[0];
	X86Operand *opd1 = &instr->opd[1];
	X86Operand *opd2 = &instr->opd[2];
	X86Operand *opd3 = &instr->opd[3];
	
    TCGRegSet allocated_regs, desired_regs;
    TCGReg data, data2, data3;

	
    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
	
		
	TCGTemp *tsh = get_reg_tcg_temp(s, get_guest_reg_map(opd3->content.reg.num));
	TCGTemp *tsl = get_reg_tcg_temp(s, get_guest_reg_map(opd0->content.reg.num));
		
	TCGTemp *eax_ts = NULL;
	TCGTemp *edx_ts = NULL;
		
	edx_ts = s->reg_to_temp[TCG_REG_EDX];
	if (edx_ts != NULL) /* edx is occupied by someone, we have to spill it */
	{
		#ifdef PROFILE_RULE_TRANSLATION_HOST
			tb->num_host_branch_insn += 1;
		#endif 
		temp_save_rule(s, edx_ts, allocated_regs);
		remove_host_reg_map(TCG_REG_EDX);
	}
		
	eax_ts = s->reg_to_temp[TCG_REG_EAX];
	if (eax_ts != NULL) /* eax is occupied by someone, we have to spill it */
	{
		#ifdef PROFILE_RULE_TRANSLATION_HOST
			tb->num_host_branch_insn += 1;
		#endif 
		temp_save_rule(s, eax_ts, allocated_regs);	
		remove_host_reg_map(TCG_REG_EAX);
	}

			
	tcg_regset_set_reg(allocated_regs, TCG_REG_EDX);
	tcg_regset_set_reg(allocated_regs, TCG_REG_EAX);	
	data2 = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
	tcg_out_movl_rr_rule(s, data2, TCG_REG_EAX);
	tcg_regset_set_reg(allocated_regs, data2);	
	
	data = get_host_reg_map(s, opd2->content.reg.num, desired_regs, allocated_regs, true);
	tcg_regset_set_reg(allocated_regs, data);
	tcg_out_mull_rr_rule(s, data);
	
	data3 = get_host_reg_map(s, opd3->content.reg.num, desired_regs, allocated_regs, true);
	tcg_out_addl_rr_rule(s, data3, TCG_REG_EAX);
	
	
	tcg_out_adcl_ir_rule(s, 0, TCG_REG_EDX);
	
	
	#ifdef PROFILE_RULE_TRANSLATION_HOST
		tb->num_host_branch_insn += 6;
	#endif 
		
	if(tsh->val_type == TEMP_VAL_REG){
		tcg_out_movl_rr_rule(s, TCG_REG_EAX, tsh->reg);
		tsh->mem_coherent = 0;
	}
	else{
		tcg_out_st_rule(s, TEMP_VAL_REG, TCG_REG_EAX, tsh->mem_base->reg, tsh->mem_offset);
		remove_host_reg_map(tsh->reg);
		tsh->mem_coherent = 0;
		//s->reg_to_temp[tsh->reg] = NULL;
	}
	if(tsl->val_type == TEMP_VAL_REG){
		tcg_out_movl_rr_rule(s, TCG_REG_EDX, tsl->reg);
		tsl->mem_coherent = 0;
	}
	else{
		tcg_out_st_rule(s, TEMP_VAL_REG, TCG_REG_EDX, tsl->mem_base->reg, tsl->mem_offset);
		remove_host_reg_map(tsl->reg);
		tsl->mem_coherent = 0;
		//s->reg_to_temp[tsl->reg] = NULL;
	}
	
	/*
	remove_host_reg_map(tsh->reg);
	remove_host_reg_map(tsl->reg);
	s->reg_to_temp[tsh->reg] = NULL;
	s->reg_to_temp[tsl->reg] = NULL;
	
	tsh->reg = TCG_REG_EAX;
	tsh->val_type = TEMP_VAL_REG;
	tsh->mem_coherent = 0;
	s->reg_to_temp[TCG_REG_EAX] = tsh;
	remove_host_reg_map(TCG_REG_EAX);
    add_host_reg_map(opd3->content.reg.num, TCG_REG_EAX);
	
	tsl->reg = TCG_REG_EDX;
	tsl->val_type = TEMP_VAL_REG;
	tsl->mem_coherent = 0;
	s->reg_to_temp[TCG_REG_EDX] = tsl;
	remove_host_reg_map(TCG_REG_EDX);
    add_host_reg_map(opd0->content.reg.num, TCG_REG_EDX);
	*/
}

static void assemble_jmpl(TCGContext *s, TranslationBlock *tb, X86Instruction *instr)
{
    X86Operand *opd = &instr->opd[0];
	
	target_ulong target, pc_value;
    tcg_sync_globals(s);
    assert(opd->content.imm.type == X86_IMM_TYPE_SYM);
	
	target = (target_ulong)get_imm_map_wrapper(&opd->content.imm);
	pc_value = (target_ulong) get_imm_map("imm_pc");
	tcg_out_bl(s, tb, target, pc_value);
		
}

/* 
static void assemble_clz(TCGContext *s, TranslationBlock *tb, X86Instruction *instr)
{
	void * func_addr = helper_clz;
    X86Operand *opd0 = &instr->opd[0];
	X86Operand *opd1 = &instr->opd[1];
	
	TCGRegSet allocated_regs, desired_regs;
    TCGReg data;


	#ifdef PROFILE_RULE_TRANSLATION_HOST
		tb->num_host_branch_insn += 2;
	#endif 
	
    tcg_regset_clear(allocated_regs);
    desired_regs = tcg_target_available_regs[TCG_TYPE_I32];
	
	TCGTemp *eax_ts = NULL;
	eax_ts = s->reg_to_temp[TCG_REG_EAX];
	if (eax_ts != NULL) 
	{
		temp_save_rule(s, eax_ts, allocated_regs);	
		remove_host_reg_map(TCG_REG_EAX);
	}
	
	data = get_host_reg_map(s, opd1->content.reg.num, desired_regs, allocated_regs, true);
	
	tcg_out_st_rule(s, TEMP_VAL_REG, data, TCG_REG_ESP, 0);
	
	tcg_out_call_rule(s, (tcg_insn_unit *)func_addr);
	
	TCGTemp *ts = get_reg_tcg_temp(s, get_guest_reg_map(opd0->content.reg.num));
	
	if(ts->val_type == TEMP_VAL_REG){
		tcg_out_movl_rr_rule(s, TCG_REG_EAX, ts->reg);
		ts->mem_coherent = 0;
	}
	else{
		tcg_out_st_rule(s, TEMP_VAL_REG, TCG_REG_EAX, ts->mem_base->reg, ts->mem_offset);
		remove_host_reg_map(ts->reg);
		ts->mem_coherent = 0;
		//s->reg_to_temp[ts->reg] = NULL;
	}
	
}
*/ 

void reset_asm_buffer(void)
{
    h_reg_map_buf_index = 0;
    h_label_map_buf_index = 0; 
}

void assemble_x86_instruction(TCGContext *s, TranslationBlock *tb, X86Instruction *instr,
                              uint32_t *reg_liveness, RuleRecord *rrule)
{
    switch (instr->opc) {
        case X86_OPC_MOVB:
            assemble_movb(s, instr);
            break;
        case X86_OPC_MOVZBL:
            assemble_movzbl(s, instr, reg_liveness);
            break;
        case X86_OPC_MOVW:
            assemble_movw(s, instr);
            break;
        case X86_OPC_MOVZWL:
            assemble_movzwl(s, instr, reg_liveness);
            break;
        case X86_OPC_MOVL:
            assemble_movl(s, tb, instr, reg_liveness);
            break;
        case X86_OPC_LEAL:
            assemble_leal(s, tb, instr, reg_liveness);
            break;
        case X86_OPC_NEGL:
            assemble_negl(s, tb, instr, rrule);
            break;
        case X86_OPC_ANDB:
            assemble_andb(s, tb, instr, rrule);
            break;
        case X86_OPC_ANDL:
            assemble_andl(s, tb, instr, rrule);
            break;
        case X86_OPC_ORL:
            assemble_orl(s, tb, instr, rrule);
            break;
        case X86_OPC_XORL:
            assemble_xorl(s, instr);
            break;
        case X86_OPC_NOTL:
            assemble_notl(s, instr);
            break;
        case X86_OPC_ADDB:
            assemble_addb(s, instr, reg_liveness);
            break;
        case X86_OPC_ADDL:
            assemble_addl(s, tb, instr, reg_liveness, rrule);
            break;
        case X86_OPC_ADCL:
            assemble_adcl(s, instr);
            break;
        case X86_OPC_SUBL:
            assemble_subl(s, tb, instr, reg_liveness, rrule);
            break;
        case X86_OPC_INCL:
            assemble_incl(s, tb, instr, reg_liveness, rrule);
            break;
        case X86_OPC_DECL:
            assemble_decl(s, tb, instr, reg_liveness, rrule);
            break;
        case X86_OPC_IMULL:
            assemble_imull(s, tb, instr);
            break;
		case X86_OPC_SMULL:
            assemble_smull(s, tb, instr); 
            break;
		case X86_OPC_UMLAL:
            assemble_umlal(s, tb, instr); 
            break;
        case X86_OPC_SHLL:
            assemble_shll(s, instr);
            break;
        case X86_OPC_SHRL:
            assemble_shrl(s, instr);
            break;
        case X86_OPC_SHRDL:
            assemble_shrdl(s, instr, reg_liveness);
            break;
        case X86_OPC_SARL:
            assemble_sarl(s, instr);
            break;
        case X86_OPC_BTL:
            assemble_btl(s, instr);
            break;
        case X86_OPC_TESTB:
            assemble_testb(s, tb, instr, rrule);
            break;
        case X86_OPC_TESTW:
            assemble_testw(s, tb, instr, rrule);
            break;
        case X86_OPC_TESTL:
            assemble_testl(s, tb, instr, reg_liveness, rrule);
            break;
        case X86_OPC_CMPL:
            assemble_cmpl(s, tb, instr, reg_liveness, rrule);
            break;
        case X86_OPC_CMOVNEL:
            assemble_cmovnel(s, instr);
            break;
        case X86_OPC_CMOVAL:
            assemble_cmoval(s, instr);
            break;
        case X86_OPC_JA:
            assemble_jcc(s, tb, JCC_JA, instr);
            break;
        case X86_OPC_JAE:
            assemble_jcc(s, tb, JCC_JAE, instr);
            break;
        case X86_OPC_JB:
            assemble_jcc(s, tb, JCC_JB, instr);
            break;
        case X86_OPC_JBE:
            assemble_jcc(s, tb, JCC_JBE, instr);
            break;
        case X86_OPC_JL:
            assemble_jcc(s, tb, JCC_JL, instr);
            break;
        case X86_OPC_JLE:
            assemble_jcc(s, tb, JCC_JLE, instr);
            break;
        case X86_OPC_JG:
            assemble_jcc(s, tb, JCC_JG, instr);
            break;
        case X86_OPC_JGE:
            assemble_jcc(s, tb, JCC_JGE, instr);
            break;
        case X86_OPC_JE:
            assemble_jcc(s, tb, JCC_JE, instr);
            break;
        case X86_OPC_JNE:
            assemble_jcc(s, tb, JCC_JNE, instr);
            break;
        case X86_OPC_JS:
            assemble_jcc(s, tb, JCC_JS, instr);
            break;
        case X86_OPC_JNS:
            assemble_jcc(s, tb, JCC_JNS, instr);
            break;
        case X86_OPC_JMP:
            assemble_jcc(s, tb, JCC_JMP, instr);
            break;
        case X86_OPC_PUSH:
            assemble_push(s, tb, instr);
            break;
        case X86_OPC_POP:
            assemble_pop(s,  tb, instr);
            break;
        // used for when you want to save a registers to it's emualated guest memory
        case X86_OPC_SYNC_M:
            assemble_sync_m(s, instr);
            break;
        // used for when you want to load a registers from it's emualated guest memory
        case X86_OPC_SYNC_R:
            assemble_sync_r(s, instr);
            break;
		case X86_OPC_PC_IR:
            assemble_pc_ir(s, tb, instr);
            break;
		case X86_OPC_PC_RR:
            assemble_pc_rr(s, tb, instr);
            break;
        case X86_OPC_SET_LABEL:
            assemble_set_label(s, instr);
            break;
		case X86_OPC_MULL:
            assemble_mull(s, tb, instr); 
            break;
		case X86_OPC_JMPL:
            assemble_jmpl(s,tb, instr); 
            break;
		case X86_OPC_CLZ:
            //assemble_clz(s,  tb,instr); 
            break;
        default:
            fprintf(stderr, "Unsupported x86 instruction in the assembler: %s, rule index: %d\n",
                    get_x86_opc_str(instr->opc), rrule->rule->index);
    }
}

void assemble_x86_exit_tb(TCGContext *s, target_ulong target_pc)
{
    tcg_sync_globals(s);
    tcg_out_exit_tb_rule(s, target_pc);
}
