#!/usr/bin/python

import re
import os
import sys
import copy
import inspect
import time
from itertools import permutations, repeat

DISABLE_SSE_LEARN = True

cmd_subfolder = os.path.realpath(\
                    os.path.abspath(\
                        os.path.join(\
                            os.path.split(inspect.getfile( inspect.currentframe() ))[0], "arm")))

if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

cmd_subfolder = os.path.realpath(\
                    os.path.abspath(\
                        os.path.join(\
                            os.path.split(inspect.getfile( inspect.currentframe() ))[0], "x86")))

if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

cmd_subfolder = os.path.realpath(\
                    os.path.abspath(\
                        os.path.join(\
                            os.path.split(inspect.getfile( inspect.currentframe() ))[0], "y86")))

if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

# Define guest and host ISA
if DISABLE_SSE_LEARN:
    import arm as guest
else:
    import y86 as guest
import x86 as host
#CFLAGS = '-g -DSPEC_CPU -DSPEC_CPU_LINUX -DSPEC_CPU_LP64  -DNDEBUG -I. -Iomnet_include -Ilibs/envir'
CFLAGS = "-g -DSPEC_CPU -std=c++11  -DNDEBUG -DPERL_CORE -DSPEC_CPU_LINUX -I/usr/arm-linux-gnueabi/include -std=gnu89"
OPT = "-O2"
OPT_guest="-O2"
OPT_host="-O2"

INDEX_guest = 0
INDEX_host = 1
INDEX_glive_out = 2

VINE_TOOL = "$HOME/dbt/pattern-dbt/vine-compare2/exec_utils/insn_compare" 
STP_SOLVER = "$HOME/dbt/pattern-dbt/vine-compare2/stp/stp"

DEBUG_ENABLE = 1
PROFILE_ENABLE = 0

LINE_MODE = True
LINE_MODE = False
FILE_WANTED = "macroblock.c"
LINE_WANTED = "6342"#"4837""4787""4582"#"1470"
#"3944"#"5070"#"2039"#"1551"#"1470"#"2514"#"1037"#"2595"#"950"#"942"#"966"#"933"#"1058"#"995"#"852"#"1097"#"1087"#"2363"#"1111"#"987"
#"2393"#"1222"#"2119"#"1216"#"1102"#"2221"#"1794"#"1496"#"2667"#"1029"#"987"#"1033"#"1091"#"984"#"991"#"2616"#"3191"#"2374"#"3189"#"1561"
#"1801"#"1812"#"2047"#"1124"#"1128" #"1174"#"989"#"984"#"2075"#"2061"#"2070"#"2068" #"1664" # only checked when LINE_MODE is True

SUCCESS = 0
ERR_DIFF_VAR_NUM = 1
ERR_DIFF_VAR_NAME = 2
ERR_INITIAL_MAPPING = 3
ERR_FAILED_VERIFICATION = 4
ERR_FAILED_VERIFICATION_MEM_ADDR = 5
ERR_FAILED_VERIFICATION_MEM_CONT = 6
ERR_FAILED_VERIFICATION_BRANCH_COND = 7
ERR_FAILED_VERIFICATION_REG_DIFF = 8
ERR_FAILED_GENERALIZATION = 9

# We might try multiple times to verified the candidate.
# This variable records last failed verification reason.
# 0: failure is not caused by verification
# 1: memory address
# 2: memory content
# 3: branch
# 4: register
last_failed_verification = 0

total_line = 0
guest_call_line = 0
guest_multi_branch = 0
guest_pre_post = 0
guest_null_line = 0
guest_cond_exec = 0
host_call_line = 0
host_multi_branch = 0
host_null_line = 0
host_sse_instruction = 0
rule_candidate = 0
rule_learned = 0
rule_give_up_diff_var_num = 0
rule_give_up_diff_var_name = 0
rule_give_up_initial_mapping = 0
rule_give_up_failed_verification = 0
rule_give_up_failed_generalization = 0
failed_verification_no_result = 0
failed_verification_crash = 0
failed_verification_mem_addr_diff = 0
failed_verification_mem_cont_diff = 0
failed_verification_branch_cond = 0
failed_verification_reg_diff = 0

generation_time = 0
verification_time = 0

class InputFile:
    def __init__(self):
        self.src_file_dir =  ""
        self.src_file_name = ""
        self.learned_src_line = []  # source lines we have learned in this src file, only line number
        self.guest_asm        = []  # guest assembly read from file, a list of lines
        self.guest_asm_dump   = []  # guest dumped asm file from obj
        self.guest_ir         = []  # guest LLVM IR read from file
        self.host_asm         = []  # host assembly read from file
        self.host_asm_dump    = []  # host dumped asm file from obj
        self.host_ir          = []  # host LLVM IR read from file
    def set_src_file(self, dir_n, cfile):
        def read_file(file_name):
            tfile = open(file_name, 'r')
            tfile_cont = tfile.readlines()
            tfile.close()
            return tfile_cont
        self.src_file_dir = dir_n
        self.src_file_name = cfile
        self.guest_asm         = read_file(guest.ASM)
        self.guest_asm_dump    = read_file(guest.ASM_D)
        self.guest_ir          = read_file(guest.IR)
        self.host_asm          = read_file(host.ASM)
        self.host_asm_dump     = read_file(host.ASM_D)
        self.host_ir           = read_file(host.IR)
        self.learned_src_line = []
    def get_src_file_name(self):
        return self.src_file_name
    def get_src_file_name_with_dir(self):
        return self.src_file_dir + self.src_file_name
    def get_src_file_line(self, nline):
        with open(self.get_src_file_name_with_dir()) as src_fp:
            for i, line in enumerate(src_fp):
                if i == nline - 1:
                    return line # the opened file will be closed automatically

class FuncInfo:
    def __init__(self, ifile):
        self.ifile = ifile
        self.reset()
    def reset(self):
        self.name = ""
        self.guest_asm =      []  # only used to check if the instruction is Spill or Reload
        self.guest_inst =     []  # extract from guest_asm_dump, a list of instruction (unparsed)
        self.guest_binary =   []  # extract from guest_asm_dump, binary of each instruction
        self.guest_ir =       []
        self.host_asm =       []  # only used to check if the instruction is Spill or Reload
        self.host_inst =      []  # extract from host_asm_dump, a list of instructions (unparsed)
        self.host_binary =    []  # extract from host_asm_dump, binary of each instruction
        self.host_ir =        []

    # Extract assembly code for the function
    def extract_func_asm(self, asm_list):
        func_start_str = '\t' + self.name + ','
        func_start_flag = False
        rlist = []
        for i in range(0, len(asm_list)):
            line = asm_list[i]
            if "type" in line and func_start_str in line and "function" in line:
                func_start_flag = True
                continue
            if func_start_flag:
                if "MCInst" in line and not "ud2" in line:
                    # check if there is instruction in this line
                    nline = line.lstrip() # remove spaces from the beginning of the line
                    if nline[0] == '@' or nline[0] == '#':
                        rlist.append(asm_list[i-1])
                    else:
                        rlist.append(line)
                if ".fnend" in line or "func_end" in line:
                    break
        return rlist

    def extract_func_inst_binary(self, asm_d_list):
        func_start_flag = False
        ilist = []
        blist = []
        for i in range(0, len(asm_d_list)):
            line = asm_d_list[i]
            func_name_str = "<" + self.name + ">:"
            if func_name_str in line:
                func_start_flag = True
                continue
            if func_start_flag:
                if ":\t" in line and not ".word" in line and not "ud2" in line:
                    first_tab = line.find('\t')
                    second_tab = line.find('\t', first_tab+1)
                    binary = line[first_tab+1:second_tab].rstrip()
                    blist.append(binary)
                    semicolon = line.find(';')
                    if semicolon != -1:
                        inst = line[second_tab+1:semicolon]
                    else:
                        inst = line[second_tab+1:]
                    left_angle_bracket = inst.find('<')
                    if left_angle_bracket != -1:
                        inst = inst[:left_angle_bracket-1]
                    inst = inst.rstrip()
                    ilist.append(inst)
                if line == "\n":
                    if "<." in asm_d_list[i+1] and ">:" in asm_d_list[i+1]:
                        i += 2 # this is a label, just jump over it
                    else:
                        break
        return ilist, blist

    # Extract LLVM MC IR for the function
    def extract_func_ir(self, ir_list):
        func_start_flag = False
        rlist = []
        func_name_str = "Machine code for function %s:" % self.name
        last_block_successor_line = ""
        for i in range(0, len(ir_list)):
            line = ir_list[i]
            if line == '\n':
                continue
            if "IR Dump After Live DEBUG_VALUE" in line and \
               func_name_str in ir_list[i+1]:
                func_start_flag = True
                continue
            if func_start_flag:
                if func_name_str in line or "Frame Objects:" in line or \
                   ("fi#" in line and ("at location" in line or "dead" in line or "align" in line)) or \
                   "Constant Pool:" in line or ("cp#" in line and "align=" in line) or \
                   "Function Live Ins" in line or "Live Ins:" in line or \
                   "Predecessors according to" in line or "CFI_INSTRUCTION" in line or \
                   "CONSTPOOL_ENTRY" in line or "DBG_VALUE" in line or \
                   "Jump Table" in line or "JUMPTABLE_ADDRS" in line or \
                   "ADJCALLSTACKDOWN" in line or "Successors according to" in line or \
                   "TRAP" in line or "IMPLICIT_DEF" in line or "__FUNCTION__.aligned_operand" in line or \
                   "EH_LABEL" in line or "KILL" in line:
                    continue
                elif "BB#" in line and not "<BB#" in line:
                    continue
                elif "# End machine code" in line:
                    break
                if "BX_CALL" in line:
                    rlist.append("SAVE PC to LR (artification IR)")
                rlist.append(line)
                if " MOVPC32r " in line:
                    rlist.append("POP32r") # insert an artificial IR, never be used
        return rlist

    # Extract guest asm, guest ir, host asm, and host ir for the function
    def extract_func(self, func_name):
        def do_extraction(asm, asm_dump, ir):
            r_asm = self.extract_func_asm(asm)
            r_inst, r_binary = self.extract_func_inst_binary(asm_dump)
            r_ir = self.extract_func_ir(ir)
            return r_asm, r_inst, r_binary, r_ir
        def do_check(asm, inst, binary, ir):
            inst_len = len(inst)
            binary_len = len(binary)
            asm_len = len(asm)
            if inst_len != asm_len or binary_len != asm_len:
                if DEBUG_ENABLE:
                    print "Warning: Inst (%d) and Binary (%d) are not matched with ASM (%d) for func: %s" % \
                        (inst_len, binary_len, asm_len, func_name)
            ir_len = len(ir)
            if asm_len == ir_len:
                return

            if asm_len < ir_len:
                min = asm_len
            else:
                min = ir_len
            for i in range(0, min):
                print "%d%s" % (i+1, asm[i]),
                print "%d%s" % (i+1, ir[i]),
                print ""
            print "ASM (%d) and IR (%d) are not match for func: %s" % \
                (asm_len, ir_len, func_name)
            sys.exit(0)

        self.name = func_name

        self.guest_asm, self.guest_inst, self.guest_binary, self.guest_ir = \
            do_extraction(self.ifile.guest_asm, self.ifile.guest_asm_dump, self.ifile.guest_ir)
        self.host_asm, self.host_inst, self.host_binary, self.host_ir = \
            do_extraction(self.ifile.host_asm, self.ifile.host_asm_dump, self.ifile.host_ir)

        do_check(self.guest_asm, self.guest_inst, self.guest_binary, self.guest_ir)
        do_check(self.host_asm, self.host_inst, self.host_binary, self.host_ir)

# Memory location from guest and host are normalized to the following structure:
#   base + idx * scale + off
# Here, base and idx can be live-in registers (live-in access) or a memory variable,
# scale and off are immediate symbols
class NormalizedMemoryLocation:
    def __init__(self):
        self.base = ""
        self.idx = ""
        self.scale = ""
        self.off = ""

# Each translation rule is constructed of three parts:
# 1. Guest instructions
# 2. Host instructions
# 3. Context informations (i.e., which registers are not maintained by host instructions)
# 4. Comment contains file name, function name and line number
class TranslationRule:
    def __init__(self, gp, hp, cp, cc, ct):
        self.guest = gp
        self.host = hp
        self.context = cp
        self.cc_mapping = cc
        self.comment = ct

class LearnProcess:
    def __init__(self, ifunc):
        self.rule_counter       = 0     # number of rules we have learned, including failed
        self.memory_counter     = 0     # number of rules that have memory access

        self.ifunc              = ifunc # source function we are learning
        self.translation_rules  = []    # Learned translation rules
        self.candidate_rules    = []    #sch: candidate rules
        self.reset()

    def reset(self):
        self.src_line_no        = ""    # source line number to learn

        self.guest_inst_raw     = []    # a list raw guest instructions (unparsed)
        self.guest_binary       = []    # a list of guest binary code
        self.guest_ir           = []    # raw line of guest ir, read from file
        self.guest_var          = []    # guest memory variables

        self.host_inst_raw      = []    # a list of raw host instructions (unparsed)
        self.host_binary        = []    # a list of host binary code
        self.host_ir            = []    # raw line of hostir, read from file
        self.host_var           = []    # host memory variables

        self.guest_inst_parsed  = []    # guest asm inst after parsing
        self.host_inst_parsed   = []    # host asm inst after parsing

        self.guest_live_in_reg  = []    # guest live in register, not including address calculation registers
        self.guest_def_reg      = []    # guest registers defined in the code
        self.guest_use_reg      = []    # guest registers used in the code
        self.host_live_in_reg   = []    # host live in register, not including address calculation registers
        self.host_def_reg       = []    # host registers defined in the code
        self.host_use_reg       = []    # host registers used in the code

        self.cc_mapping         = []    # condition code mapping from guest to host
  
        self.guest_rule_inst    = []    # guest inst part in a rule (after generalization)
        self.host_rule_inst     = []    # host inst part in a rule (after generalization)
        self.context            = []    # context part

    # Prepare for learning in next step, return True is successful
    def learn_prepare(self, src_line_no):
        def extract_inst_binary_ir(asm, inst, binary, ir, src_file_name, src_line_no):
            r_inst = []
            r_binary = []
            r_ir = []
            t_asm = [] # temporary list
            src_line_str = "dbg:%s:%s:" % (src_file_name, src_line_no)
            last_idx = -1
            have_cmp = False
            hack_success = False
            for i in range(0, len(ir)):
                asm_line = asm[i]
                ir_line = ir[i]
                if src_line_str in ir_line and not "[ConstantPool]" in ir_line and \
                   not "[GOT]" in ir_line and not "-byte Spill" in asm_line and \
                   not "-byte Reload" in asm_line:
                    r_inst.append(inst[i])
                    r_binary.append(binary[i])
                    r_ir.append(ir_line)
                    t_asm.append(asm_line)
                    last_idx = i
                    if "CMP" in asm_line or "CMN" in asm_line or "TST" in asm_line or "TEQ" in asm_line or \
                       "cmp" in asm_line or "TEST" in asm_line or "test" in asm_line:
                        have_cmp = True
            if have_cmp:
                asm_line = asm[last_idx]
                # Hack: if there is a cmp and last IR is not condition branch, try to append the following bxx/jxx IR
                if not "Bcc" in asm_line and not " J" in asm_line:
                    for j in range(last_idx+1, len(asm)):
                        if " J" in asm[j] or "Bcc" in asm[j]:
                            r_inst.append(inst[j])
                            r_binary.append(binary[j])
                            r_ir.append(ir[j])
                            t_asm.append(asm[j])
                            hack_success = True
                            break
                    if not hack_success:
                        return [], [], []
            elif last_idx != -1:
                asm_line = asm[last_idx]
                # Hack: if the last IR is conditional branch, try to add the previous cmp IR
                if "Bcc" in asm_line or " J" in asm_line:
                    for j in range(last_idx - 1, 0, -1):
                        asm_line = asm[j]
                        if "CMP" in asm_line or "CMN" in asm_line or "TST" in asm_line or "TEQ" in asm_line or \
                           "cmp" in asm_line or "TEST" in asm_line or "test" in asm_line:
                            r_inst.insert(len(r_inst) - 1, inst[j])
                            r_binary.insert(len(r_binary) - 1, binary[j])
                            r_ir.insert(len(r_ir) - 1, ir[j])
                            hack_success = True
                            break
                    if not hack_success:
                        return [], [], []
            # Hack: if there are multiple cmp, only keep the last one.
            # Actually, we can potentially learn a rule for each cmp with its corresponding branch instruction.
            # However, we only learn the last one currently for simplicity.
            have_cmp = False
            for i, asm_line in reversed(list(enumerate(t_asm))):
                if "CMP" in asm_line or "CMN" in asm_line or "TST" in asm_line or \
                   "TEQ" in asm_line or "subs" in asm_line or "adds" in asm_line or \
                   "cmp" in asm_line or "TEST" in asm_line or "test" in asm_line or \
                   "DEC" in asm_line:
                    if not have_cmp:
                        have_cmp = True
                    else:
                        r_inst[0:(i+1)] = []
                        r_binary[0:(i+1)] = []
                        r_ir[0:(i+1)] = []
                        break
            return r_inst, r_binary, r_ir
        def have_function_call(inst):
            for i in inst:
                if "bl\t" in i or "bx\t" in i or "call" in i or "ret" in i:
                #if "\tBL " in i or "\tBL_pred " in i or "\tBX " in i or "\tBX_RET " in i or \
                #   "\tBX_CALL " in i or \
                #   "\tCALL32r " in i or "\tCALLpcrel32 " in i or "\tRETL " in i:
                #   " MOVPC32r " in i or " PICLDR " in i or "\tRETL " in i:
                    return True
            return False
        def have_multiple_branch(ir):
            have_one = False
            for i in ir:
                if "\tBcc " in i or "\tB " in i or \
                   "\tJ" in i:
                    if have_one:
                        return True
                    else:
                        have_one = True
            return False
        def have_sse_instruction(ir):
            for i in ir:
                if "%XMM" in i:
                    return True
            return False

        global total_line
        total_line = total_line + 1

        self.src_line_no = src_line_no

        # 1.1 extract guest inst, binary and ir for this source line
        self.guest_inst_raw, self.guest_binary, self.guest_ir = \
            extract_inst_binary_ir(self.ifunc.guest_asm, self.ifunc.guest_inst, \
                                   self.ifunc.guest_binary, self.ifunc.guest_ir, \
                                   self.ifunc.ifile.get_src_file_name_with_dir(), self.src_line_no)

        # 1.2 check if guest code is null
        if len(self.guest_inst_raw) == 0:
            global guest_null_line
            guest_null_line = guest_null_line + 1
            return False

        # 1.3 check if there is function call instruction, currently not supported
        if have_function_call(self.guest_inst_raw):
            #print "\n*************"
            #for inst in self.guest_inst_raw:
            #    print inst
            #print "**************\n"
            global guest_call_line
            guest_call_line = guest_call_line + 1
            return False

        # 1.4 check if guest code has multiple branches, currently not supported
        global DISABLE_SSE_LEARN
        if DISABLE_SSE_LEARN and have_multiple_branch(self.guest_ir):
            if DEBUG_ENABLE:
                print "\n**************"
                for inst in self.guest_inst_raw:
                    print inst
                print "***************\n"
            # Multiple branches, currently not support
            global guest_multi_branch
            guest_multi_branch = guest_multi_branch + 1
            return False

        # 1.5 check if there is pre/post index load/store
        for ir in self.guest_ir:
            # Has pre/post index, makes no sense to generate rule,
            #   because host(x86) usually doesn't maitain 
            #   the live-out register for address calculation
            if ("LD" in ir or "ST" in ir) and ("PRE" in ir or "POST" in ir):
                global guest_pre_post
                guest_pre_post = guest_pre_post + 1
                return False

        # 1.6 check if there is instruction with conditional execution, currently not supported
        for ir in self.guest_ir:
            if "pred:%CPSR" in ir and not "\tBcc " in ir:
                global guest_cond_exec
                guest_cond_exec = guest_cond_exec + 1
                return False

        # 2.1 extract host inst, binary and ir for this source line
        self.host_inst_raw, self.host_binary, self.host_ir = \
            extract_inst_binary_ir(self.ifunc.host_asm, self.ifunc.host_inst, \
                                   self.ifunc.host_binary, self.ifunc.host_ir, \
                                   self.ifunc.ifile.get_src_file_name_with_dir(), self.src_line_no)

        # 2.2 check if host code is null
        if len(self.host_inst_raw) == 0:
            global host_null_line
            host_null_line = host_null_line + 1
            return False

        # 2.3 check if there is function call instruction, currently not supported
        if have_function_call(self.host_inst_raw):
            global host_call_line
            host_call_line = host_call_line + 1
            return False

        # 2.4 check if host code has multiple branches, currently not supported
        if DISABLE_SSE_LEARN and have_multiple_branch(self.host_ir):
            global host_multi_branch
            host_multi_branch = host_multi_branch + 1
            return False

        # 2.5 check if host code has sse instructions, currently not supported
        if DISABLE_SSE_LEARN and have_sse_instruction(self.host_ir):
            global host_sse_instruction
            host_sse_instruction = host_sse_instruction + 1
            return False

        return True

    # Parse guest and host instructions
    def parse_inst_list(self, asm, binary, ir, arch):
        return arch.parse_inst_list(asm, binary, ir)

    # Analyze live-in and live-out registers
    def analyze_register_liveness(self, asm_inst, arch):
        return arch.analyze_register_liveness(asm_inst)

    # Assemble asm code
    def assemble_code(self, code, as_cmd, objdump_cmd):
        asm_file = "./.tmp_s"
        obj_file = "./.tmp_o"
        dump_file = "./.tmp_d"

        # Generate asm file for as
        asm_f = open(asm_file, "w")
        for i in range(0, len(code)):
            asm_f.write(code[i])
        asm_f.close()

        # Assmble asm code using as
        cmd = "%s %s -o %s" % (as_cmd, asm_file, obj_file)
        os.system(cmd)
        if not os.path.isfile(obj_file):
            return ""

        # Dump object file using objdump
        cmd = "%s -d %s > %s" % (objdump_cmd, obj_file, dump_file)
        os.system(cmd)
        if not os.path.isfile(dump_file):
            return ""

        # Read dump file to get hex binary
        hex_str = ""
        text_start = False
        with open(dump_file, "r") as dump_f:
            for line in dump_f:
                # this line is an instruction, parse it
                if text_start:
                    binary = re.search(":\t([0-9a-fA-F' ']+) ", line)
                    if binary:
                        hex_str = hex_str + " " + binary.group(1).rstrip()
                    continue

                # start of text
                if '<.text>' in line:
                    text_start = True
        dump_f.close()

        # Cleanup
        os.remove(asm_file)
        os.remove(obj_file)
        os.remove(dump_file)

        return hex_str.lstrip()

    def guess_initial_mapping(self, mem_mapping):
        initial_mapping = []
        imm_para = []
        for g_var_name, (g_mem_opd, g_pc_list) in self.guest_var.iteritems():
            for h_var_name, (h_mem_opd, h_pc_list) in self.host_var.iteritems():
                if not mem_mapping.has_key((g_var_name, h_var_name)):
                    continue

                g_norm_mem = NormalizedMemoryLocation()
                h_norm_mem = NormalizedMemoryLocation()

                guest.normalize_memory_location(self.guest_rule_inst, \
                        g_mem_opd, g_norm_mem, imm_para)
                host.normalize_memory_location(self.host_rule_inst, \
                        h_mem_opd, h_norm_mem, imm_para)

                if DEBUG_ENABLE:
                    print "after normalization:"
                    print "==== [Guest] base: %s, idx: %s, scale: %s, off: %s" %\
                            (g_norm_mem.base, g_norm_mem.idx,
                             g_norm_mem.scale, g_norm_mem.off)
                    print "==== [Host] base: %s, idx: %s, scale: %s, off: %s" %\
                            (h_norm_mem.base, h_norm_mem.idx,
                             h_norm_mem.scale, h_norm_mem.off)

                # Try to guess a mapping based on normalized locations

                # 1. base registers, just map them. Will support memory variable type in the future
                if "mem" in g_norm_mem.base and "mem" in h_norm_mem.base:
                    if not mem_mapping.has_key((g_norm_mem.base[4:], h_norm_mem.base[4:])):
                        if DEBUG_ENABLE:
                            print "[Guess initial mapping] some thing wrong."
                elif (g_norm_mem.base == "" and h_norm_mem.base != "") or \
                     (g_norm_mem.base != "" and h_norm_mem.base == ""):
                    return False, [], []
                elif (g_norm_mem.base != "" and h_norm_mem.base != ""):
                    if "mem" in g_norm_mem.base or "mem" in h_norm_mem.base or \
                       (g_norm_mem.base[0] == 'r' and h_norm_mem.base[0] != 'e') or \
                       (g_norm_mem.base[0] != 'r' and h_norm_mem.base[0] == 'e'):
                        return False, [], []
                    elif g_norm_mem.base[0] != 'r' or h_norm_mem.base[0] != 'e':
                        def analyze_expr(g, h, im):
                            def split_two_parts(s): # split the expression to two parts
                                left_paren_counter = 0
                                if s[-1] != ')':
                                    return ["", ""]
                                for i in range(0, len(s)):
                                    if s[i] == '(':
                                        left_paren_counter += 1
                                    elif s[i] == ')':
                                        left_paren_counter -= 1
                                    elif s[i] == ',' and left_paren_counter == 1:
                                        return [s[4:i], s[i+1:s.rfind(')')]]
                            def do_check(gstr, hstr, im):
                                if (gstr[0] == 'r' and hstr[0] == 'e') or \
                                   (gstr[0] == 'i' and hstr[0] == 'i'):
                                    if not [gstr, hstr] in im:
                                        im.append([gstr, hstr])
                                else:
                                    analyze_expr(gstr, hstr, im)
                            gop = g[0:3]
                            hop = h[0:3]
                            gparts = split_two_parts(g)
                            hparts = split_two_parts(h)
                            for i in range(0, 2):
                                if gparts[i] == "" or hparts[i] == "":
                                    return
                            if gop == hop:
                                for i in range(0, 2):
                                    do_check(gparts[i], hparts[i], im)
                            elif gop == "LSH" and hop == "MUL": # only allowed for imm
                                assert(gparts[1][0] == 'i' and hparts[1][0] == 'i')
                                im.append(["\'(1<<"+gparts[1]+")\'", hparts[1]])
                                do_check(gparts[0], hparts[0], im)
                        analyze_expr(g_norm_mem.base, h_norm_mem.base, initial_mapping)
                    elif not [g_norm_mem.base, h_norm_mem.base] in initial_mapping:
                        initial_mapping.append([g_norm_mem.base, h_norm_mem.base])

                # 2. index: registers/memory variables
                if g_norm_mem.idx != "": # guest has index
                    if h_norm_mem.idx != "": # host also has index
                        #check if they are from the same variable. If yes, nothing to do
                        if "mem-" in g_norm_mem.idx:
                            if h_norm_mem.idx != g_norm_mem.idx:
                                if DEBUG_ENABLE:
                                    print "[Guess Initial Mapping] Error: cannot map index in different types"
                                return False, [], []
                        elif "LSH" in h_norm_mem.idx:
                            initial_mapping.append([g_norm_mem.idx, "\'"+h_norm_mem.idx+"\'"])
                    else: # host doesn't have index
                        if DEBUG_ENABLE:
                            print "[Guess Initial Mapping] Error: cannot map index because host doesn't have"
                        return False, [], []
                else: # guest doesn't have index
                    if h_norm_mem.idx != "" and h_norm_mem.idx[0] == 'e': # host has index, map it to zero
                        initial_mapping.append(["0", h_norm_mem.idx])

                # 3. scale               
                if g_norm_mem.scale != "": # guest has scale
                    if h_norm_mem.scale != "": # host has scale too
                        initial_mapping.append([g_norm_mem.scale, h_norm_mem.scale])
                    elif DEBUG_ENABLE:
                        print "[Guess Initial Mapping] Error: cannot map scale because host doesn't have"
                else: # guest doesn't have scale
                    if h_norm_mem.scale != "": # host has scale, map it to one
                        initial_mapping.append(["1", h_norm_mem.scale])
                g_mem_opd.scale.para_flag = True
                h_mem_opd.scale_para_flag = True

                # 4. offset
                if g_norm_mem.off != "": # guest has offset
                    if h_norm_mem.off != "":
                        initial_mapping.append([g_norm_mem.off, h_norm_mem.off])
                    else:
                        if DEBUG_ENABLE:
                            print "[Guess Initial Mapping] Error: cannot map offset because host doesn't have"
                        return False, [], []
                else: # guest doesn't have offset
                    if h_norm_mem.off != "": # host has offset, map it to zero
                        initial_mapping.append(["0", h_norm_mem.off])

        if DEBUG_ENABLE:
            for map_list in initial_mapping:
                str = "-init-map "
                for item in map_list[:-1]:
                    str += "%s=" % item
                str += map_list[-1]
                print str

            for ip in imm_para:
                str = "-imm-para %s=" % ip[0].pc
                for item in ip[1:-1]:
                    str += "%s=" % item
                str += ip[-1]
                print str

        return True, initial_mapping, imm_para

    # Establish memory mapping between guest and host using var name from LLVM IR
    def decide_memory_mapping(self):
        def build_guest_var_addr(g_mem_opd, g_pc_list):
            g_var_addr = g_mem_opd.asm_str
            if g_mem_opd.scale.typ != "":
                if g_mem_opd.scale.typ == "reg":
                    if DEBUG_ENABLE:
                        print "Error: unsupported guest scale type with register"
                g_var_addr += "," + g_mem_opd.scale.val_para
            if g_mem_opd.off != "":
                g_var_addr += "," + g_mem_opd.off_para
            for pc in g_pc_list:
                g_var_addr += "," + pc
            return g_var_addr
        def build_host_var_addr(h_mem_opd, h_pc_list):
            h_var_addr = h_mem_opd.asm_str
            if h_var_addr.index('(') != 0:
                offset = hex(int(h_var_addr[0:h_var_addr.index('(')], 0))
                remain = h_var_addr[h_var_addr.index('('):h_var_addr.index(')')+1]
                h_var_addr = offset+remain
            if h_mem_opd.disp != "":
                h_var_addr += "," + h_mem_opd.disp_para
            if h_mem_opd.scale != "" and ',' in h_mem_opd.asm_str:
                h_var_addr += "," + h_mem_opd.scale_para
            for pc in h_pc_list:
                h_var_addr += "," + pc
            return h_var_addr
        def host_has_mapping(h_mem_opd_mapped, h_mem_opd):
            for h_mem in h_mem_opd_mapped:
                if h_mem == h_mem_opd:
                    return True
            return False
        mem_mapping = {} # each element is: ((guest_var_name, host_var_name), (guest_addr, host_addr))
        h_mem_opd_mapped = []
        for g_var_name, (g_mem_opd, g_pc_list) in self.guest_var.iteritems():
            g_var_addr = build_guest_var_addr(g_mem_opd, g_pc_list)

            found = False
            for h_var_name, (h_mem_opd, h_pc_list) in self.host_var.iteritems():
                if h_var_name != g_var_name:
                    continue

                found = True
                h_var_addr = build_host_var_addr(h_mem_opd, h_pc_list)
                mem_mapping[(g_var_name, h_var_name)] = (g_var_addr, h_var_addr)
                h_mem_opd_mapped.append(h_mem_opd)
                break

            # If we cannot find a host memory location with the same name as the guest one, 
            #   try to find a host memory location with the same row and column source line 
            if not found:
                for h_var_name, (h_mem_opd, h_pc_list) in self.host_var.iteritems():
                    if h_mem_opd.row_column != g_mem_opd.row_column:
                        continue
                    if host_has_mapping(h_mem_opd_mapped, h_mem_opd):
                        continue
                    '''if ("sunkaddr" in g_var_name and not "sunkaddr" in h_var_name) or \
                       (not "sunkaddr" in g_var_name and "sunkaddr" in h_var_name):
                        continue'''

                    h_var_addr = build_host_var_addr(h_mem_opd, h_pc_list)
                    mem_mapping[(g_var_name, h_var_name)] = (g_var_addr, h_var_addr)
                    h_mem_opd_mapped.append(h_mem_opd)
                    break

            if not mem_mapping.has_key((g_var_name, h_var_name)):
                return False, mem_mapping
        return True, mem_mapping


    def get_def_reg_str(self, def_reg, head):
        if len(def_reg) == 0:
            return ""
        out_reg_str = "%s \'" % head
        is_first = True
        for reg in def_reg:
            if is_first:
                out_reg_str += "%s" %reg.lower()
                is_first = False
            else:
                out_reg_str += ", %s" % reg.lower()
        out_reg_str += "\'"
        return out_reg_str

    # Get unmapped live in registers
    def get_unmapped_live_in_reg(self, live_in_reg, init_map):
        unmapped_reg = []
        for reg in live_in_reg:
            flag = False
            for mapping in init_map:
                for mreg in mapping:
                    if reg == mreg:
                        flag = True
                        break
                if flag:
                    break
            if not flag:
                unmapped_reg.append(reg)
        return unmapped_reg

    # Adjust vars to point to new copied memory operands
    #  This function should be called after we copy the parsed instructions
    def adjust_var_list(self, var_list, inst_list):
        def get_mem_opd(pc):
            for inst in inst_list:
                if inst.pc != pc:
                    continue
                for opd in inst.opd_list:
                    if opd.typ == "mem":
                        return opd.opd
            print "[Error] cannot find memory operand for this pc: %s" % pc
                
        for varname in var_list:
            (m_opd, pc_list) = var_list[varname]
            var_list[varname] = (get_mem_opd(pc_list[0]), pc_list)

    # Verification and generalization
    #  retrun value indicates if it is necessary to try another mapping
    #  0 -> not necessary, 1 -> necessary, 2 -> successful verification
    def do_verification(self, guest_binary_str, host_binary_str, solver_str, tried_mapping):
        global last_failed_verification
        # 1 Prepare parameters for verification tool
        # 1.1 Prepare memory mapping
        success, mem_mapping = self.decide_memory_mapping()
        if not success:
            global rule_give_up_diff_var_name
            rule_give_up_diff_var_name = rule_give_up_diff_var_name + 1
            if DEBUG_ENABLE:
                print "\nCannot setup memory mapping because different var names"
                print "**** Give up this rule candidate ****"
            return 0, ERR_DIFF_VAR_NAME
        mem_mapping_str = ""
        for name in mem_mapping:
            (g_addr, h_addr) = mem_mapping[name]
            mem_mapping_str += " -mem-map \'%s\'=\'%s\'" % (g_addr, h_addr)

        # 1.2 Prepare live in mapping (registers and immediates)
        initial_mapping = []  # each element is a list of registers/immediates that should be initialized with 
                              # the same symbolic value
        imm_para = []  # each element is a list of instruction, the constant and the immediate symbol
        if (len(self.guest_live_in_reg) == 0 and len(self.host_live_in_reg) >  0) or \
           (len(self.guest_live_in_reg) >  0 and len(self.host_live_in_reg) == 0):
            global rule_give_up_initial_mapping
            rule_give_up_initial_mapping = rule_give_up_initial_mapping + 1
            if DEBUG_ENABLE:
                print "\nCannot setup live-in registers because of different numbers:"
                print "\tguest: %d, host: %d" % (len(self.guest_live_in_reg), len(self.host_live_in_reg))
                print "**** Give up this rule candidate ****"
            return 0, ERR_DIFF_VAR_NUM
        else: # more than one register, try to guess a mapping based on memory address
            (success, initial_mapping, imm_para) = self.guess_initial_mapping(mem_mapping)
            if not success:
                rule_give_up_initial_mapping = rule_give_up_initial_mapping + 1
                if DEBUG_ENABLE:
                    print "\nCannot setup initial mapping for guest/host register"
                    print "**** Give up this rule candidate ****"
                return 0, ERR_INITIAL_MAPPING
            # try to guess initial mapping for unmapped registers after above guessing
            guest_unmapped_reg = self.get_unmapped_live_in_reg(self.guest_live_in_reg, initial_mapping)
            host_unmapped_reg = self.get_unmapped_live_in_reg(self.host_live_in_reg, initial_mapping)
            if len(guest_unmapped_reg) > 0 or len(host_unmapped_reg) > 0:
                if len(guest_unmapped_reg) > len(host_unmapped_reg):
                    rule_give_up_initial_mapping = rule_give_up_initial_mapping + 1
                    if DEBUG_ENABLE:
                        print "\nCannot setup initial mapping for guest/host register"
                        print "**** Give up this rule candidate ****"
                    return 0, ERR_INITIAL_MAPPING
                else:
                    # Try an unexplored mapping, previous mappings are saved in tried_mapping
                    def tried_before(g_reg_l, h_reg_l):
                        for tm in tried_mapping:
                            (tg, th) = tm
                            flag = False
                            for i in range(0, len(tg)):
                                if tg[i] != g_reg_l[i] or th[i] != h_reg_l[i]:
                                    flag = True
                                    break
                            if not flag:
                                return True
                        return False
                    def add_tried_mapping(g_reg_l, h_reg_l):
                        tried_mapping.append((g_reg_l, h_reg_l))
                    found = False
                    for ph in permutations(host_unmapped_reg):
                        if not tried_before(guest_unmapped_reg, ph[0:len(guest_unmapped_reg,)]):
                            found = True
                            add_tried_mapping(guest_unmapped_reg, ph)
                            if DEBUG_ENABLE:
                                print "\n== Try this mapping:"
                            for i in range(0, len(guest_unmapped_reg)):
                                if DEBUG_ENABLE:
                                    print "  %s = %s" % (guest_unmapped_reg[i], ph[i])
                                initial_mapping.append((guest_unmapped_reg[i], ph[i]))
                            # Try to see if we can find a live-in register in a similar guest instruction
                            # Otherwise, just heuristically set the remaining unmapped host registers to 0
                            for i in range(len(guest_unmapped_reg), len(ph)):
                                host_opc = host.get_opc_access_live_in_reg(self.host_inst_parsed, ph[i])
                                greg = ""
                                if host_opc != "":
                                    greg = guest.search_live_in_reg_opc(self.guest_inst_parsed, host_opc)
                                if greg == "":
                                    # If this unmapped host register is used as destination,
                                    # we should not map it to 0
                                    if host.is_destination_live_in_reg(self.host_inst_parsed, ph[i]):
                                        rule_give_up_initial_mapping = rule_give_up_initial_mapping + 1
                                        if DEBUG_ENABLE:
                                            print "Cannot setup initial mapping for host register: %s" % ph[i]
                                            print "Give up this mapping\n"
                                        return 0, ERR_INITIAL_MAPPING
                                    greg = '0'
                                if DEBUG_ENABLE:
                                    print "  %s = %s" % (greg, ph[i])
                                initial_mapping.append((greg, ph[i]))
                            break
                    # We tried all possible mapping
                    if not found:
                        global rule_give_up_failed_verification
                        global failed_verification_mem_addr_diff
                        global failed_verification_mem_cont_diff
                        global failed_verification_branch_cond
                        global failed_verification_reg_diff
                        if last_failed_verification == 0:
                            rule_give_up_initial_mapping = rule_give_up_initial_mapping + 1
                            if DEBUG_ENABLE:
                                print "\nCannot setup initial mapping for guest/host register after tried all possible mappings"
                                print "**** Give up this rule candidate ****"
                        elif last_failed_verification == 1:
                            rule_give_up_failed_verification = rule_give_up_failed_verification + 1
                            failed_verification_mem_addr_diff = failed_verification_mem_addr_diff + 1
                        elif last_failed_verification == 2:
                            rule_give_up_failed_verification = rule_give_up_failed_verification + 1
                            failed_verification_mem_cont_diff = failed_verification_mem_cont_diff + 1
                        elif last_failed_verification == 3:
                            rule_give_up_failed_verification = rule_give_up_failed_verification + 1
                            failed_verification_branch_cond = failed_verification_branch_cond + 1
                        elif last_failed_verification == 4:
                            rule_give_up_failed_verification = rule_give_up_failed_verification + 1
                            failed_verification_reg_diff = failed_verification_reg_diff + 1
                        return 0, ERR_INITIAL_MAPPING
            # try to guess initial mapping for the unmapped immediate symbols after above guessing
            def guess_imm_mapping(g_ui, h_ui):
                g_ui_val = g_ui[1]
                h_ui_val = h_ui[1]
                #print "==========guest: %d, host: %d" % (g_ui_val, h_ui_val)
                g_imm_exp = ""
                if g_ui_val == h_ui_val: # same
                    g_imm_exp = g_ui[2]
                elif -g_ui_val == h_ui_val: # negative
                    g_imm_exp = '\'(-' + g_ui[2] + ')\''
                elif ~g_ui_val == h_ui_val: # logical not
                    g_imm_exp = '\'(~' + g_ui[2] + ')\''
                elif g_ui_val > 0 and (1 << g_ui_val) == h_ui_val: # left shift
                    g_imm_exp = '\'(1<<' + g_ui[2] + ')\''
                return g_imm_exp
            # add guessed initial mapping
            def add_imm_mapping(g_ui, h_ui, g_imm_exp, initial_mapping, imm_para):
                initial_mapping.append([g_imm_exp, h_ui[2]])
                imm_para.append(g_ui[0:3])
                imm_para.append(h_ui[0:3])
                guest.set_unmapped_imm_para_flag(g_ui[3])
                host.set_unmapped_imm_para_flag(h_ui[3])
            g_unmapped_imm = guest.get_unmapped_immediate(self.guest_rule_inst)
            h_unmapped_imm = host.get_unmapped_immediate(self.host_rule_inst)
            if len(g_unmapped_imm) == 1 and len(h_unmapped_imm) == 1:
                # Try to guess a mapping based on the values of guest and host immediates
                g_ui = g_unmapped_imm[0]
                h_ui = h_unmapped_imm[0]
                g_imm_exp = guess_imm_mapping(g_ui, h_ui)
                if g_imm_exp == "": # Just guess these two immediates are equal 
                    g_imm_exp = g_ui[2]
                initial_mapping.append([g_imm_exp, h_ui[2]])
                imm_para.append(g_ui[0:3])
                imm_para.append(h_ui[0:3])
                guest.set_unmapped_imm_para_flag(g_ui[3])
                host.set_unmapped_imm_para_flag(h_ui[3])
            elif len(g_unmapped_imm) == 1 and len(h_unmapped_imm) == 2:
                # 1. Try to guess a mapping based on the values of guest and host immediates
                g_ui_0 = g_unmapped_imm[0]
                h_ui_0 = h_unmapped_imm[0]
                h_ui_1 = h_unmapped_imm[1]
                g_imm_exp_0 = guess_imm_mapping(g_ui_0, h_ui_0)
                g_imm_exp_1 = guess_imm_mapping(g_ui_0, h_ui_1)
                if g_imm_exp_0 != "":
                    initial_mapping.append([g_imm_exp_0, h_ui_0[2]])
                    # Heuristically set the unmapped host imm to 0
                    initial_mapping.append(["0", h_ui_1[2]])
                elif g_imm_exp_1 != "":
                    initial_mapping.append([g_imm_exp_1, h_ui_1[2]])
                    # Heuristically set the unmapped host imm to 0
                    initial_mapping.append(["0", h_ui_0[2]])
                imm_para.append(g_ui_0[0:3])
                imm_para.append(h_ui_0[0:3])
                imm_para.append(h_ui_1[0:3])
                guest.set_unmapped_imm_para_flag(g_ui_0[3])
                host.set_unmapped_imm_para_flag(h_ui_0[3])
                host.set_unmapped_imm_para_flag(h_ui_1[3])
            elif len(g_unmapped_imm) == 2 and len(h_unmapped_imm) == 1:
                # 1. Try to guess a mapping based on the values of guest and host immediates
                g_ui_0 = g_unmapped_imm[0]
                g_ui_1 = g_unmapped_imm[1]
                h_ui_0 = h_unmapped_imm[0]
                g_imm_exp_0 = guess_imm_mapping(g_ui_0, h_ui_0)
                g_imm_exp_1 = guess_imm_mapping(g_ui_1, h_ui_0)
                if g_imm_exp_0 != "":
                    initial_mapping.append([g_imm_exp_0, h_ui_0[2]])
                    imm_para.append(g_ui_0[0:3])
                    imm_para.append(h_ui_0[0:3])
                    guest.set_unmapped_imm_para_flag(g_ui_0[3])
                    host.set_unmapped_imm_para_flag(h_ui_0[3])
                elif g_imm_exp_1 != "":
                    initial_mapping.append([g_imm_exp_1, h_ui_0[2]])
                    imm_para.append(g_ui_1[0:3])
                    imm_para.append(h_ui_0[0:3])
                    guest.set_unmapped_imm_para_flag(g_ui_1[3])
                    host.set_unmapped_imm_para_flag(h_ui_0[3])
                else: # 2. Try to use different operations based on hints of guest instructions
                    op = guest.guess_imm_operation(g_unmapped_imm)
                    g_imm_exp = '\'(' + g_ui_0[2] + op + g_ui_1[2] + ')\''
                    initial_mapping.append([g_imm_exp, h_ui_0[2]])
                    imm_para.append(g_ui_0[0:3])
                    imm_para.append(g_ui_1[0:3])
                    imm_para.append(h_ui_0[0:3])
                    guest.set_unmapped_imm_para_flag(g_ui_0[3])
                    guest.set_unmapped_imm_para_flag(g_ui_1[3])
                    host.set_unmapped_imm_para_flag(h_ui_0[3])
            elif len(g_unmapped_imm) == 2 and len(h_unmapped_imm) == 2:
                # Try to guess a mapping based on the values of guest and host immediates
                g_ui_0 = g_unmapped_imm[0]
                g_ui_1 = g_unmapped_imm[1]
                h_ui_0 = h_unmapped_imm[0]
                h_ui_1 = h_unmapped_imm[1]
                g_imm_exp_0_0 = guess_imm_mapping(g_ui_0, h_ui_0)
                g_imm_exp_0_1 = guess_imm_mapping(g_ui_0, h_ui_1)
                if g_imm_exp_0_0 != "":
                    if g_ui_0[4] == h_ui_0[4]:
                        add_imm_mapping(g_ui_0, h_ui_0, g_imm_exp_0_0, initial_mapping, imm_para)
                        g_imm_exp_1_1 = guess_imm_mapping(g_ui_1, h_ui_1)
                        if g_imm_exp_1_1 != "" and g_ui_1[4] == h_ui_1[4]:
                            add_imm_mapping(g_ui_1, h_ui_1, g_imm_exp_1_1, initial_mapping, imm_para)
                    elif g_imm_exp_0_1 != "":
                        if g_ui_0[4] == h_ui_1[4]:
                            add_imm_mapping(g_ui_0, h_ui_1, g_imm_exp_0_1, initial_mapping, imm_para)
                            g_imm_exp_1_0 = guess_imm_mapping(g_ui_1, h_ui_0)
                            if g_imm_exp_1_0 != "" and g_ui_1[4] == h_ui_0[4]:
                                add_imm_mapping(g_ui_1, h_ui_0, g_imm_exp_1_0, initial_mapping, imm_para)
                elif g_imm_exp_0_1 != "":
                    if g_ui_0[4] == h_ui_0[4]:
                        add_imm_mapping(g_ui_0, h_ui_1, g_imm_exp_0_1, initial_mapping, imm_para)
                        g_imm_exp_1_0 = guess_imm_mapping(g_ui_1, h_ui_0)
                        if g_imm_exp_1_0 != "" and g_ui_1[4] == h_ui_0[4]:
                            add_imm_mapping(g_ui_1, h_ui_0, g_imm_exp_1_0, initial_mapping, imm_para)
                #else:
                #    rule_give_up_initial_mapping = rule_give_up_initial_mapping + 1
                #    print "\nCannot setup initial mapping for guest(%d)/host immediate(%d)" % \
                #      (len(g_unmapped_imm), len(h_unmapped_imm))
                #    print "**** Give up this rule candidate ****"
                #    return 0
            elif len(g_unmapped_imm) == 0 and len(h_unmapped_imm) == 1:
                # Just guess the host immediate is 0
                h_ui = h_unmapped_imm[0]
                initial_mapping.append([0, h_ui[2]])
                imm_para.append(h_ui[0:3])
                host.set_unmapped_imm_para_flag(h_ui[3])
            #elif len(g_unmapped_imm) > 0 and len(h_unmapped_imm) > 0:
            #    rule_give_up_initial_mapping = rule_give_up_initial_mapping + 1
            #    print "\nCannot setup initial mapping for guest(%d)/host immediate(%d)" % \
            #          (len(g_unmapped_imm), len(h_unmapped_imm))
            #    print "**** Give up this rule candidate ****"
            #    return 0
        initial_mapping_str = ""
        for map_list in initial_mapping:
            initial_mapping_str += " -init-map "
            for item in map_list[:-1]:
                initial_mapping_str += "%s=" % item
            initial_mapping_str += map_list[-1]
        imm_para_str = ""
        for ip_list in imm_para:
            imm_para_str += " -imm-para "
            imm_para_str += "%s=" % ip_list[0].pc
            for item in ip_list[1:-1]:
                imm_para_str += "%s=" % item
            imm_para_str += ip_list[-1]

        # 1.3 Prepare def registers
        guest_def_reg_str = self.get_def_reg_str(self.guest_def_reg, "-arm-def-reg")
        host_def_reg_str = self.get_def_reg_str(self.host_def_reg, "-x86-def-reg")

        # 2. Call verification tool
        verification_result_file = "./.tmp_ver_res"
        verify_cmd = "%s %s" % (VINE_TOOL, solver_str)
        verify_cmd += " %s %s" % (guest_binary_str, host_binary_str)
        verify_cmd += " %s" % imm_para_str
        verify_cmd += " %s" % mem_mapping_str
        verify_cmd += " %s" % initial_mapping_str
        verify_cmd += " %s %s" % (guest_def_reg_str, host_def_reg_str)
        verify_cmd += " > %s 2>&1" % verification_result_file
        if DEBUG_ENABLE:
            print "== Verification command:\n\t%s" % verify_cmd
        if PROFILE_ENABLE:
            start_time = time.time() 
        os.system(verify_cmd)
        if PROFILE_ENABLE:
            end_time = time.time()
            global verification_time
            verification_time = verification_time + (end_time - start_time)
        os.system("rm -rf ./fuzzball-tmp-*")

        if not os.path.isfile(verification_result_file):
            global failed_verification_no_result
            failed_verification_no_result = failed_verification_no_result + 1
            rule_give_up_failed_verification = rule_give_up_failed_verification + 1 
            if DEBUG_ENABLE:
                print "\nCannot find verfication result file"
                print "**** Give up this rule candidate ****"
            return 0, ERR_FAILED_VERIFICATION
        # 3. Check verification result
        res_start = False
        reg_mapping = []
        reg_no_mapping = []
        self.cc_mapping = []
        unmapped_cc_counter = 0
        with open(verification_result_file, "r") as v_r_f:
            for line in v_r_f:
                if DEBUG_ENABLE:
                    print "%s" % line
                if "Fatal error" in line:
                    global failed_verification_crash
                    if last_failed_verification == 0:
                        failed_verification_crash = failed_verification_crash + 1
                        rule_give_up_failed_verification = rule_give_up_failed_verification + 1
                        if DEBUG_ENABLE:
                            print "Error when invoke verification tool: \n%s" % line,
                            print "\n**** Give up this rule candidate ****"
                    elif last_failed_verification == 1:
                        rule_give_up_failed_verification = rule_give_up_failed_verification + 1
                        failed_verification_mem_addr_diff = failed_verification_mem_addr_diff + 1
                    elif last_failed_verification == 2:
                        rule_give_up_failed_verification = rule_give_up_failed_verification + 1
                        failed_verification_mem_cont_diff = failed_verification_mem_cont_diff + 1
                    elif last_failed_verification == 3:
                        rule_give_up_failed_verification = rule_give_up_failed_verification + 1
                        failed_verification_branch_cond = failed_verification_branch_cond + 1
                    elif last_failed_verification == 4:
                        rule_give_up_failed_verification = rule_give_up_failed_verification + 1
                        failed_verification_reg_diff = failed_verification_reg_diff + 1
                    v_r_f.close()
                    os.remove(verification_result_file)
                    return 0, ERR_FAILED_VERIFICATION
                # this line is a result line
                if res_start:
                    if "1. Address" in line and "Different" in line:
                        rule_give_up_failed_verification = rule_give_up_failed_verification + 1 
                        failed_verification_mem_addr_diff = failed_verification_mem_addr_diff + 1
                        if DEBUG_ENABLE:
                            print "Memory verification failed, address is not equal",
                            print "\n**** Give up this rule candidate ****"
                        v_r_f.close()
                        os.remove(verification_result_file)
                        return 1, ERR_FAILED_VERIFICATION_MEM_ADDR
                    elif "2. Content" in line and "Different" in line:
                        failed_verification_mem_cont_diff = failed_verification_mem_cont_diff + 1
                        rule_give_up_failed_verification = rule_give_up_failed_verification + 1 
                        if DEBUG_ENABLE:
                            print "Memory verification failed, content is not equal",
                            print "\n**** Give up this mapping or try another init mapping ****"
                        v_r_f.close()
                        os.remove(verification_result_file)
                        return 1, ERR_FAILED_VERIFICATION_MEM_CONT
                    elif "Compare condition" in line and "Different" in line:
                        failed_verification_branch_cond = failed_verification_branch_cond + 1
                        rule_give_up_failed_verification = rule_give_up_failed_verification + 1 
                        if DEBUG_ENABLE:
                            print "Condition verification for branch failed",
                            print "\n**** Give up this rule candidate or try another init mapping ****"
                        v_r_f.close()
                        os.remove(verification_result_file)
                        return 1, ERR_FAILED_VERIFICATION_BRANCH_COND
                    elif "Condition Code" in line:
                        arm_cc = ""
                        x86_cc = ""
                        substr = re.search("Code: (ARM_[NZCV]F) ", line)
                        if substr:
                            arm_cc = substr.group(1)
                        elif DEBUG_ENABLE:
                            print "Warnning: cannot find arm cc:\n%s" % line
                        if "not defined" in line:
                            x86_cc = "none"
                            unmapped_cc_counter += 1
                        else:
                            substr = re.search("(x86_[OSCZ]F)", line)
                            if substr:
                                x86_cc = substr.group(1)
                            elif DEBUG_ENABLE:
                                print "Warnning: cannot find x86 cc:\n%s" % line
                            if '!' in line:
                                x86_cc = '!' + x86_cc
                        self.cc_mapping.append((arm_cc, x86_cc))
                    elif "Found a register mapping" in line:
                        substr = re.search(" (R[0-9]+) = (.+?):", line)
                        if substr:
                            reg1 = substr.group(1).lower()
                            reg2 = (substr.group(2))[-3:].lower()
                            #print "Regmapping: %s = %s" % (reg1, reg2)
                            # check if this host register has been mapped to another guest register
                            for (reg1_p, reg2_p) in reg_mapping:
                                if reg1_p != reg1 and reg2_p == reg2:
                                    failed_verification_reg_diff = failed_verification_reg_diff + 1
                                    rule_give_up_failed_verification = rule_give_up_failed_verification + 1
                                    if DEBUG_ENABLE:
                                        print "Same host register mapped to different guest registers: %s to %s and %s" % \
                                              (reg2, reg1_p, reg1)
                                        print "\n**** Give up this rule candidate or try another init mapping ****"
                                    v_r_f.close()
                                    os.remove(verification_result_file)
                                    return 1, ERR_FAILED_VERIFICATION_REG_DIFF
                            reg_mapping.append((reg1, reg2))
                        else:
                            print "Warnning: cannot find mapped register:\n%s" % line
                    elif "Cannot find" in line:
                        rindex = line.rfind('R') # find out the unmapped guest register
                        reg_no_mapping.append(line[rindex:-1].lower())
                        failed_verification_reg_diff = failed_verification_reg_diff + 1                        
                        rule_give_up_failed_verification = rule_give_up_failed_verification + 1
                        if DEBUG_ENABLE: 
                            print "\nCannot pass verification because of not enough mapped output registers"
                            print "**** Give up this rule candidate ****"
                        v_r_f.close()
                        os.remove(verification_result_file)
                        return 1, ERR_FAILED_VERIFICATION_REG_DIFF

                 # start of verification result
                if "Verification Result" in line:
                    res_start = True
        v_r_f.close()
        os.remove(verification_result_file)
        for reg in reg_no_mapping:
            # check if this register is used after last definition
            if guest.used_after_last_definition(reg, self.guest_rule_inst):
                continue
            failed_verification_reg_diff = failed_verification_reg_diff + 1
            rule_give_up_failed_verification = rule_give_up_failed_verification + 1
            if DEBUG_ENABLE: 
                print "\nCannot pass verification because of not enough mapped output registers"
                print "**** Give up this rule candidate ****"
            return 1, ERR_FAILED_VERIFICATION_REG_DIFF
        #if unmapped_cc_counter == 4:
            # There is no condition code mapped, so give up this candidate
        #    rule_give_up_failed_verification = rule_give_up_failed_verification + 1
        #    print "\nCannot pass verification because of not enough mapped condition codes"
        #    print "**** Give up this rule candidate ****"
        #    return 0, ERR_FAILED_VERIFICATION

        # 4. We passed the verification test, try to generalize guest and host instructions
        self.guest_rule_inst, guest_reg_gen_mapping, mem_gen_mapping = \
            guest.generalize_inst(self.guest_rule_inst)
        reg_adjust_mapping_def = {}
        for i in range(0, len(reg_mapping)):
            (guest_r, host_r) = reg_mapping[i]
            if guest_reg_gen_mapping.has_key(guest_r):
                reg_adjust_mapping_def[host_r] = guest_reg_gen_mapping[guest_r]
            else:
                print "Error: cannot find register mapping."
        # add initial register mapping
        reg_adjust_mapping_init = {}
        for mapping in initial_mapping:
            if mapping[1][0] == 'e': # this is a register mapping
                if mapping[0][0] == 'r':
                    if guest_reg_gen_mapping.has_key(mapping[0]):
                        reg_adjust_mapping_init[mapping[1]] = guest_reg_gen_mapping[mapping[0]]
                    else:
                        global rule_give_up_failed_generalization
                        rule_give_up_failed_generalization = rule_give_up_failed_generalization + 1
                        if DEBUG_ENABLE:
                            print "\nCannot generalize host instructions because same host register mapped to different guest registers"
                            print "**** Give up this mapping ****"
                        return 1, ERR_FAILED_GENERALIZATION # Let's retry
                else:
                    reg_adjust_mapping_init[mapping[1]] = mapping[0]
        flag, self.host_rule_inst = \
            host.generalize_inst(self.host_rule_inst, reg_adjust_mapping_def, reg_adjust_mapping_init, \
                                 mem_gen_mapping, self.host_def_reg, initial_mapping)
        if not flag:
            rule_give_up_failed_generalization = rule_give_up_failed_generalization + 1
            if DEBUG_ENABLE:
                print "\nCannot generalize host instructions because same host/guest register mapped to different guest/host registers"
                print "**** Give up this mapping ****"
            return 1, ERR_FAILED_GENERALIZATION # Let's retry

        for i in range(0, len(reg_no_mapping)):                                                            
            reg = reg_no_mapping[i]
            if guest_reg_gen_mapping.has_key(reg):
                reg_no_mapping[i] = guest_reg_gen_mapping[reg]
            else:
                print "Error: cannot find register mapping."

        self.context = reg_no_mapping[:]
        return 2, SUCCESS

    # Save the learned rule, firstly check if we already have the same guest part in existing rules
    def save_rule(self, guest_part, host_part, context_part, cc_mapping, comment_part):
        def has_cmp(part):
            for i in part:
                if "cmp" in i:
                    return True
            return False
        def unmapped_cc_num(cc_mapping):
            num = 0
            for (arm_cc, x86_cc) in cc_mapping:
                if x86_cc == "none":
                    num += 1
            return num
        def do_replace(tr, host, context, cc_mapping, comment):
            if DEBUG_ENABLE:
                print "==================== Replace a rule ====================="
                print "Guest Part:"
                for inst in tr.guest:
                    print "%s" % inst
                print "Host Part (Original):"
                for inst in tr.host:
                    print "%s" % inst
                print "Host Part (New):"
                for inst in host:
                    print "%s" % inst
                print ""
            tr.host = host
            tr.context = context
            tr.cc_mapping = cc_mapping
            tr.comment = comment
        found = False
        for tr in self.translation_rules:
            flag = True
            if len(guest_part) != len(tr.guest):
                continue
            for i in range(0, len(guest_part)):
                if guest_part[i] != tr.guest[i]:
                    flag = False
                    break
            if flag:
                found = True
                break
        if not found:
            new_tr = TranslationRule(guest_part, host_part, context_part, cc_mapping, comment_part)
            self.translation_rules.append(new_tr)
        elif (len(context_part) < len(tr.context)):
            # We encountered this guest in previous rules, keep the rule that requires less context
            do_replace(tr, host_part, context_part, cc_mapping, comment_part)
        elif unmapped_cc_num(tr.cc_mapping) > unmapped_cc_num(cc_mapping):
            do_replace(tr, host_part, context_part, cc_mapping, comment_part)
        elif (has_cmp(guest_part) and not has_cmp(tr.host) and has_cmp(host_part)):
            # If guest has cmp, we also prefer to host having cmp
            do_replace(tr, host_part, context_part, cc_mapping, comment_part)
        elif ((len(context_part) == len(tr.context)) and (len(host_part) < len(tr.host))):
            do_replace(tr, host_part, context_part, cc_mapping, comment_part)

    # Learn rule for the source line
    def learn_internal(self):
        self.rule_counter += 1
        global rule_candidate
        rule_candidate = rule_candidate + 1

        
        # 1. Parse guest and host instructions
        self.guest_inst_parsed, self.guest_var = \
            self.parse_inst_list(self.guest_inst_raw, self.guest_binary, self.guest_ir, guest)
        self.host_inst_parsed, self.host_var = \
            self.parse_inst_list(self.host_inst_raw, self.host_binary, self.host_ir, host) 
        
        #sch: count unique candidates
        guest_candi = []
        for inst in self.guest_inst_parsed:
            if DEBUG_ENABLE:
                guest_candi.append(guest.print_inst(inst, False).lstrip())
            else:
                guest_candi.append(guest.print_inst_silent(inst, False).lstrip())
        found = False
        print("candidate length: %s" % len(self.candidate_rules))
        for tr in self.candidate_rules:
            flag = True
            if len(guest_candi) != len(tr.guest):
                continue
            for i in range(0, len(guest_candi)):
                if guest_candi[i] != tr.guest[i]:
                    flag = False
                    break
            if flag:
                found = True
                break
        print ("found: " + str(found))
        if not found:
            new_tr = TranslationRule(guest_candi, None, None, None, None)
            self.candidate_rules.append(new_tr)
        if len(self.guest_var) > 0 or len(self.host_var) > 0:
            self.memory_counter += 1

        if DEBUG_ENABLE:
            print "========================= %d (mem: %d) ===============================" % \
                  (self.rule_counter, self.memory_counter)
            print "Learning source line: %s:%s:%s" % \
                  (self.ifunc.ifile.get_src_file_name_with_dir(), self.ifunc.name, self.src_line_no)
            print "%s" % self.ifunc.ifile.get_src_file_line(int(self.src_line_no))
            print "Guest Asm (raw):"
            for line in self.guest_inst_raw:
                print "\t%s" % line
            print "Host Asm (raw):"
            for line in self.host_inst_raw:
                print "\t%s" % line
            print ""
            print "Guest IR:"
            for line in self.guest_ir:
                print "%s" % line,
            print "Host IR:"
            for line in self.host_ir:
                print "%s" % line,
            print ""

        if len(self.guest_var) != len(self.host_var):
            global rule_give_up_diff_var_num
            rule_give_up_diff_var_num = rule_give_up_diff_var_num + 1
            if DEBUG_ENABLE:
                print "\nCannot setup memory mapping because different numbers of variables, guest: %d, host: %d" % \
                       (len(self.guest_var), len(self.host_var))
                print "**** Give up this rule candidate ****"
                print "=======================================================\n\n"
            return
        elif len(self.guest_var) == 1 or len(self.guest_var) == 2: # Hack for gcc
            (guest_mem_opd, guest_pc_list) = self.guest_var.values()[len(self.guest_var) - 1]
            (host_mem_opd, host_pc_list) = self.host_var.values()[len(self.guest_var) - 1]
            if (len(guest_pc_list) == 2 or len(guest_pc_list) == 3) and (len(host_pc_list) == 1 or len(host_pc_list) == 2):
                # Check if the base register in this guest memory operand is modified
                for inst in self.guest_inst_parsed:
                    if inst.pc == guest_pc_list[0] and inst.opc == "ldr" and inst.opd_list[0].typ == "reg" and \
                       inst.opd_list[0].opd.reg.name == guest_mem_opd.base.name:
                            rule_give_up_diff_var_num = rule_give_up_diff_var_num + 1
                            if DEBUG_ENABLE:
                                print "\nCannot setup memory mapping because different numbers of variables, guest > host" 
                                print "**** Give up this rule candidate ****"
                                print "=======================================================\n\n"
                            return

        # 2. Analyze live-in and def registers
        self.guest_live_in_reg, self.guest_def_reg, self.guest_use_reg = \
            self.analyze_register_liveness(self.guest_inst_parsed, guest)
        self.host_live_in_reg, self.host_def_reg, self.host_use_reg = \
            self.analyze_register_liveness(self.host_inst_parsed, host)

        if len(self.guest_def_reg) == 0 and len(self.host_def_reg) > 0:
            global rule_give_up_initial_mapping
            rule_give_up_initial_mapping = rule_give_up_initial_mapping + 1
            if DEBUG_ENABLE:
                print "\nCannot setup mapping because of different numbers of live-out registers, guest: %d, host: %d" % \
                        (len(self.guest_def_reg), len(self.host_def_reg))
                print "**** Give up this rule candidate ****"
                print "=======================================================\n\n"
            return 

        if DEBUG_ENABLE:
            print "Guest Asm (parsed):"
            for inst in self.guest_inst_parsed:
                guest.print_inst(inst, True)
            print "Host Asm (parsed):"
            for inst in self.host_inst_parsed:
                host.print_inst(inst, True)
            print ""
            print "\n== Guest live in reg: ",
            for reg in self.guest_live_in_reg:
                print "%s" % reg,
            print ""
            print "== Guest def reg: ",
            for reg in self.guest_def_reg:
                print "%s" % reg,
            print ""
            print "== Host live in reg: ",
            for reg in self.host_live_in_reg:
                print "%s" % reg,
            print ""
            print "== Host def reg: ",
            for reg in self.host_def_reg:
                print "%s" % reg,
            print ""

        # merge binary code to get a binary string
        def merge_binary(inst_list):
            asm_binary = ""
            for inst in inst_list:
                asm_binary += inst.binary + ' '
            return asm_binary.rstrip()
        guest_binary_str = "-arm-insns \'%s\'" % merge_binary(self.guest_inst_parsed)
        host_binary_str = "-x86-insns \'%s\'" % merge_binary(self.host_inst_parsed)

        solver_str = "-solver smtlib-batch -solver-path %s" % STP_SOLVER

        # 3. Do verification
        tried_mapping = []
        global last_failed_verification
        last_failed_verification = 0
        for i in range(0, 5): # only try 5 times
            # In case we fail any step in the following steps, we work on a copy of the parsed instructions
            self.guest_rule_inst = copy.deepcopy(self.guest_inst_parsed)
            self.host_rule_inst = copy.deepcopy(self.host_inst_parsed)
            self.context = []
            self.adjust_var_list(self.guest_var, self.guest_rule_inst) # We need to adjust vars to point 
            self.adjust_var_list(self.host_var, self.host_rule_inst)   # to new copied memory operands

            result, errno = self.do_verification(guest_binary_str, host_binary_str, solver_str, tried_mapping)

            if result == 0: # failed verification and not necessary to re-try
                break
            elif result == 1: # failed verification but necessary to re-try
                if i+1 < 5:
                    if errno == ERR_FAILED_VERIFICATION or errno == ERR_FAILED_VERIFICATION_MEM_ADDR or \
                       errno == ERR_FAILED_VERIFICATION_MEM_CONT or errno == ERR_FAILED_VERIFICATION_BRANCH_COND or \
                       errno == ERR_FAILED_VERIFICATION_REG_DIFF:
                        global rule_give_up_failed_verification
                        global failed_verification_mem_addr_diff
                        global failed_verification_mem_cont_diff
                        global failed_verification_branch_cond
                        global failed_verification_reg_diff
                        rule_give_up_failed_verification = rule_give_up_failed_verification - 1
                        if errno == ERR_FAILED_VERIFICATION_MEM_ADDR:
                            failed_verification_mem_addr_diff = failed_verification_mem_addr_diff - 1
                            last_failed_verification = 1;
                        elif errno == ERR_FAILED_VERIFICATION_MEM_CONT:
                            failed_verification_mem_cont_diff = failed_verification_mem_cont_diff - 1
                            last_failed_verification = 2;
                        elif errno == ERR_FAILED_VERIFICATION_BRANCH_COND:
                            failed_verification_branch_cond = failed_verification_branch_cond - 1
                            last_failed_verification = 3;
                        elif errno == ERR_FAILED_VERIFICATION_REG_DIFF:
                            failed_verification_reg_diff = failed_verification_reg_diff - 1
                            last_failed_verification = 4;
                    if errno == ERR_FAILED_GENERALIZATION:
                        global rule_give_up_failed_generalization
                        rule_give_up_failed_generalization = rule_give_up_failed_generalization - 1
                continue
            else: # successful verification
                '''guest_has_cmp = False
                for inst in self.guest_rule_inst:
                    if "cmp" in inst.opc:
                        guest_has_cmp = True
                        break
                host_has_cmp = False
                for inst in self.host_rule_inst:
                    if "cmp" in inst.opc:
                        host_has_cmp = True
                        break
                if guest_has_cmp and not host_has_cmp:
                    rule_give_up_failed_verification = rule_give_up_failed_verification + 1
                    break'''
                global rule_learned
                rule_learned = rule_learned + 1
                if DEBUG_ENABLE:
                    print "\n==== We just learned a rule ===="
                    print "Guest part:"
                guest_part = []
                for inst in self.guest_rule_inst:
                    if DEBUG_ENABLE:
                        guest_part.append(guest.print_inst(inst, False).lstrip())
                    else:
                        guest_part.append(guest.print_inst_silent(inst, False).lstrip())
                if DEBUG_ENABLE:
                    print "Host part:"
                host_part = []
                for inst in self.host_rule_inst:
                    if DEBUG_ENABLE:
                        host_part.append(host.print_inst(inst, False).lstrip())
                    else:
                        host_part.append(host.print_inst_silent(inst, False).lstrip())
                if DEBUG_ENABLE:
                    print "Context (Guest):\n\t",
                context_str = ""
                if len(self.context) > 0:
                    for reg in self.context:
                        context_str = context_str + reg.lower() + ', '
                    context_str = context_str[:-2]
                    context_str += ": not used"
                else:
                    context_str = "none"
                if DEBUG_ENABLE:
                    print context_str
                    print "Condition Code:\n",
                    for (arm_cc, x86_cc) in self.cc_mapping:
                        print "\t%s = %s" % (arm_cc, x86_cc)

                comment_part = "%s:%s:%s" % \
                               (self.ifunc.ifile.get_src_file_name_with_dir(), self.ifunc.name, self.src_line_no)
                self.save_rule(guest_part, host_part, self.context, self.cc_mapping, comment_part);
                break

        if DEBUG_ENABLE:
            print "=======================================================\n\n"

    def learn_line(self, src_line_no, ifunc):
        if DEBUG_ENABLE:
            print "==== Planning to learn source line: %s:%s:%s" % \
                (self.ifunc.ifile.get_src_file_name_with_dir(), self.ifunc.name, src_line_no)
        # 1. Prepare data for learning
        self.reset()
        # 2. Check if we support this line and then learn it
        if (self.learn_prepare(src_line_no)):
            self.learn_internal()

    def dump_translation_rules(self):
        f = open("t_rules", 'w')
        for i in range(0, len(self.translation_rules)):
            tr = self.translation_rules[i]
            f.write("#"+tr.comment+'\n')
            f.write(str(i+1)+".Guest:\n")
            for inst in tr.guest:
                f.write("    "+inst+'\n')
            f.write(str(i+1)+".Host:\n")
            for inst in tr.host:
                f.write("    "+inst+'\n')
            c_str = "%d.Context:\n" % (i+1)
            f.write(str(i+1)+".Context:\n")
            context_str = "    "
            if len(tr.context) > 0:
                for reg in tr.context:
                    context_str = context_str + reg.lower() + ', '
                context_str = context_str[:-2]
                context_str += ": not used\n"
            else:
                context_str += "none\n"
            f.write(context_str)
            f.write(str(i+1)+".Condition Code:\n")
            for (arm_cc, x86_cc) in tr.cc_mapping:
                f.write("    "+arm_cc+" = "+x86_cc+'\n')
            f.write('\n')
        f.close()
            
def usage():
    print "Extract pattern rules for DBT"
    print "Usage:"
    print "    pattern.py source_code_directory"
    print "Example:"
    print "    ./pattern.py ./test"

# Try to learn rules from the function
def learn(ifunc, ilearn):
    for i in range(0, len(ifunc.guest_ir)):
        line = ifunc.guest_ir[i]
        dbg_info = re.search("dbg:(.+?):([0-9]+):([0-9]+)", line)
        if dbg_info:
            ir_line = dbg_info.group(2)
            # check if we have learned this line
            if ir_line in ifunc.ifile.learned_src_line:
                continue
            ifunc.ifile.learned_src_line.append(ir_line)
            if LINE_MODE and ir_line != LINE_WANTED:
                continue
            ilearn.learn_line(ir_line, ifunc)
def generate_input_files(cfile):
    def generate_internal(cfile, arch, opt):
        TMPFILE = "./.tmp"
        BEFORE = "" # "-print-before-all"
        if DEBUG_ENABLE:
            print "%s (generate input files for %s)..." % (cfile, arch.ARCH_STR)
            print "  1.  Generate LLVM IR using guest compiler"
        cmd = "%s %s %s -emit-llvm -o %s -c %s 2>%s" % (arch.CC, CFLAGS, opt, arch.BC, cfile, TMPFILE)
        if DEBUG_ENABLE:
            print "        %s" % cmd
        os.system(cmd)
        if DEBUG_ENABLE:
            print "  2.  Generate guest asm code"
        #-relocation-model=pic
        cmd = "%s %s %s -relocation-model=pic -print-after=livedebugvalues -asm-show-inst %s 2>%s" % (arch.LC, opt, BEFORE, arch.BC, arch.IR)
        if DEBUG_ENABLE:
            print "        %s" % cmd
        os.system(cmd)
        if DEBUG_ENABLE:
            print "  3.1 Remove .align directive"
        f = open(arch.ASM, "r+")
        lines = f.readlines()
        f.seek(0)
        for line in lines:
            if ".align" in line:
                continue
            f.write(line)
        f.truncate()
        f.close()
        if DEBUG_ENABLE:
            print "  3.2 Assemble asm code to obj file"
        cmd = "%s %s -o %s" % (arch.AS, arch.ASM, arch.OBJ)
        if DEBUG_ENABLE:
            print "        %s" % cmd
        os.system(cmd)
        if DEBUG_ENABLE:
            print "  4.  Dump obj file to asm code"
        dump_opt = ""
        if (arch == host):
            dump_opt = "-M suffix"
        cmd = "%s -d -M reg-names-raw %s --insn-width=11 %s > %s" % (arch.OBJDUMP, dump_opt, arch.OBJ, arch.ASM_D)
        if DEBUG_ENABLE:
            print "        %s" % cmd
        os.system(cmd)
        if DEBUG_ENABLE:
            print "  5.  Clean up"
        cmd = "rm -rf %s %s %s" % (TMPFILE, arch.BC, arch.OBJ)
        if DEBUG_ENABLE:
            print "        %s\n" % cmd
        # os.system(cmd)
    if DISABLE_SSE_LEARN:
        generate_internal(cfile, guest, OPT_guest)
    else:
        generate_internal(cfile, guest, "-O0")
    generate_internal(cfile, host, OPT_host)


def cleanup_input_files(cfile):
    cmd = "rm -rf %s %s %s %s %s %s" % \
            (guest.IR, host.IR, guest.ASM_D, host.ASM_D, guest.ASM, host.ASM)
    os.system(cmd)
 
# Main function
def main(argv):
    if len(argv) < 2:
        usage()
        sys.exit(0)

    src_dir = argv[1]

    ifile = InputFile()
    ifunc = FuncInfo(ifile)
    ilearn = LearnProcess(ifunc)

    #os.chdir(src_dir);
    for root, subdirs, files in os.walk(src_dir):
        for tfile in files:
            if not tfile.endswith(".c") and not tfile.endswith(".cpp") and \
               not tfile.endswith(".cc"):
                continue
            #if not tfile.endswith(".cpp"):
            #    continue
            if LINE_MODE and tfile != FILE_WANTED:
                continue

            if root[-1] == '/':
                cfile = "%s%s" % (root, tfile)
            else:
                cfile = "%s/%s" % (root, tfile)
                root += '/'
            if DEBUG_ENABLE:
                print "learning from source file: %s" % cfile

            if PROFILE_ENABLE:
                start_time = time.time()
            generate_input_files(cfile)
            if PROFILE_ENABLE:
                end_time = time.time()
                global generation_time
                generation_time = generation_time + (end_time - start_time)

            ifile.set_src_file(root, tfile)
        
            for i in range(0, len(ifile.guest_asm_dump)):
                line = ifile.guest_asm_dump[i]
                if ">:" in line:
                    func = re.search ("<(.+?)>:\n", line)
                    if func:
                        func_name = func.group(1)
                        ifunc.reset()
                        ifunc.extract_func(func_name)
                        learn(ifunc, ilearn)
                    else:
                        print("Error in extracting function name:", line)

            if not LINE_MODE:
                print "remember recover it!\n"
                #cleanup_input_files(cfile)

            #print "statistics for source file: %s" % cfile
    print "====\ntotal: %d" % total_line
    print "===="
    print "guest call: %d, guest multi branch: %d, guest pre post: %d, guest null line: %d, guest_cond_exec: %d" % \
           (guest_call_line, guest_multi_branch, guest_pre_post, guest_null_line, guest_cond_exec)
    print "host call: %d, host multi branch: %d, host null line: %d, host sse instrcution: %d" % \
           (host_call_line, host_multi_branch, host_null_line, host_sse_instruction)
    print "rule candidate: %d" % rule_candidate
    print "unique rule candidate: %d" % len(ilearn.candidate_rules)
    print "===="
    print "rule learned: %d" % rule_learned
    print "rule give up due to different var numbers: %d" % rule_give_up_diff_var_num
    print "rule give up due to different var names: %d" % rule_give_up_diff_var_name
    print "rule give up due to unable to setup intial mapping: %d" % rule_give_up_initial_mapping
    print "rule give up due to failed verification: %d" % (rule_give_up_failed_verification + rule_give_up_failed_generalization)
    #print "rule give up due to failed generalization: %d\n" % rule_give_up_failed_generalization
    print "===="
    print "failed verification due to memory address different: %d" % failed_verification_mem_addr_diff
    print "failed verification due to memory content different: %d" % failed_verification_mem_cont_diff
    print "failed verification due to branch condition different: %d" % failed_verification_branch_cond
    print "failed verification due to register conentent different: %d" % (failed_verification_reg_diff + rule_give_up_failed_generalization)
    print "failed verification due to no result: %d" % failed_verification_no_result
    print "failed verification due to crash: %d" % failed_verification_crash

    print "====\nUnique translation rules learned: %d\n====" % len(ilearn.translation_rules)
    if PROFILE_ENABLE:
        print "generation time: %s seconds" % generation_time
        print "verification time: %s seconds\n====" % verification_time
    if not LINE_MODE: 
        ilearn.dump_translation_rules()

if __name__ == "__main__":
    main(sys.argv)
