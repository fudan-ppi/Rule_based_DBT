#include <assert.h>

#include "qemu/osdep.h"
#include "qemu-common.h"
#include "exec/cpu-common.h"
#include "cpu.h"
#include "exec/exec-all.h"
#include "tcg-op.h"
#include "x86-asm.h"
#include "rule-translate.h"
#include "expr.tab.h"

#define MAX_RULE_RECORD_BUF_LEN 800
#define MAX_GUEST_INSTR_LEN 800
#define MAX_HOST_RULE_LEN 800

#define MAX_MAP_BUF_LEN 1000
#define MAX_HOST_RULE_INSTR_LEN 1000

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

static const X86Opcode ARM2X86[] = {
    [ARM_OPC_LDRB]  = X86_OPC_MOVZBL,
    [ARM_OPC_LDRSB] = X86_OPC_MOVSBL,
    [ARM_OPC_LDRH]  = X86_OPC_MOVZWL,
    [ARM_OPC_LDRSH] = X86_OPC_MOVSWL,
    [ARM_OPC_LDR]   = X86_OPC_MOVL,
    [ARM_OPC_STRB]  = X86_OPC_MOVB,
    [ARM_OPC_STRH]  = X86_OPC_MOVW,
    [ARM_OPC_STR]   = X86_OPC_MOVL,
    [ARM_OPC_MOV]   = X86_OPC_MOVL,
    [ARM_OPC_MOVS]  = X86_OPC_MOVL,
    [ARM_OPC_MVN]   = X86_OPC_INVALID,
    [ARM_OPC_MVNS]  = X86_OPC_INVALID,
    [ARM_OPC_AND]   = X86_OPC_ANDL,
    [ARM_OPC_ANDS]  = X86_OPC_ANDL,
    [ARM_OPC_ORR]   = X86_OPC_ORL,
    [ARM_OPC_ORRS]  = X86_OPC_ORL,
    [ARM_OPC_EOR]   = X86_OPC_XORL,
    [ARM_OPC_EORS]  = X86_OPC_XORL,
    [ARM_OPC_BIC]   = X86_OPC_INVALID,
    [ARM_OPC_BICS]  = X86_OPC_INVALID,
    [ARM_OPC_LSL]   = X86_OPC_SHLL,
    [ARM_OPC_LSR]   = X86_OPC_SHRL,
    [ARM_OPC_RRX]   = X86_OPC_INVALID,
    [ARM_OPC_LSRS]  = X86_OPC_INVALID,
    [ARM_OPC_ASR]   = X86_OPC_SARL,
    [ARM_OPC_ADD]   = X86_OPC_ADDL,
    [ARM_OPC_ADC]   = X86_OPC_ADCL,
    [ARM_OPC_SUB]   = X86_OPC_SUBL,
    [ARM_OPC_SBC]   = X86_OPC_SBBL,
    [ARM_OPC_RSC]   = X86_OPC_INVALID,
    [ARM_OPC_ADDS]  = X86_OPC_ADDL,
    [ARM_OPC_ADCS]  = X86_OPC_ADCL,
    [ARM_OPC_SUBS]  = X86_OPC_SUBL,
    [ARM_OPC_SBCS]  = X86_OPC_SBBL,
    [ARM_OPC_RSCS]  = X86_OPC_INVALID,
    [ARM_OPC_MUL]   = X86_OPC_IMULL,
    [ARM_OPC_UMULL] = X86_OPC_MULL,
    [ARM_OPC_UMLAL] = X86_OPC_INVALID,
    [ARM_OPC_SMULL] = X86_OPC_INVALID,
    [ARM_OPC_SMLAL] = X86_OPC_INVALID,
    [ARM_OPC_MLA]   = X86_OPC_INVALID,
    [ARM_OPC_RSB]   = X86_OPC_INVALID,
    [ARM_OPC_RSBS]  = X86_OPC_INVALID,
    [ARM_OPC_CLZ]   = X86_OPC_INVALID,
    [ARM_OPC_TST]   = X86_OPC_INVALID,
    [ARM_OPC_TEQ]   = X86_OPC_INVALID,
    [ARM_OPC_CMP]   = X86_OPC_CMPL,
    [ARM_OPC_CMN]   = X86_OPC_INVALID,
    [ARM_OPC_B]     = X86_OPC_JMP,
    [ARM_OPC_BL]    = X86_OPC_CALL,
    [ARM_OPC_BX]    = X86_OPC_INVALID,
    [ARM_OPC_PUSH]  = X86_OPC_INVALID,
    [ARM_OPC_POP]   = X86_OPC_INVALID
};


static ImmMapping imm_map_buf[MAX_MAP_BUF_LEN];
static int imm_map_buf_index = 0;

static LabelMapping label_map_buf[MAX_MAP_BUF_LEN];
static int label_map_buf_index = 0;

static GuestRegisterMapping g_reg_map_buf[MAX_MAP_BUF_LEN];
static int g_reg_map_buf_index = 0;

static RuleRecord rule_record_buf[MAX_RULE_RECORD_BUF_LEN];
static int rule_record_buf_index = 0;

static target_ulong pc_matched_buf[MAX_GUEST_INSTR_LEN];
static int pc_matched_buf_index = 0;

static int imm_map_buf_index_pre = 0;
static int g_reg_map_buf_index_pre = 0;
static int label_map_buf_index_pre = 0;
static int record_host_instr_buf_index_pre = 0;
static int record_host_buf_index_pre = 0;

static ImmMapping *imm_map;
static GuestRegisterMapping *g_reg_map;
static LabelMapping *l_map;
static int par_opc[20];
static int debug = 0;
static int match_insts = 0;
static int match_counter = 10;

static TranslationRule record_host_buf[MAX_HOST_RULE_LEN];
static int record_host_buf_index = 0;

static X86Instruction record_host_instr_buf[MAX_HOST_RULE_INSTR_LEN];
static int record_host_instr_buf_index = 0;

static target_ulong pc_para_matched_buf[MAX_GUEST_INSTR_LEN];
static int pc_para_matched_buf_index = 0;

static int reg_map_num = 0;

static inline void reset_buffer(void)
{
    imm_map_buf_index = 0;
    label_map_buf_index = 0;
    g_reg_map_buf_index = 0;

    rule_record_buf_index = 0;
    pc_matched_buf_index = 0;

    // record_host_instr_buf_index = 0;
    // record_host_buf_index = 0;

    pc_para_matched_buf_index = 0;
}

static inline void save_map_buf_index(void)
{
    imm_map_buf_index_pre = imm_map_buf_index;
    g_reg_map_buf_index_pre = g_reg_map_buf_index;
    label_map_buf_index_pre = label_map_buf_index;
    // record_host_instr_buf_index_pre = record_host_instr_buf_index;
    // record_host_buf_index_pre = record_host_buf_index;
}

static inline void recover_map_buf_index(void)
{
    imm_map_buf_index = imm_map_buf_index_pre;
    g_reg_map_buf_index = g_reg_map_buf_index_pre;
    label_map_buf_index = label_map_buf_index_pre;
    // record_host_instr_buf_index = record_host_instr_buf_index_pre;
    // record_host_buf_index = record_host_buf_index_pre;
}

static inline void init_map_ptr(void)
{
    imm_map = NULL;
    g_reg_map = NULL;
    l_map = NULL;
    reg_map_num = 0;
}

static inline void add_rule_record(TranslationRule *rule, target_ulong pc, target_ulong t_pc,
                                   int icount, bool update_cc, bool save_cc, int pa_opc[20])
{
    RuleRecord *p = &rule_record_buf[rule_record_buf_index++];

    assert(rule_record_buf_index < MAX_RULE_RECORD_BUF_LEN);

    p->pc = pc;
    p->target_pc = t_pc;
    p->icount = icount;
    p->next_pc = pc + 4 * icount;
    p->rule = rule;
    p->update_cc = update_cc;
    p->save_cc = save_cc;
    p->imm_map = imm_map;
    p->g_reg_map = g_reg_map;
    p->l_map = l_map;
    int i;
    for (i = 0; i < 20; i++)
        p->para_opc[i] = pa_opc[i];
}

// not worked
static bool used_following(ARMInstruction *ginstr, int idx, int skip){
    ARMInstruction *p_instr = ginstr;
    ARMRegister reg_name = p_instr->opd[idx].content.reg.num;
    int i, j;
    // skip instructions in this rule
    for (i = 0; i <= skip; i++){
        if (p_instr->next == NULL){
            return false;
        }
        p_instr = p_instr->next;
    }

    // check if this register is used in next 10 instructions
    for (i = 0; i < 10; i++){
        for(j = 0; j < p_instr->opd_num; j++) {
            ARMOperand opd = p_instr->opd[j];
            switch (opd.type){
                case ARM_OPD_TYPE_REG:
                    if (opd.content.reg.num == reg_name)
                        return true;
                    break;
                case ARM_OPD_TYPE_MEM:
                    if (opd.content.mem.base == reg_name)
                        return true;
                    if (opd.content.mem.index == reg_name)
                        return true;
                    break;
                default:
                    break;
            }
        }
        if (p_instr->next == NULL){
            return false;
        }
        p_instr = p_instr->next;
    }
    return false;
}

static inline void add_matched_pc(target_ulong pc)
{
    pc_matched_buf[pc_matched_buf_index++] = pc;

    assert(pc_matched_buf_index < MAX_GUEST_INSTR_LEN);
}

static inline void add_matched_para_pc(target_ulong pc)
{
    pc_para_matched_buf[pc_para_matched_buf_index++] = pc;

    assert(pc_para_matched_buf_index < MAX_GUEST_INSTR_LEN);
}


static bool match_label(char *lab_str, target_ulong t, target_ulong f)
{
    LabelMapping *lmap = l_map;

    while(lmap) {
        if (!strcmp(lmap->lab_str, lab_str)) {
            lmap = lmap->next;
            continue;
        }

        return (lmap->target == t && lmap->fallthrough == f);
    }

    /* append this map to label map buffer */
    lmap = &label_map_buf[label_map_buf_index++];
    assert(label_map_buf_index < MAX_MAP_BUF_LEN);
    strcpy(lmap->lab_str, lab_str);
    lmap->target = t;
    lmap->fallthrough = f;

    lmap->next = l_map;
    l_map = lmap;

    return true;
}

static bool match_register(ARMRegister greg, ARMRegister rreg)
{
    GuestRegisterMapping *gmap = g_reg_map;

    if (greg == ARM_REG_INVALID &&
        rreg == ARM_REG_INVALID)
        return true;

    if (greg == ARM_REG_INVALID ||
        rreg == ARM_REG_INVALID)
    {
        if (debug)
            fprintf(stderr, "Unmatch reg: invalid reg\n");
        return false;
    }

    // if (greg == ARM_REG_R15){
    //     if (debug)
    //         fprintf(stderr, "Unmatch reg: r15\n");
    //     return false;
    // }

    if ((greg == ARM_REG_R15 && rreg != ARM_REG_R15) || (greg != ARM_REG_R15 && rreg == ARM_REG_R15))
    {
        if (debug)
            fprintf(stderr, "Unmatch reg: r15\n");
        return false;
    }

    /* check if we already have this map */
    while (gmap)
    {
        if (gmap->sym != rreg)
        {
            gmap = gmap->next;
            continue;
        }
        if (debug && (gmap->num != greg))
            fprintf(stderr, "Unmatch reg: map conflict: %d %d\n", gmap->num, greg);
        return (gmap->num == greg);
    }

    /* check if this guest register has another map */
    gmap = g_reg_map;
    while (gmap)
    {
        if (gmap->num != greg)
        {
            gmap = gmap->next;
            continue;
        }

        if (debug && (gmap->sym != rreg))
            fprintf(stderr, "Unmatch reg: have anther map: %d %d %d\n", greg, gmap->sym, rreg);
        return (gmap->sym == rreg);
    }

    /* append this map to register map buffer */
    gmap = &g_reg_map_buf[g_reg_map_buf_index++];
    assert(g_reg_map_buf_index < MAX_MAP_BUF_LEN);
    gmap->sym = rreg;
    gmap->num = greg;
    ++reg_map_num;

    gmap->next = g_reg_map;
    g_reg_map = gmap;

    return true;
}

static bool match_imm(int32_t val, char *sym)
{
    ImmMapping *imap = imm_map;

    while(imap) {
        if (!strcmp(sym, imap->imm_str)){
            if (debug && (val != imap->imm_val))
                fprintf(stderr, "Unmatch imm: symbol map conflict %d %d\n", imap->imm_val, val);
            return (val == imap->imm_val);
        }

        imap = imap->next;
    }

    /* check if another immediate symbol map to the same value */
    imap = imm_map;
    while(imap) {
        if (imap->imm_val == val){
            if (debug)
                fprintf(stderr, "Unmatch imm: another symbol map %d\n", val);
            return false;
        }

        imap = imap->next;
    }

    /* add this map to immediate map buffer */
    imap = &imm_map_buf[imm_map_buf_index++];
    assert(imm_map_buf_index < MAX_MAP_BUF_LEN);
    strcpy(imap->imm_str, sym);
    imap->imm_val = val;

    imap->next = imm_map;
    imm_map = imap;

    return true;
}

static bool match_scale(ARMOperandScale *gscale, ARMOperandScale *rscale)
{
    if (gscale->type == ARM_OPD_SCALE_TYPE_NONE &&
        rscale->type == ARM_OPD_SCALE_TYPE_NONE)
        return true;

    #if 0
    if (gscale->type == ARM_OPD_SCALE_TYPE_NONE && gscale->direct == ARM_OPD_SCALE_NONE &&
        rscale->type == ARM_OPD_SCALE_TYPE_IMM  && rscale->direct != ARM_OPD_SCALE_NONE &&
        rscale->content.imm.type == ARM_IMM_TYPE_SYM)
        return match_imm(0, rscale->content.imm.content.sym);
    #endif

    if (gscale->direct != rscale->direct){
        if (debug)
            fprintf(stderr, "Unmatch scale direct: %d %d\n", gscale->direct, rscale->direct);
        return false;
    }

    if (gscale->type == ARM_OPD_SCALE_TYPE_IMM && rscale->type == ARM_OPD_SCALE_TYPE_IMM) {
        if (rscale->content.imm.type == ARM_IMM_TYPE_VAL){
            if (debug && (gscale->content.imm.content.val != rscale->content.imm.content.val))
                fprintf(stderr, "Unmatch scale value: %d %d\n", gscale->content.imm.content.val, rscale->content.imm.content.val);
            return gscale->content.imm.content.val == rscale->content.imm.content.val;
        }
        else if (rscale->content.imm.type == ARM_IMM_TYPE_NONE)
            return match_imm(0, rscale->content.imm.content.sym);
        else
            return match_imm(gscale->content.imm.content.val, rscale->content.imm.content.sym);
    } else if (gscale->type == ARM_OPD_SCALE_TYPE_REG && rscale->type == ARM_OPD_SCALE_TYPE_REG)
        return match_register(gscale->content.reg, rscale->content.reg);
    else{
        if (debug)
            fprintf(stderr, "Unmatch scale: type error\n");
        return false;
    }
}

static bool match_offset(ARMImm *goffset, ARMImm *roffset)
{
    int32_t off_val;
    char *sym;

    if (roffset->type != ARM_IMM_TYPE_NONE &&
        goffset->type == ARM_IMM_TYPE_NONE)
        return match_imm(0, roffset->content.sym);

    if (goffset->type == ARM_IMM_TYPE_NONE &&
        roffset->type == ARM_IMM_TYPE_NONE)
        return true;

    if (roffset->type == ARM_IMM_TYPE_NONE &&
        goffset->type == ARM_IMM_TYPE_VAL && goffset->content.val == 0)
        return true;
    
    if (goffset->type == ARM_IMM_TYPE_NONE ||
        roffset->type == ARM_IMM_TYPE_NONE){
        if (debug) {
            fprintf(stderr, "Unmatch offset: none\n");
        }
        return false;
    }

    sym = roffset->content.sym;
    off_val = goffset->content.val;

    return match_imm(off_val, sym);
}

static bool match_index_type(ARMMemIndexType gtype, ARMMemIndexType rtype)
{
    if (debug && (gtype != rtype))
        fprintf(stderr, "Unmatch index type: %d %d\n", gtype, rtype);
    return (gtype == rtype);
}

static bool match_opd_imm(ARMImmOperand *gopd, ARMImmOperand *ropd)
{
    if (gopd->type == ARM_IMM_TYPE_NONE && ropd->type == ARM_IMM_TYPE_NONE)
        return true;

    if (ropd->type == ARM_IMM_TYPE_VAL)
        return (gopd->content.val == ropd->content.val);
    else if (ropd->type == ARM_IMM_TYPE_SYM)
        return match_imm(gopd->content.val, ropd->content.sym);
    else{
        if (debug)
            fprintf(stderr, "Unmatch imm: type error\n");
        return false;
    }
}

static bool match_opd_reg(ARMRegOperand *gopd, ARMRegOperand *ropd)
{
    return (match_register(gopd->num, ropd->num) &&
            match_scale(&gopd->scale, &ropd->scale));
}

static bool match_addr_op(ARMMemAddrOpType gop, ARMMemAddrOpType rop)
{
    return (gop == rop);
}

static bool match_opd_mem(ARMMemOperand *gopd, ARMMemOperand *ropd)
{
    return (match_register(gopd->base, ropd->base) &&
            match_register(gopd->index, ropd->index) &&
            match_offset(&gopd->offset, &ropd->offset) &&
            match_scale(&gopd->scale, &ropd->scale) &&
            match_index_type(gopd->pre_post, ropd->pre_post) &&
            match_addr_op(gopd->addr_op, ropd->addr_op));
}

/* Try to match operand in guest instruction (gopd) and and the rule (ropd) */
static bool match_operand(ARMInstruction *ginstr, ARMInstruction *rinstr, int opd_idx)
{
    ARMOperand *gopd = &ginstr->opd[opd_idx];
    ARMOperand *ropd = &rinstr->opd[opd_idx];

    // if (debug){
    //     fprintf(stderr, "ropd->type: %d\n", ropd->type);
    // }

    if (gopd->type != ropd->type)
        return false;
	
	if((ropd->type == ARM_OPD_TYPE_REG && ropd->content.reg.num == ARM_REG_R15)
	||(ropd->type == ARM_OPD_TYPE_MEM && ropd->content.mem.base == ARM_REG_R15))
	{
		unsigned int pc_val = ginstr->pc + 8;
		ImmMapping * imap = &imm_map_buf[imm_map_buf_index++];
		assert(imm_map_buf_index < MAX_MAP_BUF_LEN);
   		strcpy(imap->imm_str, "imm_pc");
    	imap->imm_val = pc_val;
    	imap->next = imm_map;
    	imm_map = imap;
	}
	
	if(ginstr->opc == ARM_OPC_BL)
	{
		unsigned int pc_val = ginstr->pc + 4;
		ImmMapping * imap = &imm_map_buf[imm_map_buf_index++];
		assert(imm_map_buf_index < MAX_MAP_BUF_LEN);
   		strcpy(imap->imm_str, "imm_pc");
    	imap->imm_val = pc_val;
    	imap->next = imm_map;
    	imm_map = imap;
	}
	
	
    if (ropd->type == ARM_OPD_TYPE_IMM) {
        if (rinstr->opc == ARM_OPC_B) {
            assert(ropd->content.imm.type == ARM_IMM_TYPE_SYM);
            return match_label(ropd->content.imm.content.sym, gopd->content.imm.content.val, ginstr->pc+4);
        } else /* match imm operand */
            return match_opd_imm(&gopd->content.imm, &ropd->content.imm);
    } else if (ropd->type == ARM_OPD_TYPE_REG) {
        return match_opd_reg(&gopd->content.reg, &ropd->content.reg);
    } else if (ropd->type == ARM_OPD_TYPE_MEM) {
        return match_opd_mem(&gopd->content.mem, &ropd->content.mem);
    } else
        fprintf(stderr, "Error: unsupported arm operand type: %d\n", ropd->type);    

    return true;
}


static bool check_instr(ARMInstruction *ginstr){
    int i;

    // op reg0, reg0, reg1, lsl imm can not be translated by parameterized rule
    // if (ginstr->opd_num == 3)
    // {
    //     if ((ginstr->opd[0].content.reg.num == ginstr->opd[1].content.reg.num) &&
    //         (ginstr->opd[2].type == ARM_OPD_TYPE_REG) &&
    //         (ginstr->opd[0].content.reg.num != ginstr->opd[2].content.reg.num) &&
    //         (ginstr->opd[2].content.reg.scale.type != ARM_OPD_SCALE_TYPE_NONE))
    //     {
    //         return false;
    //     }
    // }

    //pc register can not be translated by rules now
    for (i = 0; i < ginstr->opd_num; i++){
        switch (ginstr->opd[i].type){
            case ARM_OPD_TYPE_REG:
                if (ginstr->opd[i].content.reg.num == ARM_REG_R15)
                    return false;
                break;
            case ARM_OPD_TYPE_MEM:
                if (ginstr->opd[i].content.mem.base == ARM_REG_R15)
                    return false;
                if (ginstr->opd[i].content.mem.index == ARM_REG_R15)
                    return false;
                break;
        }
    }
    return true;
}

// return: 
// 0: not matched
// 1: matched
// 2:matched but condition is different

static bool match_rule_internal(ARMInstruction *instr, TranslationRule *rule, TranslationBlock *tb)
{
    ARMInstruction *p_rule_instr = rule->arm_guest;
    ARMInstruction *p_guest_instr = instr;
    ARMInstruction *last_guest_instr = NULL;
    int i;

    int j = 0;
    /* init for this rule */
    init_map_ptr();

    while(p_rule_instr) {

        if (p_rule_instr->opc == ARM_OPC_INVALID || 
            p_guest_instr->opc == ARM_OPC_INVALID){
            return false;
        }

        /* check cc, opcode and number of operands */

        if ((p_rule_instr->cc != ARM_CC_AL && p_rule_instr->cc != p_guest_instr->cc) || // condition not equal
            ((p_rule_instr->opc != p_guest_instr->opc) && (opc_set[p_guest_instr->opc] != p_rule_instr->opc)) || //opcode not equal
            ((p_rule_instr->opd_num != 0) && (p_rule_instr->opd_num != p_guest_instr->opd_num))) { //operand not equal
            #if 0
            if (instr->pc == 0x17ae0) {
                fprintf(stderr, "rule opc: %d, instr opc: %d\n", p_rule_instr->opc, p_guest_instr->opc);
                fprintf(stderr, "rule opd_num: %d, instr opd num: %d\n", p_rule_instr->opd_num, p_guest_instr->opd_num);
            }
            #endif

            if (debug){
                if (p_rule_instr->cc != p_guest_instr->cc){
                    fprintf(stderr, "different cc\n");
                }
                if (p_rule_instr->opd_num != p_guest_instr->opd_num)
                    fprintf(stderr, "different operand number\n");
            }

            return false;
        }

        if ((p_guest_instr->opc == ARM_OPC_STRH)){
            if (p_guest_instr->opd[1].content.mem.index == ARM_REG_INVALID){
                return false;
            }
        }

        /*check parameterized instructions*/
        if ((p_rule_instr->opd_num == 0) && !check_instr(p_guest_instr)){
            if (debug){
                fprintf(stderr, "parameterization check error\n");
            }
            return false;
        }

        /* match each operand */
        for(i = 0; i < p_rule_instr->opd_num; i++) {
            if (!match_operand(p_guest_instr, p_rule_instr, i)) {
                //if (instr->pc == 0x17ae0)
                //    fprintf(stderr, "rule opc: %d, instr opc: %d\n", p_rule_instr->opc, p_guest_instr->opc);
                if (debug){
                    fprintf(stderr, "guest->type: %d\n", p_guest_instr->opd[i].type);
                    fprintf(stderr, "rule->type: %d\n", p_rule_instr->opd[i].type);
                    if (p_guest_instr->opd[i].type == p_rule_instr->opd[i].type){
                        fprintf(stderr, "Unmatched operand :");
                        if (p_guest_instr->opd[i].type == ARM_OPD_TYPE_MEM){
                                print_mem_opd(&(p_guest_instr->opd[i].content.mem));
                                print_mem_opd(&(p_rule_instr->opd[i].content.mem));
                                fprintf(stderr, "\n");
                        }
                        else if (p_guest_instr->opd[i].type == ARM_OPD_TYPE_IMM){    
                                print_imm_opd(&(p_guest_instr->opd[i].content.imm));
                                print_imm_opd(&(p_rule_instr->opd[i].content.imm));
                                fprintf(stderr, "\n");
                        }
                        else if(p_guest_instr->opd[i].type == ARM_OPD_TYPE_REG){
                                print_reg_opd(&(p_guest_instr->opd[i].content.reg));
                                print_reg_opd(&(p_rule_instr->opd[i].content.reg));
                                fprintf(stderr, "\n");
                        }
                        else{
                                fprintf(stderr, "Error oprand\n");
                        }
                    }
                }
                return false;
            }
        }

        //if (instr->pc == 0x17ae0)
        //    fprintf(stderr, "matched...\n")

        last_guest_instr = p_guest_instr;

        /* check next instruction */
        p_rule_instr = p_rule_instr->next;
        p_guest_instr = p_guest_instr->next;
        j++;
    }

    if (last_guest_instr) {
        bool *p_reg_liveness = last_guest_instr->reg_liveness;
        if ((p_reg_liveness[ARM_REG_CF] && (rule->arm_cc_mapping[ARM_CF] == 0)) ||
            (p_reg_liveness[ARM_REG_NF] && (rule->arm_cc_mapping[ARM_NF] == 0)) ||
            (p_reg_liveness[ARM_REG_VF] && (rule->arm_cc_mapping[ARM_VF] == 0)) ||
            (p_reg_liveness[ARM_REG_ZF] && (rule->arm_cc_mapping[ARM_ZF] == 0))){

                if (debug) {
                    fprintf(stderr, "Different liveness cc!\n");
                }
                return false;
            }
    }


    return true;
}

void get_label_map(char *lab_str, target_ulong *t, target_ulong *f)
{
    LabelMapping *lmap = l_map;

    while(lmap) {
        if (!strcmp(lmap->lab_str, lab_str)) {
            *t = lmap->target;
            *f = lmap->fallthrough;
            return;
        }
        lmap = lmap->next;
    }

    assert (0); 
}

extern int parse_str_to_int(char *s);
int32_t get_imm_map(char *sym)
{
    ImmMapping *im = imm_map;
    char t_str[50]; /* replaced string */
    char t_buf[50]; /* buffer string */

    /* Due to the expression in host imm_str, We replace all imm_xxx in host imm_str 
       with the corresponding guest values, and parse it to get the value of the expression */
    strcpy(t_str, sym);
    //fprintf(stderr ,"====================sym: %s\n", t_str);
    while(im) {
        char *p_str = strstr(t_str, im->imm_str);
        while (p_str) {
            //fprintf(stderr, "\t found a matched string for %s, value: %d\n", im->imm_str, im->imm_val);
            size_t len = (size_t)(p_str - t_str);
            strncpy(t_buf, t_str, len);
            sprintf(t_buf + len, "%d", im->imm_val);
            strncat(t_buf, t_str + len + strlen(im->imm_str), strlen(t_str) - len - strlen(im->imm_str));
            strcpy(t_str, t_buf);
            p_str = strstr(t_str, im->imm_str);
        }
        im = im->next;
    }
    //fprintf(stderr, "=================val str: %s\n", t_str);
    //fprintf(stderr, "=================val val: %d %x\n", parse_str_to_int(t_str), parse_str_to_int(t_str));
    return parse_str_to_int(t_str);
}


ARMRegister get_guest_reg_map(X86Register reg)
{
    GuestRegisterMapping *gmap = g_reg_map;

    while (gmap) {
        if (!strcmp(get_arm_reg_str(gmap->sym), get_x86_reg_str(reg))) {
            //fprintf(stderr, "x86 reg: %d, arm reg: %d\n", reg, gmap->num);
            return gmap->num;
        }

        gmap = gmap->next;
    }

    assert(0);
    return ARM_REG_INVALID;
}

bool instr_is_match(target_ulong pc)
{
    int i;
    for (i = 0; i < pc_matched_buf_index; i++) {
        if (pc_matched_buf[i] == pc)
            return true;
    }
    return false;
}

bool instrs_is_match(target_ulong pc)
{
    int i;
    for (i = 0; i < pc_para_matched_buf_index; i++) {
        if (pc_para_matched_buf[i] == pc)
            return true;
    }
    return instr_is_match(pc);
}

bool tb_rule_matched(void)
{
    return (pc_matched_buf_index != 0);
}

bool check_translation_rule(target_ulong pc)
{
    int i;
    for (i = 0; i < rule_record_buf_index; i++) {
        if (rule_record_buf[i].pc == pc)
            return true;
    }
    return false;
}

RuleRecord *get_translation_rule(target_ulong pc)
{
    int i;
    for (i = 0; i < rule_record_buf_index; i++) {
        if (rule_record_buf[i].pc == pc) {
            rule_record_buf[i].pc = 0xffffffff; /* disable it after translation */
            return &rule_record_buf[i];
        }
    }
    return NULL;
}

/* For debugging */
#if defined(DEBUG_RULE_TRANSLATION)
static target_ulong skip_pc[] = {
};
static target_ulong take_pc[] = {
};
#endif

#ifdef PROFILE_RULE_TRANSLATION
uint32_t static_inst_rule_counter = 0;
#endif

static bool is_update_cc(ARMInstruction *pins, int icount)
{
    ARMInstruction *head = pins;
    int i;

    for (i = 0; i < icount; i++) {
        if (head->opc == ARM_OPC_ADDS || head->opc == ARM_OPC_SUBS ||
            head->opc == ARM_OPC_ORRS || head->opc == ARM_OPC_ANDS ||
            head->opc == ARM_OPC_CMP || head->opc == ARM_OPC_CMN ||
            head->opc == ARM_OPC_TST || head->opc == ARM_OPC_TEQ)
            return true;
        head = head->next;
    }

    return false;
}

static bool is_save_cc(ARMInstruction *pins, int icount)
{
    ARMInstruction *head = pins;
    int i;

    for (i = 0; i < icount; i++) {
        if (head->save_cc)
            return true;
        head = head->next;
    }

    return false;
}

ARMInstruction* reorder_instructions(ARMInstruction *guest_instr){
    
    ARMInstruction *cur_head = guest_instr;
    int i;
    
    while (cur_head){
        
        
        for (i = 0; i < cur_head->opd_num; i++){

        }

        cur_head = cur_head->next;

    }


}

static X86Register generate_matched_reg(ARMRegister greg){
    GuestRegisterMapping *gmap = g_reg_map;

    if (greg == ARM_REG_R15)
        return X86_REG_INVALID;

    /* check if this guest register has a map */
    while(gmap) {
        if (gmap->num == greg) {
            // X86 reg0 is 19
            //ARM reg0 is 21 
            return (X86Register)(gmap->sym - 2);
        }
        gmap = gmap->next;
    }

    /* append this map to register map buffer */
    gmap = &g_reg_map_buf[g_reg_map_buf_index++];
    assert(g_reg_map_buf_index < MAX_MAP_BUF_LEN);
    //ARM reg0 start from X86Instruction enum 21
    gmap->sym = (ARMRegister)(reg_map_num + 21);
    gmap->num = greg;

    gmap->next = g_reg_map;
    g_reg_map = gmap;
    ++reg_map_num;

    return (X86Register)(gmap->sym - 2);
}

static bool generate_matched_imm(X86Imm *opd, int32_t val){
    opd->type = X86_IMM_TYPE_VAL;
    opd->content.val = val;
}

// two operands instructions' matching
//op reg, reg/imm
static bool topd_instr_opd_match(X86Instruction *n_host, ARMInstruction *p_guest){
    int host_i, guest_i = 0;
    X86Register h_reg;
    // for (i = 0; i < p_guest->opd_num; i++){
    while (p_guest->opd[guest_i].type != ARM_OPD_TYPE_INVALID){
        host_i = (opc_set[p_guest->opc] == ARM_OPC_OP4)?guest_i:(1-guest_i);
        n_host->opd_num++;
        // fprintf(stderr, "opd_num: %d\n", i);
        switch (p_guest->opd[guest_i].type){
            case ARM_OPD_TYPE_IMM:
                n_host->opd[host_i].type = X86_OPD_TYPE_IMM;
                generate_matched_imm(&n_host->opd[host_i].content.imm, p_guest->opd[guest_i].content.imm.content.val);
                break;
            case ARM_OPD_TYPE_REG:
                
                n_host->opd[host_i].type = X86_OPD_TYPE_REG;
                if ((h_reg = generate_matched_reg(p_guest->opd[guest_i].content.reg.num)) == X86_REG_INVALID)
                    return false;
                n_host->opd[host_i].content.reg.num = h_reg;
                // only in mov reg, reg, shift imm
                //TODO
                if (p_guest->opd[guest_i].content.reg.scale.type != ARM_OPD_SCALE_NONE){
                //     if (p_guest->opd[guest_i].scale.type == ARM_OPD_SCALE_TYPE_REG)
                    // fprintf(stderr, "====Reg scale error\n");
                    return false;
                //     X86Insruction shift_instr = record_host_instr_buf[record_host_instr_buf_index++];
                //     shift_instr->opc = 
                }
                break;
            case ARM_OPD_TYPE_MEM:
                if (p_guest->opd[guest_i].content.mem.pre_post != ARM_MEM_INDEX_TYPE_NONE)
                    return false;
                n_host->opd[host_i].type = X86_OPD_TYPE_MEM;

                if ((h_reg = generate_matched_reg(p_guest->opd[guest_i].content.mem.base)) == X86_REG_INVALID)
                    return false;
                n_host->opd[host_i].content.mem.base = h_reg;

                if (p_guest->opd[guest_i].content.mem.offset.type != ARM_IMM_TYPE_NONE)
                generate_matched_imm(&n_host->opd[host_i].content.mem.offset, p_guest->opd[guest_i].content.mem.offset.content.val);

                if (p_guest->opd[guest_i].content.mem.index != ARM_REG_INVALID){
                    if ((h_reg = generate_matched_reg(p_guest->opd[guest_i].content.mem.index)) == X86_REG_INVALID)
                        return false;
                    n_host->opd[host_i].content.mem.index = h_reg;
                }

                if (p_guest->opd[guest_i].content.mem.scale.type != ARM_OPD_SCALE_TYPE_NONE){
                    int32_t scale_val = 0;
                    switch (p_guest->opd[guest_i].content.mem.scale.direct){
                        case ARM_OPD_SCALE_LSL:
                            scale_val = 1<<(p_guest->opd[guest_i].content.mem.scale.content.imm.content.val);
                            break;
                        case ARM_OPD_SCALE_LSR:
                        case ARM_OPD_SCALE_ASR:
                            scale_val = 1>>(p_guest->opd[guest_i].content.mem.scale.content.imm.content.val);
                            break;
                        default:
                            // fprintf(stderr, "====Mem scale error\n");
                            return false;
                    }
                    generate_matched_imm(&n_host->opd[host_i].content.mem.scale, scale_val);
                }
                break;
            default:
                return false;
        }
        ++guest_i;
    }
    return true;
}

static bool al_instr_shift_match(X86Instruction *n_host, ARMOperand *p_guest_opd){

    

}

//x86:
//op opd, {reg0}
static bool al_instr_reg_match(X86Operand *n_host, ARMOperand *p_guest){
    X86Register h_reg;
    n_host->type = X86_OPD_TYPE_REG;
    if ((h_reg = generate_matched_reg(p_guest->content.reg.num)) == X86_REG_INVALID)
        return false;
    n_host->content.reg.num = h_reg;
    return true;
}

// x86:
// op {opd}, reg0
static bool al_instr_opd_match(X86Operand *n_host, ARMOperand *p_guest){

    X86Register h_reg;

        switch (p_guest->type){
            case ARM_OPD_TYPE_IMM:
                n_host->type = X86_OPD_TYPE_IMM;
                generate_matched_imm(&n_host->content.imm, p_guest->content.imm.content.val);
                break;
            case ARM_OPD_TYPE_REG:
                n_host->type = X86_OPD_TYPE_REG;
                if ((h_reg = generate_matched_reg(p_guest->content.reg.num)) == X86_REG_INVALID)
                    return false;
                n_host->content.reg.num = h_reg;
                break;
            default:
                return false;
        }
        return true;
}
//arithmetic & logic instructions' operands matching
//op reg0, reg1, opd
//op reg0, reg0, opd
static X86Instruction* al_instr_match(X86Instruction *n_host, ARMInstruction *p_guest){

    X86Register h_reg;

    //op reg0, reg0, ...
    if (p_guest->opd[0].content.reg.num == p_guest->opd[1].content.reg.num){

        //op reg0, reg0, reg shift imm/reg
        //can not be translated by rules
        if ((p_guest->opd[2].type == ARM_OPD_TYPE_REG) && (p_guest->opd[2].content.reg.scale.type != ARM_OPD_SCALE_NONE))
            return NULL;
        
        //x86:
        //op opd, reg0
        if (!al_instr_reg_match(&n_host->opd[1], &p_guest->opd[0]) & !al_instr_opd_match(&n_host->opd[0], &p_guest->opd[2]))
            return NULL;
        n_host->opd_num = 2;
    }
    else //op reg0, reg1, opd
    {
        //mov opd, reg0
        //mov opd, {reg0}
        X86Instruction *temp_mov = NULL;
        X86Instruction *temp_shift = NULL;
        temp_mov = &record_host_instr_buf[record_host_instr_buf_index++];
        temp_mov->opc = X86_OPC_MOVL;
        temp_mov->opd_num = 2;
        if (!al_instr_reg_match(&temp_mov->opd[1], &p_guest->opd[0]) & !al_instr_opd_match(&temp_mov->opd[0], &p_guest->opd[2]))
            return NULL;

        //if opd has shift
        if ((p_guest->opd[2].type == ARM_OPD_TYPE_REG) && (p_guest->opd[2].content.reg.scale.type != ARM_OPD_SCALE_NONE)){
            temp_shift = &record_host_instr_buf[record_host_instr_buf_index++];
            //opc
            switch (p_guest->opd[2].content.reg.scale.direct){
                case ARM_OPD_SCALE_LSL:
                    temp_shift->opc = X86_OPC_SHLL;
                    break;
                case ARM_OPD_SCALE_LSR:
                    temp_shift->opc = X86_OPC_SHRL;
                    break;
                case ARM_OPD_SCALE_ASR:
                    temp_shift->opc = X86_OPC_SARL; 
                    break;
                default:
                    return NULL;
            }

            //op opd, reg0
            temp_shift->opd[0].type = X86_OPD_TYPE_IMM;
            generate_matched_imm(&temp_shift->opd[0].content.imm, p_guest->opd[2].content.reg.scale.content.imm.content.val);
            temp_shift->opd[1].type = X86_OPD_TYPE_REG;
            temp_shift->opd[1].content.reg.num = temp_mov->opd[1].content.reg.num;

            temp_shift->opd_num = 2;
        }

        //op reg1, reg0

        if (!al_instr_reg_match(&n_host->opd[0], &p_guest->opd[1]) & !al_instr_reg_match(&n_host->opd[1], &p_guest->opd[0]))
            return NULL;
        n_host->opd_num = 2;

        if (temp_shift){
            temp_mov->next = temp_shift;
            temp_shift->next = n_host;
        }else
        {
            temp_mov->next = n_host;
        }
        return temp_mov;
        
    }
    
    return n_host;
}

/* Try to match instructions in this tb with existing rules */
void match_translation_rule(TranslationBlock *tb, int *print_block)
{
    if (match_counter <= 0)
        return;
    ARMInstruction *guest_instr = tb->guest_instr;
    ARMInstruction *cur_head = guest_instr;
    int guest_instr_num = 0;
    int i, j;

    // fprintf(stderr, "=====Guest=====\n");
    // print_arm_instr_seq(cur_head);

    /* Hack: disable these bbs for rule translation */
    if (tb->pc == 0x00080850 /* 471.omnetpp */ ||
        tb->pc == 0x80204    /* 471.omnetpp */ ||
        tb->pc == 0x1be1e4   /* 403.gcc */     ||
        tb->pc == 0x1b9c0    /* sjeng    */    ||
        tb->pc == 0x1b9c8    /* sjeng    */    ||
        tb->pc == 0x1b99c   /*sjeng */         ||
        tb->pc == 0x188c4   /*458.sjeng */     ||
        tb->pc == 0x2866a4  /* 403.gcc */      ||
        tb->pc == 0x110094  /*400.perlbench  */||
        tb->pc == 0x6005c   /*400.perlbench  */||
        tb->pc == 0x53a8c  /*456.hmmer  */     ||
        tb->pc == 0x49b0c  /*456.hmmer  */     ||
        tb->pc == 0x40894744 /* 471.omnetpp */ ||
        tb->pc == 0x809c4    /* 471.omnetpp */ ||
        tb->pc == 0x29757c   /* 483.xalancbmk */)
        return;

    reset_buffer();

    #if defined(DEBUG_RULE_TRANSLATION)
    for (i = 0; i < sizeof(skip_pc)/sizeof(skip_pc[0]); i++) {
        if (skip_pc[i] == tb->pc)
            return;
    }
    #if 0
    bool take = false;
    for (i = 0; i < sizeof(take_pc)/sizeof(take_pc[0]); i++) {
        if (take_pc[i] == tb->pc) {
            take = true;
            break;
        }
    }
    if (!take)
        return;
    #endif
    #endif

    /* Try from the longest rule */
    while (cur_head) {
        if (cur_head->opc == ARM_OPC_INVALID) {
            cur_head = cur_head->next;
            guest_instr_num--;
            continue;
        }

        if((cur_head->pc == 0x26c19c) || (cur_head->pc == 0x2892a0)){
            cur_head = cur_head->next;
            guest_instr_num--;
            continue;
        }

        int types = -1;
        bool opd_para = false;

        if (guest_instr_num <= 0){
            ARMInstruction *t_head = cur_head;
            guest_instr_num = 0;
            while ((t_head) && (t_head->cc == cur_head->cc)){
                // while (t_head){
                ++guest_instr_num;
                if ((t_head->opc == ARM_OPC_CMP) 
                || (t_head->opc == ARM_OPC_TST)
                || (t_head->opc == ARM_OPC_TEQ)
                || (t_head->opc == ARM_OPC_MOVS)
                || (t_head->opc == ARM_OPC_MVNS)
                || (t_head->opc == ARM_OPC_ANDS)
                || (t_head->opc == ARM_OPC_ORRS)
                || (t_head->opc == ARM_OPC_EORS)
                || (t_head->opc == ARM_OPC_BICS)
                || (t_head->opc == ARM_OPC_LSRS)
                || (t_head->opc == ARM_OPC_ADDS)
                || (t_head->opc == ARM_OPC_ADCS)
                || (t_head->opc == ARM_OPC_SUBS)
                || (t_head->opc == ARM_OPC_SBCS)
                || (t_head->opc == ARM_OPC_RSCS)
                || (t_head->opc == ARM_OPC_RSBS)
                || (t_head->opc == ARM_OPC_CMN)){
                    if (t_head->cc != ARM_CC_AL)
                        break;
                    if ((t_head->next) && (t_head->next->opc == ARM_OPC_B)){
                        ++guest_instr_num;
                        t_head = t_head->next;
                    }
                }
                t_head = t_head->next;
            }
        }

        for(i = guest_instr_num; i > 0; i--) {
        // for(i = max; i > 0; i--) {
            /* calculate hash key */
            int hindex = rule_hash_key(cur_head, i);
        #ifdef PROFILE_RULE_DEBUG
            if (i == 1){
                debug = 1;
                fprintf(stderr, "#####instr block#####\n");
            }
            else debug = 0;
        #endif

            if (hindex > MAX_GUEST_LEN)
                continue;
            /* check rule with length i (number of guest instructions) */
            TranslationRule *cur_rule = cache_rule_table[hindex];

            save_map_buf_index();
            while(cur_rule) {

                // if ((cur_rule->arm_guest->opc == ARM_OPC_OP1)){
                //     fprintf(stderr, "OP1 try\n");
                // }


                if (cur_rule->guest_instr_num != i)
                    goto next;

                // if ((cur_rule->arm_guest->opc == ARM_OPC_OP1)){
                //     fprintf(stderr, "OP1 match\n");
                //     // print_arm_instr(cur_rule->arm_guest);
//                if (debug)
//                    print_arm_instr(cur_head);
                // }

                if ((cur_rule->index == 820 && cur_head->opc == ARM_OPC_ADD) || (cur_rule->index == 2079 && (cur_head->opc == ARM_OPC_EOR || cur_head->opc == ARM_OPC_ADD)) || (cur_rule->index == 2185 && cur_head->opc == ARM_OPC_SUB)){
                    goto next;
                }

                // fprintf(stderr, "========starting matching internal, rule: %d=======\n", cur_rule->index);
                if (match_rule_internal(cur_head, cur_rule, tb)) {
                    #if 0
                    if (cur_rule->index == 9998) {
                        static int counter = 0;
                        counter++;  
                        //if (counter > 594) fail
                        //if (counter > 593) pass
                        if (counter > 594)
                            goto next;
                    }
                    #endif
                    if (cur_rule->index == 2405 && /* 471.omnetpp */
                        (tb->pc == 0x409ab910))
                        goto next;
                    #if 0
                    if (cur_rule->index == 9999 && /* 456.hmmer */
                        (tb->pc == 0x29c14 || tb->pc == 0x29b3c || tb->pc == 0x29cd8))
                        break;
                    #endif
                    /* Hack: no time to debug */
                    if ((cur_rule->index == 825 && /* 403.gcc compiled by gcc, TCG Optimization */
                        (tb->pc == 0x212f7c || tb->pc == 0x2143c4 || tb->pc == 0x212f74 ||
                         tb->pc == 0x641f0)) ||
                        (cur_rule->index == 1301 && /* 403.gcc compiled by gcc, TCG Optimization */
                        (tb->pc == 0x22a71c)))
                        goto next;
                    if ((cur_rule->index == 2557 && /* 401.bzip2 compiled by gcc */
                        (tb->pc == 0xc6e8)))
                        goto next;
                    #if 0

                    if ((cur_rule->index == 2404 && /* 483.xalancbmk compiled by gcc */
                        (tb->pc == 0x7bc3c)))
                        goto next;
                    if ((cur_rule->index == 1516 && /* 400.perlbench compiled by gcc */
                        (tb->pc == 0xa90c || tb->pc == 0x630b0 || tb->pc == 0xb84d8 ||
                         tb->pc == 0x62d74 || tb->pc == 0x61dbc || tb->pc == 0xb860c ||
                         tb->pc == 0xb0f2c || tb->pc == 0xaa7fc || tb->pc == 0xaa808 ||
                         tb->pc == 0xabbdc || tb->pc == 0xa490 || tb->pc == 0xb8200 ||
                         tb->pc == 0x342c0 || tb->pc == 0xb5370)))
                        goto next;
                    #endif

                    break;
                }
                next:
                cur_rule = cur_rule->next;
                recover_map_buf_index();
            }
            /* We find a matched rule, save it */
            if (cur_rule) {
                ARMInstruction *temp = cur_head;
                target_ulong target_pc = 0;

                // match_counter -= 1;
                
                // fprintf(stderr, "match a ldr rule: pc: 0x%x ", cur_head->pc);
                // print_arm_instr(cur_head);
                match_insts += i;
                *print_block = 0;

                #ifdef PROFILE_RULE_TRANSLATION
                tb->num_rules_hit++;
                static_inst_rule_counter += i;
                tb->num_insts_match += i;
                cur_rule->hit_num++;
                #endif

                #ifdef DEBUG_RULE_TRANSLATION
                if (cur_rule->index == 0)
                    fprintf(stderr, "    0x%x,\n", tb->pc);
                if (tb->pc == debug_pc)
                    fprintf(stderr, "== Hit a rule [%d] at tb: 0x%x instr: 0x%x, num_insns: %d, update_cc: %s\n", 
                                cur_rule->index, tb->pc, cur_head->pc, i, is_update_cc(cur_head, i) ? "true" : "false");
                #endif
                /* Check target_pc for this rule */
                for (j = 1; j < i; j++)
                    temp = temp->next;
                if (!temp->next && !arm_instr_test_branch(temp))
                    target_pc = temp->pc + 4;

                #ifdef PROFILE_PARAMETER_RULE_TRANSLATION
                    fprintf(stderr, "==============rule index:%d\n", cur_rule->index);
                #endif

                ARMInstruction *p_rule_instr = cur_rule->arm_guest;
                ARMInstruction *p_guest_instr = cur_head;
                int pa_opc[20];
                memset(pa_opc, ARM_OPC_INVALID, sizeof(int)*20);
                j = 0;

                while (p_rule_instr){
                    if ((p_rule_instr->opc >= ARM_OPC_OP1) && (p_rule_instr->opc < ARM_OPC_END)){
                        if (p_rule_instr->opd_num == 0){
                            opd_para = true;
                            break;
                        }
                        pa_opc[j] = p_guest_instr->opc;
                        ++j;
                    }
                    p_rule_instr = p_rule_instr->next;
                    p_guest_instr = p_guest_instr->next;
                }
                if (!opd_para){
                    add_rule_record(cur_rule , cur_head->pc, target_pc, i, 
                        is_update_cc(cur_head, i), is_save_cc(cur_head, i), pa_opc);
                }
                
                break; 
            }
            // para_fault:
            recover_map_buf_index();
        }

        /* We get a matched rule, keep moving forward */
        if (opd_para){
            for (j = 0; j < i; j++) {
                add_matched_para_pc(cur_head->pc);
                cur_head = cur_head->next;
                guest_instr_num--;
            }
        }
        else{
            for (j = 0; j < i; j++) {
                add_matched_pc(cur_head->pc);
                cur_head = cur_head->next;
                guest_instr_num--;
            }
        }

        /* No matched rule found, also keep moving forward */
        if (i == 0) {
            /* print unmatched instructions
               if not continuous, record as a new block */
            // if (cur_head->opc != ARM_OPC_INVALID) {
            //     print_arm_instr(cur_head);
            // }
            cur_head = cur_head->next;
            guest_instr_num--;
        }
    }
}

bool guest_insn_to_revise(TCGContext *s, ARMInstruction *guest_insn, target_ulong pc, ARMRegister new_reg)
{
    ARMInstruction *head = guest_insn;

    while(head) {
        if (head->pc == pc)
            return (head->opc == ARM_OPC_MOV || head->opc == ARM_OPC_SUB ||
                    (head->opc == ARM_OPC_CMP && new_reg < 17) ||
                    head->opc == ARM_OPC_LDR || head->opc == ARM_OPC_STR ||
                    head->opc == ARM_OPC_LDRB || head->opc == ARM_OPC_STRB ||
                    head->opc == ARM_OPC_ADD || head->opc == ARM_OPC_ORR ||
                    head->opc == ARM_OPC_SUBS || head->opc == ARM_OPC_SBC ||
                    head->opc == ARM_OPC_BIC);
        head = head->next;
    }

    return false;
}

void revise_guest_register_operand(ARMInstruction *guest_insn, target_ulong pc,
                                    ARMRegister orig_reg, ARMRegister new_reg,
                                    TCGOpcode tcg_opc, int tcg_opd_idx)
{
    ARMInstruction *head = guest_insn;
    int i, start;

    if (!head)
        return;

    //if (head->pc == 0x172e4 && pc == 0x17300)
    //    return;
#if 0
    if (pc == 0x1aa34)
    fprintf(stderr, "Going to revise reg: %s to reg: %s at guest pc: %x\n",
                get_arm_reg_str(orig_reg), get_arm_reg_str(new_reg), pc);
#endif

    while(head) {
        if (head->pc != pc) {
            head = head->next;
            continue;
        }

        if (pc == 0x1aa34 || pc == 0x1aa38 || pc == 0x1aa3c) {
            head->opc = ARM_OPC_INVALID;
            break;
        }

        //if (head->opc == ARM_OPC_CMP)
        //    fprintf(stderr, "===========tb->pc: %x, pc: %x revise reg: %s to reg %s\n",
        //                guest_insn->pc, head->pc, get_arm_reg_str(orig_reg), get_arm_reg_str(new_reg));
        start = (head->opc == ARM_OPC_CMP || tcg_opc == INDEX_op_qemu_st_i32) ? 0 : 1;
        /* start from 1 to skip dest register, we only revise source register */
        for (i = start; i < head->opd_num; i++) {
            ARMOperand *opd = &head->opd[i];
            if (opd->type == ARM_OPD_TYPE_REG && opd->content.reg.num == orig_reg) {
                opd->content.reg.num = new_reg;
                if (tcg_opc == INDEX_op_qemu_st_i32 && tcg_opd_idx == 0
                    && opd->content.reg.num == new_reg)
                    break;
            } else if (opd->type == ARM_OPD_TYPE_MEM && 
                     opd->content.mem.pre_post == ARM_MEM_INDEX_TYPE_NONE) {
                /* For memory operand with pre/post index, we do not modify the base register.
                   Fortunately, we do not have rules for such instructions */
                ARMMemOperand *mopd = &opd->content.mem;
                if (head->opc == ARM_OPC_LDR || head->opc == ARM_OPC_STR ||
                    head->opc == ARM_OPC_LDRB || head->opc == ARM_OPC_STRB) {
                    if ((tcg_opc == INDEX_op_qemu_ld_i32 || tcg_opc == INDEX_op_qemu_st_i32) &&
                        (mopd->base == new_reg || mopd->index == new_reg)) {
                        /*if (pc == 0x1aa34)
                            fprintf(stderr, "=========base: %s, idx: %s, new_reg: %s\n",
                                        get_arm_reg_str(mopd->base), get_arm_reg_str(mopd->index),
                                        get_arm_reg_str(new_reg));*/
                        mopd->base = new_reg;
                        mopd->index = ARM_REG_INVALID;
                        mopd->scale.type = ARM_OPD_SCALE_TYPE_NONE;
                    } else if (mopd->base == orig_reg)
                        mopd->base = new_reg;
                    else if (mopd->index == orig_reg)
                        mopd->index = new_reg;
                } else {
                    if (mopd->base == orig_reg)
                        mopd->base = new_reg;
                    if (mopd->index == orig_reg)
                        mopd->index = new_reg;
                }
            }
        }
        head = head->next;
    }
}

void swap_guest_operands(ARMInstruction *guest_insn, target_ulong pc,
                         TCGOpcode tcg_opc)
{
    ARMInstruction *head = guest_insn;
    ARMOperand opd;

    while(head) {
        if (head->pc != pc) {
            head = head->next;
            continue;
        }

        switch(tcg_opc) {
            case INDEX_op_add_i32:
            case INDEX_op_or_i32:
                if (head->opc != ARM_OPC_ADD &&
                    head->opc != ARM_OPC_ORR)
                    return;

                opd = head->opd[1];
                head->opd[1] = head->opd[2];
                head->opd[2] = opd;
                return;
            default:
                return;
        }
    }
}

static inline void do_revise(ARMInstruction *pins, TCGOpcode new_tcg_opc, tcg_target_ulong val)
{
    if (new_tcg_opc == INDEX_op_mov_i32 ||
        new_tcg_opc == INDEX_op_movi_i32) {
        pins->opc = ARM_OPC_MOV;
        pins->opd_num = 2;
        if (new_tcg_opc == INDEX_op_movi_i32) {
            pins->opd[1].type = ARM_OPD_TYPE_IMM;
            pins->opd[1].content.imm.type = ARM_IMM_TYPE_VAL;
            pins->opd[1].content.imm.content.val = val;
        }
    }
}

void revise_guest_instruction(ARMInstruction *guest_insn, target_ulong pc,
                              TCGOpcode orig_tcg_opc, TCGOpcode new_tcg_opc,
                              tcg_target_ulong val)
{
    ARMInstruction *head = guest_insn;

    while(head) {
        if (head->pc != pc) {
            head = head->next;
            continue;
        }

        if (head->opc == ARM_OPC_ORRS)
            head->opc = ARM_OPC_INVALID;

        switch(orig_tcg_opc) {
            case INDEX_op_andc_i32:
                if (head->opc != ARM_OPC_BIC)
                    return;
                do_revise(head, new_tcg_opc, val);
                return;
            case INDEX_op_add_i32:
                if (head->opc != ARM_OPC_ADD)
                    return;
                do_revise(head, new_tcg_opc, val);
                return;
            case INDEX_op_sub_i32:
                if (head->opc == ARM_OPC_SUB)
                    do_revise(head, new_tcg_opc, val);
                else if (head->opc == ARM_OPC_SUBS ||
                         head->opc == ARM_OPC_SBC ||
                         head->opc == ARM_OPC_RSC) {
                    if (new_tcg_opc == INDEX_op_movi_i32) {
                        head->opd[1].type = ARM_OPD_TYPE_IMM;
                        head->opd[1].content.imm.type = ARM_IMM_TYPE_VAL;
                        head->opd[1].content.imm.content.val = val;
                        head->opd[2].type = ARM_OPD_TYPE_IMM;
                        head->opd[2].content.imm.type = ARM_IMM_TYPE_VAL;
                        head->opd[2].content.imm.content.val = 0;
                    } else {
                        head->opd[2].type = ARM_OPD_TYPE_IMM;
                        head->opd[2].content.imm.type = ARM_IMM_TYPE_VAL;
                        head->opd[2].content.imm.content.val = 0;
                    }
                }
                return;
            case INDEX_op_shl_i32:
                if (head->opc == ARM_OPC_LDR || head->opc == ARM_OPC_STR) {
                    ARMMemOperand *mopd = &head->opd[1].content.mem;
                    assert(head->opd[1].type == ARM_OPD_TYPE_MEM);
                    mopd->index = ARM_REG_INVALID;
                    mopd->scale.type = ARM_OPD_SCALE_TYPE_NONE;
                    if (mopd->offset.type == ARM_IMM_TYPE_VAL) {
                        mopd->offset.content.val += val;
                    } else {
                        mopd->offset.type = ARM_IMM_TYPE_VAL;
                        mopd->offset.content.val = val;
                    }
                } else if (head->opc == ARM_OPC_ADD){
                    /* revise original register operand to immediate operand */
                    assert(head->opd[1].type == ARM_OPD_TYPE_REG);
                    head->opd[2].type = ARM_OPD_TYPE_IMM;
                    head->opd[2].content.imm.type = ARM_IMM_TYPE_VAL;
                    head->opd[2].content.imm.content.val = val;
                } else if (head->opc == ARM_OPC_MOV) {
                    /* revise original register operand to immediate operand */
                    head->opd[1].type = ARM_OPD_TYPE_IMM;
                    head->opd[1].content.imm.type = ARM_IMM_TYPE_VAL;
                    head->opd[1].content.imm.content.val = val;
                }
                return;
            case INDEX_op_or_i32:
                if (head->opc != ARM_OPC_ORR)
                    return;
                do_revise(head, new_tcg_opc, val);
                return;
            case INDEX_op_and_i32:
                if (head->opc != ARM_OPC_AND && head->opc != ARM_OPC_BIC)
                    return;
                do_revise(head, new_tcg_opc, val);
            default:
                return;
        }
    }
}

void remove_guest_instruction(TranslationBlock *tb, target_ulong pc)
{
    ARMInstruction *head = tb->guest_instr;

    if (!head)
        return;

    if (head->pc == pc) {
        tb->guest_instr = head->next;
        tb->icount--;
        return;
    }

    while(head->next) {
        if (head->next->pc == pc) {
            head->next = head->next->next;
            tb->icount--;
            return;
        }
        head = head->next;        
    }
}

static X86Instruction *x86_host; 
void do_rule_translation(TCGContext *s, TranslationBlock *tb, RuleRecord *rule_r, uint32_t *reg_liveness)
{
    TranslationRule *rule;

    if (!rule_r)
        return;

    rule = rule_r->rule;
    l_map = rule_r->l_map;
    imm_map = rule_r->imm_map;
    g_reg_map = rule_r->g_reg_map;
    int i = 0;

    // fprintf(stderr, "==========Applying rule: %d\n", rule->index);

    reset_asm_buffer();

    X86Instruction *x86_code = rule->x86_host;
    x86_host = x86_code;
    
    //print_x86_instr_seq(x86_code);
    //fprintf(stderr, "-------------------\n");

    /* Assemble host instructions in the rule */
    while(x86_code) {
    #ifdef PROFILE_RULE_TRANSLATION_HOST
	
	if((x86_code->opc!=X86_OPC_PUSH) && (x86_code->opc!=X86_OPC_POP) && 
	(x86_code->opc!=X86_OPC_PC_IR) && (x86_code->opc!=X86_OPC_PC_RR) && (x86_code->opc!=X86_OPC_MULL) &&
	(x86_code->opc!=X86_OPC_SMULL) && (x86_code->opc!=X86_OPC_UMLAL) && (x86_code->opc!=X86_OPC_CLZ))
		tb->num_host_branch_insn += 1;
	else{
		//fprintf(stderr, "%d\n", x86_code->opc);
	}
    #endif 
        if ((x86_code->opc >= X86_OPC_OP1) && (x86_code->opc < X86_OPC_END)){
            X86Opcode temp = x86_code->opc;
            x86_code->opc = ARM2X86[rule_r->para_opc[i]];
            ++i;
            // fprintf(stderr, "%d\n", x86_code->opc);
            assemble_x86_instruction(s, tb, x86_code, reg_liveness, rule_r);
            x86_code->opc = temp;
            // fprintf(stderr, "%d\n", x86_code->opc);
        }
        else
            assemble_x86_instruction(s, tb, x86_code, reg_liveness, rule_r);
        x86_code = x86_code->next;
    }

    if (rule_r->target_pc != 0) {
        //fprintf(stderr, "--------- tb->pc: %x, target_pc: %x\n", tb->pc, rule_r->target_pc);
        assemble_x86_exit_tb(s, rule_r->target_pc);
    }

    /* sync and dead registers to keep consistency with TCG */
    sync_dead_register(s, reg_liveness);
}

bool is_last_access(X86Instruction *insn, X86Register reg)
{
    X86Instruction *head = x86_host;
    int i;

    while(head && head != insn)
        head = head->next;
    if (!head)
        return true;

    head = head->next;

    while(head) {
        for (i = 0; i < head->opd_num; i++) {
            X86Operand *opd = &head->opd[i];

            if (opd->type == X86_OPD_TYPE_REG) {
                if (opd->content.reg.num == reg)
                    return false;
            } else if (opd->type == X86_OPD_TYPE_MEM) {
                if (opd->content.mem.base == reg)
                    return false;
                if (opd->content.mem.index == reg)
                    return false;
            }
        }
        head = head->next;
    }

    return true;
}
