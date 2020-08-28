import re
import copy
import sys

ARCH_STR = "arm"

CC = "/home/ppi/dbt/llvmArm-build/bin/clang"
LC = "/home/ppi/dbt/llvmArm-build/bin/llc"
BC = "arm_bc"
IR = "arm_ir"
ASM = BC + ".s"
ASM_D = BC + "_dump.s"
OBJ = BC + ".o"

AS = "/usr/bin/arm-linux-gnueabi-as"
OBJDUMP = "/usr/bin/objdump"

ARM_DEBUG_ENABLE = 0

class Reg_Info:
    def __init__(self):
        self.name = ""
        self.dk = "" # def or kill from LLVM IR
        self.live_in_acc = False # if this access is a live in access
        self.last_def = False # if this definition is the last one

class Scale_Info:
    def __init__(self):
        self.typ = ""           # reg or imm
        self.shift = ""         # lsl, asl, lsr, asr, ror, rrx
        self.reg = Reg_Info()   # scale is a register
        self.val = ""           # scale is an immediate
        self.val_para = ""      # parameterized shift value: imm_xxx
        self.para_flag = False  # if this immediate has been parameterized

class Reg_Opd:
    def __init__(self):
        self.reg = Reg_Info()
        self.scale = Scale_Info()

class Mem_Opd:
    def __init__(self):
        self.base = Reg_Info()
        self.idx = Reg_Info()
        self.scale = Scale_Info()
        self.off = ""
        self.off_para = ""      # parameterized offset value: imm_xxx
        self.var_name = ""      # variable name of this memory location
        self.row_column = ""    # row and column number of source for this location
        self.asm_str = ""       # string of this memory in assembly code
        self.inst = ""          # points to the instruction of this mem opd
        self.before = ""        # points to this opd before generalization

class Imm_Opd:
    def __init__(self):
        self.val = ""
        self.val_para = ""      # parameterized immediate value: imm_xxx
        self.para_flag = False  # if this immediate has been parameterized

class Lab_Opd:
    def __init__(self):
        self.name = ""

class ARM_Opd:
    def __init__(self, typ, opd):
        self.typ = typ
        self.opd = opd

class ARM_Inst:
    def __init__(self):
        self.isa = "arm"
        self.pc = ""        # start from 0x10000
        self.asm = ""       # line of assembly code
        self.ir = ""        # line of LLVM IR
        self.cc = ""        # condition code
        self.opc = ""       # opcode
        self.opd_list = []  # operand list
        self.binary = ""    # binary (hex) of this instruction

inst_list = [] # list of instructions
var_list = {} # list of variables, var_name -> memory_operand

def extract_cc(opc_str):
    cc = opc_str[-2:]
    if cc == "eq" or cc == "ne" or cc == "cs" or cc == "cc" or \
       cc == "mi" or cc == "pl" or cc == "vs" or cc == "vc" or \
       cc == "hi" or cc == "ls" or cc == "ge" or cc == "lt" or \
       cc == "gt" or cc == "le":
        return cc
    else:
        return "al"

def parse_opcode(inst, line_asm, idx):
    opc_str = ""
    while line_asm[idx] != ' ' and line_asm[idx] != '\t':
        opc_str += line_asm[idx]
        idx += 1
    inst.cc = extract_cc(opc_str)
    if inst.cc != "al": # have condition code
        opc_str = opc_str[:-2]
    inst.opc = opc_str
    #print "== opc: %s" % opc_str
    while line_asm[idx] == ' ' or line_asm[idx] == '\t':
        idx += 1
    return idx

def get_dk_info(reg_str, line_ir, flag):
    pattern = "\%" + (reg_rename_r(reg_str)).upper() + "<(.+?)>"
    dk_list = re.findall(pattern, line_ir)
    if (len(dk_list) == 0): # didn't find def/kill info, potentially live after this reference
        return "live"
    elif (len(dk_list) == 1): # just found one
        return dk_list[0]
    elif (len(dk_list) == 2) or (len(dk_list) == 3): # more than one found
        if flag:
            return dk_list[0]
        else:
            return dk_list[1]
    else:
        print "[ARM] Error: too many matchings found: %d" % len(dk_list)
        return "error"

def get_reg_info(reg_info, line_asm, idx, line_ir, flag):
    reg_str = ""
    while idx < len(line_asm) and line_asm[idx] != ',' and line_asm[idx] != ']' and \
          line_asm[idx] != ' ' and line_asm[idx] != '\t':
        reg_str += line_asm[idx]
        idx += 1
    reg_info.name = reg_rename(reg_str)
    # get def/kill info for this reg from LLVM IR
    reg_info.dk = get_dk_info(reg_str, line_ir, flag)

    # skip the following ',' and ' '
    while idx < len(line_asm) and (line_asm[idx] == ',' or line_asm[idx] == ' ' or line_asm[idx] == '\t'):
        idx += 1
    return idx

def next_const_index(const_idx):
    return str(int(const_idx) + 1).zfill(3)

def parse_scale(scale, line_asm, idx, line_ir, flag):
    f3c = line_asm[idx:idx+3]
    if f3c == "lsl" or f3c == "lsr" or f3c == "asr" or \
       f3c == "ror" or f3c == "rrx":
        scale.shift = f3c
        idx += 4 # skip f3c and ' '

        # parse scale value
        fc = line_asm[idx]
        if fc == 'r': # scale value is a register
            scale.typ = "reg"
            idx = get_reg_info(scale.reg, line_asm, idx, line_ir, flag)
        elif fc == '#': # scale value is an immediate            
            imm_str = ""
            idx += 1 # skip '#'
            while idx < len(line_asm):
                if line_asm[idx] == ' ' or line_asm[idx] == '\t' or \
                  line_asm[idx] == ']' or line_asm[idx] == '\n':
                    break
                imm_str += line_asm[idx]
                idx += 1
            scale.typ = "imm"
            scale.val = imm_str
        elif ARM_DEBUG_ENABLE:
            print "Error: unsupported scale type operand in arm"
    return idx

def get_mem_var_name(line_ir):
    var_name = ""
    substr = re.search("[1248]\[[\%\@]*(.+?)\]((\(tbaa=\![0-9]+\))|( dbg)|(\(align=[1248]\)))", line_ir)
    if substr:
        var_name = substr.group(1)
    elif ARM_DEBUG_ENABLE:
        print "[ARM] Warnning: cannot find var name from this ir:\n%s" % line_ir
    # We also try to get the row and column number for this memory variable, in
    #   case LLVM generates different variable names for guest and host
    row_column = ""
    pattern = "dbg:.+\.c[cp{2}]*:([0-9]+):([0-9]+)"
    substr = re.search(pattern, line_ir)
    if substr:
        row_column = substr.group(1) + ":" + substr.group(2)
    elif ARM_DEBUG_ENABLE:
        print "[ARM] Warnning: cannot find row and column number for this ir:\n%s" % line_ir
    return var_name, row_column

def get_mem_asm_str (line_asm):
    asm_str = ""
    substr = re.search("(\[.+?\])", line_asm)
    if substr:
        asm_str = substr.group(1)
    elif ARM_DEBUG_ENABLE:
        print "[ARM] Warnning: cannot find asm string from this line of asm: \n%s" % line_asm
    return asm_str

def ishexdigit(fc):
    try:
        int(fc, 16)
        return True
    except ValueError:
        return False

def parse_operand(inst, line_asm, idx, line_ir, const_idx):
    only_one_label = True
    line_asm_len = len(line_asm)
    memory_operand = "" # used to record memory operand in this instruction
    while idx < line_asm_len:
        fc = line_asm[idx]
        if fc == 'r' or fc == 's' or fc == 'i' or fc == 'l': # register operand
            reg_opd = Reg_Opd()
            idx = get_reg_info(reg_opd.reg, line_asm, idx, line_ir, \
                               (len(inst.opd_list) == 0))

            while idx < line_asm_len and (line_asm[idx] == ',' or line_asm[idx] == ' '):
                idx += 1

            # check if this reg has scale and parse it if yes
            if line_asm_len - idx > 3:
                idx = parse_scale(reg_opd.scale, line_asm, idx, line_ir, \
                                 (len(inst.opd_list) == 0))
                if reg_opd.scale.typ == "imm":
                    reg_opd.scale.val_para = "imm_" + const_idx # parameterize this immediate
                    const_idx = next_const_index(const_idx)

            inst.opd_list.append(ARM_Opd("reg", reg_opd))

        elif fc == '[': # memory operand
            mem_opd = Mem_Opd()
            mem_opd.var_name, mem_opd.row_column = get_mem_var_name(line_ir)
            mem_opd.asm_str = get_mem_asm_str(line_asm)
            mem_opd_pre = ""
            if var_list.has_key(mem_opd.var_name):
                mem_opd_pre = var_list[mem_opd.var_name]

            idx += 1 # skip '['
            idx = get_reg_info(mem_opd.base, line_asm, idx, line_ir, \
                               (len(inst.opd_list) == 0))

            fc = line_asm[idx]
            if fc == '#': # base + offset
                off_str = ""
                idx += 1 # skip '#'
                while line_asm[idx] != ']':
                    off_str += line_asm[idx]
                    idx += 1
                mem_opd.off = off_str
                # check if we already encountered this memory address
                if mem_opd_pre != "":
                    mem_opd.off_para = mem_opd_pre.off_para
                else:
                    mem_opd.off_para = "imm_" + const_idx
                    const_idx = next_const_index(const_idx)
            elif fc == 'r' or fc == 's' or fc == 'i' or fc == 'l': # base + idx + scale
                idx = get_reg_info(mem_opd.idx, line_asm, idx, line_ir, \
                                   (len(inst.opd_list) == 0))
                # check if this reg has scale and parse it if yes
                if (line_asm[idx] != ']'):
                    idx = parse_scale(mem_opd.scale, line_asm, idx, line_ir, \
                                      (len(inst.opd_list) == 0))
                    if mem_opd.scale.val.isdigit():
                        if mem_opd_pre != "":
                            mem_opd.scale.val_para = mem_opd_pre.scale.val_para
                        else:
                            mem_opd.scale.val_para = "imm_" + const_idx
                            const_idx = next_const_index(const_idx)
            elif fc == ']': # base
                # Hack: add artificial offset to improve match probability
                mem_opd.off = '0';
                if mem_opd_pre != "":
                    mem_opd.off_para = mem_opd_pre.off_para
                else:
                    mem_opd.off_para = "imm_" + const_idx
                    const_idx = next_const_index(const_idx)
                mem_opd.asm_str = mem_opd.asm_str.replace("]", ",#0]")
            memory_operand = mem_opd
            inst.opd_list.append(ARM_Opd("mem", mem_opd))
            idx += 1 # skip ']'
            if idx < line_asm_len - 1 and line_asm[idx] == '!': # has pre index
                idx += 1
            if idx < line_asm_len - 1 and line_asm[idx] == ',': # has post index
                idx += 1
        elif fc == '#' or fc == '.': # immediate or label operand
            idx += 1 # skip '#' or "."
            opd_str = ""
            while idx < line_asm_len and line_asm[idx] != ' ' and line_asm[idx] != '\t':
                opd_str += line_asm[idx]
                idx += 1
            if fc == '#':
                imm_opd = Imm_Opd()
                imm_opd.val = opd_str
                imm_opd.val_para = "imm_" + const_idx
                const_idx = next_const_index(const_idx)
                inst.opd_list.append(ARM_Opd("imm", imm_opd))
            else:
                if only_one_label:
                    lab_opd = Lab_Opd()
                    lab_opd.name = "Label"
                    inst.opd_list.append(ARM_Opd("lab", lab_opd))
                    only_one_label = False
                elif ARM_DEBUG_ENABLE:
                    print "[ARM] unsupported: too many labels"
            idx += 1
        elif fc == '{' or fc == '}':
            idx += 1
        elif ishexdigit(fc): # this is a label
            if only_one_label:
                lab_opd = Lab_Opd()
                lab_opd.name = "Label"
                inst.opd_list.append(ARM_Opd("lab", lab_opd))
                only_one_label = False
            elif ARM_DEBUG_ENABLE:
                print "[ARM] unsupported: too many labels"
            while idx < line_asm_len and ishexdigit(line_asm[idx]):
                idx += 1
        else:
            if ARM_DEBUG_ENABLE:
                print "== Error to parse this asm line (fc: %c): %s" % (fc, line_asm)
            return memory_operand, const_idx

    return memory_operand, const_idx

def parse_inst_list(asm, binary, ir):
    const_idx = "000"
    inst_list = []
    var_list = {}
    pc = "0x10000"
    for i in range(0, len(asm)):
        line_asm = asm[i]
        line_binary = binary[i]
        line_ir = ir[i]
        
        inst = ARM_Inst()
        inst.pc = pc
        inst.asm = line_asm
        inst.ir = line_ir
        inst.binary = line_binary
        pc = hex(int(pc, 0) + 0x4)

        #print "==== [arm] parse inst: %s" % inst.asm

        idx = 0
        while(line_asm[idx] == ' ' or line_asm[idx] == '\t'):
            idx += 1

        # 1. parse opcode
        idx = parse_opcode(inst, line_asm, idx)

        # 2. parse operand and return memory operand if there is one
        mem_opd, const_idx = parse_operand(inst, line_asm, idx, line_ir, const_idx)

        #print "== number of operands: %d" % len(inst.opd_list)
        if mem_opd != "":
            mem_opd.inst = inst
            var_name = mem_opd.var_name
            if var_list.has_key(var_name): # just add this pc to the list
                (mem_opd, pc_list) = var_list[var_name]
                pc_list.append(inst.pc)
            else: # add this var to var list
                pc_list = [inst.pc]
                var_list[var_name] = (mem_opd, pc_list)

        inst_list.append(inst)

    return inst_list, var_list

def print_inst_silent(inst, flag):
    inst_str = ""
    if flag:
        inst_str += "%s" % inst.pc
    opc = ""
    if inst.cc != "al":
        opc = inst.opc + inst.cc
    else:
        opc = inst.opc
    inst_str += "\t%s " % opc
    for opd in inst.opd_list:
        if opd.typ == "reg":
            reg_opd = opd.opd
            reg_str = reg_opd.reg.name
            if flag:
                reg_str += "<%s, live-in-acc: %s, last-def: %s>" % \
                    (reg_opd.reg.dk, reg_opd.reg.live_in_acc, reg_opd.reg.last_def)
            if reg_opd.scale.typ == "reg": # this register has a register scale
                reg_str += ', ' + reg_opd.scale.shift + ' ' + reg_opd.scale.reg.name
                if flag:
                    reg_str += "<%s, live-in-acc: %s, last-def: %s>" % \
                        (reg_opd.scale.reg.dk, reg_opd.scale.reg.live_in_acc, reg_opd.scale.reg.last_def)
            elif reg_opd.scale.typ == "imm": # this register has a immediate scale:
                reg_str +=  ', ' + reg_opd.scale.shift
                if reg_opd.scale.para_flag:
                    reg_str += ' #' + reg_opd.scale.val_para
                else:
                    #print "======================%s" % reg_opd.scale.val
                    reg_str += ' #' + reg_opd.scale.val
                if flag:
                    reg_str += '(' + reg_opd.scale.val_para + ')'
            inst_str += "%s, " % reg_str
        elif opd.typ == "mem":
            mem_opd = opd.opd
            mem_str = "[%s" % mem_opd.base.name
            if flag:
                mem_str += "<%s, live-in-acc: %s, last-def: %s>" % \
                    (mem_opd.base.dk, mem_opd.base.live_in_acc, mem_opd.base.last_def)
            if mem_opd.off != "":
                if flag:
                    mem_str += ", #%s(%s)" % (mem_opd.off, mem_opd.off_para)
                else:
                    mem_str += ", #%s" % mem_opd.off_para
            if mem_opd.idx.name != "":
                mem_str += ", " + mem_opd.idx.name
                if flag:
                    mem_str += "<%s, live-in-acc: %s, last-def: %s>" % \
                        (mem_opd.idx.dk, mem_opd.idx.live_in_acc, mem_opd.idx.last_def)
            if mem_opd.scale.typ == "reg":
                mem_str += ", " + mem_opd.scale.shift + " " + mem_opd.scale.reg.name
                if flag:
                    mem_str += "<%s, live-in-acc: %s, last-def: %s>" % \
                        (mem_opd.scale.reg.dk, mem_opd.scale.reg.live_in_acc, mem_opd.scale.reg.last_def)
            if mem_opd.scale.typ == "imm":
                mem_str += ", " + mem_opd.scale.shift + " ";
                if flag:
                    mem_str += mem_opd.scale.val + '(' + mem_opd.scale.val_para + ')'
                else:
                    if mem_opd.scale.para_flag:
                        mem_str += "#" + mem_opd.scale.val_para
                    else:
                        mem_str += "#" + mem_opd.scale.val
            mem_str += "]"
            if flag:
                mem_str += "(var: %s)" % mem_opd.var_name
            inst_str += "%s, " % mem_str
        elif opd.typ == "imm":
            imm_opd = opd.opd
            imm_str = ""
            if imm_opd.para_flag:
                imm_str += "#%s" % imm_opd.val_para
            else:
                imm_str += "#%s" % imm_opd.val
            if flag:
                imm_str += "(%s)" % imm_opd.val_para
            inst_str += "%s, " % imm_str
        elif opd.typ == "lab":
            lab_opd = opd.opd
            #print ".%s," % lab_opd.name,
            inst_str += "#L0, "
    inst_str = inst_str[0:-2] # erase ", "
    return inst_str

def print_inst(inst, flag):
    inst_str = print_inst_silent(inst, flag)
    print inst_str
    return inst_str

def reg_rename_r(reg):
    if reg == "r14":
        return "lr"
    else:
        return reg

def reg_rename(reg):
    if reg == "fp":
        return "r11"
    elif reg == "ip":
        return "r12"
    elif reg == "sp":
        return "r13"
    elif reg == "lr":
        return "r14"
    elif reg == "pc":
        return "r15"
    else:
        return reg

def analyze_register_liveness(asm_inst_list):
    live_in_reg = []
    def_reg = []
    use_reg = []
    last_def = {}
    def check(reg_info, live_in_reg, def_reg, last_def):
        reg = reg_rename(reg_info.name)
        dk = reg_info.dk
        if ("kill" in dk or "live" in dk): # this register is used
            if not reg in use_reg:
                use_reg.append(reg)
            if not reg in def_reg:
                reg_info.live_in_acc = True
                if not reg in live_in_reg:
                    live_in_reg.append(reg)
        if "def" in dk:
            last_def[reg] = reg_info
            if not reg in def_reg:
                def_reg.append(reg)
        return live_in_reg, def_reg, use_reg
    for inst in asm_inst_list:
        for opd in reversed(inst.opd_list):
            if opd.typ == "reg":
                reg_opd = opd.opd
                live_in_reg, def_reg, use_reg = \
                    check(reg_opd.reg, live_in_reg, def_reg, last_def)
                scale = reg_opd.scale
                if scale.typ == "reg":
                    live_in_reg, def_reg, use_reg = \
                        check(scale.reg, live_in_reg, def_reg, last_def)
            elif opd.typ == "mem":
                mem_opd = opd.opd
                live_in_reg, def_reg, use_reg = \
                    check(mem_opd.base, live_in_reg, def_reg, last_def)
                reg = mem_opd.idx.name
                if reg != "":
                    live_in_reg, def_reg, use_reg = \
                        check(mem_opd.idx, live_in_reg, def_reg, last_def)
    # set last definition of each defined register
    for reg,reg_info in last_def.iteritems():
        reg_info.last_def = True

    live_in_reg.reverse()
    return live_in_reg, def_reg, use_reg

def backtrack_live_in_access(inst_list, inst_idx, reg_name, imm_para):
    for i in reversed(range(0, inst_idx)):
        inst = inst_list[i]
        for j in range(0, len(inst.opd_list)):
            opd = inst.opd_list[j]
            if opd.typ != "reg":
                continue
            reg_i = opd.opd.reg
            if reg_i.name != reg_name:
                continue
            if not "def" in reg_i.dk:
                continue

            # We found a definition to this register
            if inst.opc == "ldr" or inst.opc == "ldrh" or inst.opc == "ldrc":
                if inst.opd_list[j+1].typ == "mem":
                    mem_opd = inst.opd_list[j+1].opd
                    return "mem-" + mem_opd.var_name
            elif inst.opc == "mov":
                if inst.opd_list[j+1].typ != "imm":
                    if ARM_DEBUG_ENABLE:
                        print "[ARM] unsupported operand type for MOV when normalize memory address"
                    return ""
                imm_opd = inst.opd_list[j+1].opd
                imm_opd.para_flag = True
                imm_para.append([inst, imm_opd.val, imm_opd.val_para])
                return imm_opd.val_para
            elif inst.opc == "add":
                # The first operand is the defined register, so we use the remaining two
                opd1 = inst.opd_list[1]
                opd2 = inst.opd_list[2]
                if opd1.typ != "reg" or opd2.typ != "reg":
                    if ARM_DEBUG_ENABLE:
                        print "[ARM] unsupported operand type for ADD when normalize memory address"
                else:
                    reg_opd1 = opd1.opd
                    reg_opd2 = opd2.opd
                    def convert_reg_to_str(reg_name, scale):
                        rstr = reg_name
                        scale_typ = scale.typ
                        scale_shift = scale.shift
                        if scale_typ == "":
                            return rstr
                        if scale_shift != "lsl":
                            if ARM_DEBUG_ENABLE:
                                print "[ARM] unsupported non lsl scale for ADD when normalize memory address"
                        if scale_typ == "reg":
                            if ARM_DEBUG_ENABLE:
                                print "[ARM] unsupported non immediate scale for ADD when normalize memory address"
                        scale_val = scale.val
                        rstr = "LSH(" + rstr + ',' + scale.val_para + ')'
                        scale.para_flag = True
                        imm_para.append([inst, scale.val, scale.val_para])
                        return rstr

                    if (not reg_opd1.reg.live_in_acc):
                        str1 = backtrack_live_in_access(inst_list, i, reg_opd1.reg.name, imm_para)
                        if "mem" not in str1:
                            if ARM_DEBUG_ENABLE:
                                print "[ARM] unsupported non live in access for ADD when normalize memory address"
                    else:
                        str1 = convert_reg_to_str(reg_opd1.reg.name, reg_opd1.scale)
                    if (not reg_opd2.reg.live_in_acc):
                        str2 = backtrack_live_in_access(inst_list, i, reg_opd2.reg.name, imm_para)
                    else:
                        str2 = reg_opd2.reg.name
                    str2 = convert_reg_to_str(str2, reg_opd2.scale)
                    return "ADD(" + str1 + ',' + str2 + ')'
            elif inst.opc == "orr":
                # The first operand is the destination, so we use the remaining two
                opd1 = inst.opd_list[1]
                opd2 = inst.opd_list[2]
                if opd1.typ != "reg" or opd2.typ != "imm":
                    if ARM_DEBUG_ENABLE:
                        print "[ARM] unsupported operand type for ORR when normalize memory address"
                    return ""
                if (not opd1.opd.reg.live_in_acc):
                    str1 = backtrack_live_in_access(inst_list, i, opd1.opd.reg.name, imm_para)
                    if "imm" not in str1:
                        if ARM_DEBUG_ENABLE:
                            print "[ARM] unsupported non live in access for ORR when normalize memory address"
                else:
                    return ""
                str2 = opd2.opd.val_para
                opd2.opd.para_flag = True
                imm_para.append([inst, opd2.opd.val, opd2.opd.val_para])
                return 'ORR(' + str1 + ',' + str2 + ')'
            elif ARM_DEBUG_ENABLE:
                print "[ARM] unsupported opcode when noramlize memory address: %s" % inst.opc
    return ""

# normalize memory location to base + idx * scale + off
# only live-in registers and memory variables are allowed after normalization
def normalize_memory_location(inst_list, mem_opd, normalized_mloc, imm_para):
    base = ""
    # check if the base is a live in access
    if mem_opd.base.live_in_acc:
        base = mem_opd.base.name
    else:
        inst_idx = inst_list.index(mem_opd.inst)
        base = backtrack_live_in_access(inst_list, inst_idx, mem_opd.base.name, imm_para)
        #print "=============[ARM] base: %s" % base

    # check if the idx is a live in access
    idx = ""
    if mem_opd.idx.name != "":
        if mem_opd.idx.live_in_acc:
            idx = mem_opd.idx.name
        else:
            inst_idx = inst_list.index(mem_opd.inst)
            idx = backtrack_live_in_access(inst_list, inst_idx, mem_opd.idx.name, imm_para)

    scale = ""
    if mem_opd.scale.typ == "imm":
        if mem_opd.scale.shift == "lsl":
            scale = "\'(1<<%s)\'" % mem_opd.scale.val_para
        elif ARM_DEBUG_ENABLE:
            print "[ARM] unsupported shift in memory operand: %s" % mem_opd.asm_str
    elif mem_opd.scale.typ == "reg":
        if ARM_DEBUG_ENABLE:
            print "[ARM] unsupported register scale in memory operand: %s" % mem_opd.asm_str

    off = ""
    if mem_opd.off != "":
        off = mem_opd.off_para

    # do flat
    base_reg = reg_rename(base)
    if base_reg != "" and base_reg[0] != 'r' and base_reg[0] != 'm':
        if idx == "":
            first_comma = base.find(',')
            normalized_mloc.base = base[4:first_comma]
            if not "LSH" in base: # No scale
                last_parenthese = base.rfind(')')
                normalized_mloc.idx = base[first_comma+1:last_parenthese]
            else: # Has scale
                last_comma = base.rfind(',')
                normalized_mloc.idx = base[first_comma+5:last_comma]
                normalized_mloc.scale = "\'(1<<%s)\'" % base[last_comma+1:last_comma+8]
        else:
            normalized_mloc.base = base
            normalized_mloc.idx = idx
            normalized_mloc.scale = scale
    elif idx != "" and idx[0] != 'r':
        if "ORR" in idx and "imm" in idx and off == "": # convert this idx register to immediate offset
            first_comma = idx.find(',')
            last_parenthese = idx.rfind(')')
            normalized_mloc.base = base
            normalized_mloc.idx = ""
            normalized_mloc.scale = scale
            off = "\'(%s|%s)\'" % (idx[4:first_comma], idx[first_comma+1:last_parenthese])
        elif "LSH" in idx and scale == "": # convert this idx to scale
            first_comma = idx.find(',')
            last_parenthese = idx.rfind(')')
            normalized_mloc.base = base
            normalized_mloc.idx = idx[4:first_comma]
            normalized_mloc.scale = "\'(1<<%s)\'" % idx[first_comma+1:last_parenthese]
    else:
        normalized_mloc.base = base
        normalized_mloc.idx = idx
        normalized_mloc.scale = scale
    normalized_mloc.off = off

# Search a live in register with a similar opc to the host opc
def search_live_in_reg_opc(inst_list, host_opc):
    guest_opc = ""
    if host_opc == "xorl":
        guest_opc = "eor"
    if guest_opc == "":
        return ""
    for inst in inst_list:
        if inst.opc != guest_opc:
            continue
        for opd in inst.opd_list:
            if opd.typ != "reg":
                continue
            if opd.opd.reg.live_in_acc:
                return opd.opd.reg.name
    return ""

# Extract the instruction from the asm line
def extract_inst(asm_line):
    i_asm = ""
    substr = re.search("\t(.+\t.+)@", asm_line)
    if substr:
        i_asm = '\'' + substr.group(1).rstrip() + '\''
    else:
        print "[ARM] Error: cannot extract instruction from this line: %s" % asm_line
    return i_asm

def get_unmapped_immediate(asm_inst_list):
    unmapped_imm = []
    for inst in asm_inst_list:
        if "lsr" in inst.opc or "lsl" in inst.opc:
            # Do NOT try to parameterize these immediates 
            #  because it will fail the verification.
            continue
        for opd in inst.opd_list:
            if opd.typ == "imm" and not opd.opd.para_flag:
                unmapped_imm.append([inst, int(opd.opd.val, 0), opd.opd.val_para, opd, False])
            elif opd.typ == "reg" and opd.opd.scale.typ == "imm" and \
                 not opd.opd.scale.para_flag and opd.opd.scale.val.isdigit():
                # register has immediate scale
                unmapped_imm.append([inst, int(opd.opd.scale.val, 0), opd.opd.scale.val_para, opd, True])
    return unmapped_imm

def set_unmapped_imm_para_flag(opd):
    if opd.typ == "imm" and not opd.opd.para_flag:
        opd.opd.para_flag = True
    elif opd.typ == "reg" and opd.opd.scale.typ == "imm" and \
         not opd.opd.scale.para_flag and opd.opd.scale.val.isdigit():
        opd.opd.scale.para_flag = True

# Guess a binary operation for guest immediates
# add -> '+'
# orr -> '|'
def guess_imm_operation(unmapped_imm):
    for ui in unmapped_imm:
        inst_opc = ui[0].opc
        if "add" in inst_opc:
            return "+"
        if "orr" in inst_opc:
            return "|"
    return "+"

def used_after_last_definition(reg, asm_inst_list):
    def reg_is_used(dk):
        if "kill" in dk or "live" in dk:
            return True
        return False
    flag = False
    for inst in asm_inst_list:
        for opd in reversed(inst.opd_list):
            if opd.typ == "reg" and opd.opd.reg.name == reg:
                if flag and reg_is_used(opd.opd.reg.dk):
                    return True
                if opd.opd.reg.last_def:
                    flag = True
            elif flag and opd.typ == "mem":
                if flag:
                    if reg_is_used(opd.opd.base.dk) or \
                       (opd.opd.idx.name != "" and reg_is_used(opd.opd.idx.dk)):
                        return True
    return False

def get_generalized_reg(reg, idx, reg_gen_mapping):
    reg_str = ""
    reg = reg_rename(reg)
    if reg_gen_mapping.has_key(reg):
        reg_str = reg_gen_mapping[reg]
    else:
        reg_str = "reg%d" % idx
        idx += 1
        reg_gen_mapping[reg] = reg_str
    return reg_str, idx

def same_mem_opd(opd1, opd2):
    '''print "---------------"
    print "base name: |%s| vs. |%s|" % (opd1.base.name, opd2.base.name)
    print "idx name: |%s| vs. |%s|" % (opd1.idx.name, opd2.idx.name)
    print "scale typ: |%s| vs. |%s|" % (opd1.scale.typ, opd2.scale.typ)
    print "scale val: |%s| vs. |%s|" % (opd1.scale.val, opd2.scale.val)
    print "off: |%s| vs. |%s|" % (opd1.off, opd2.off)'''
    return opd1.base.name == opd2.base.name and opd1.idx.name == opd2.idx.name and \
           opd1.scale.typ == opd2.scale.typ and opd1.scale.reg.name == opd2.scale.reg.name and \
           opd1.scale.val == opd2.scale.val and opd1.off == opd2.off

def generalize_inst(asm_inst):
    reg_gen_mapping = {}
    mem_gen_mapping = {}
    reg_idx = 0
    off_idx = 0
    for inst in asm_inst:
        for opd in inst.opd_list:
            if opd.typ == "reg":
                reg_opd = opd.opd
                reg_str, reg_idx = \
                    get_generalized_reg(reg_opd.reg.name, reg_idx, reg_gen_mapping)
                reg_opd.reg.name = reg_str
                scale = reg_opd.scale
                if scale.typ == "reg":
                    reg_str, reg_idx = \
                        get_generalized_reg(scale.reg.name, reg_idx, reg_gen_mapping)
                    scale.reg.name = reg_str
            elif opd.typ == "mem":
                mem_opd = opd.opd
                if mem_opd.scale.typ == "reg":
                    print "[ARM] Unsupported register scale for memory operand"
                if mem_gen_mapping.has_key(mem_opd.var_name):
                    mem_g_opd = mem_gen_mapping[mem_opd.var_name]
                    mem_opd.base.name = mem_g_opd.base.name
                    mem_opd.idx.name = mem_g_opd.idx.name
                    mem_opd.off = mem_g_opd.off
                    mem_opd.off_para = mem_g_opd.off_para
                    if mem_opd.scale.typ == "reg":
                        print "[ARM] Unsupported register scale for memory operand"
                    mem_opd.scale.val = mem_g_opd.scale.val
                    mem_opd.scale.val_para = mem_g_opd.scale.val_para
                else:
                    mem_opd.before = copy.deepcopy(mem_opd)
                    # Check if this memory operand use the same register and offset as
                    # another memory operand but different varaible names
                    matched = False
                    '''for var_name, mem_g_opd in mem_gen_mapping.items():
                        if same_mem_opd(mem_g_opd.before, mem_opd):
                            mem_opd.base.name = mem_g_opd.base.name
                            mem_opd.idx.name = mem_g_opd.idx.name
                            mem_opd.off = mem_g_opd.off
                            mem_opd.off_para = mem_g_opd.off_para
                            if mem_opd.scale.typ == "reg":
                                print "[ARM] Unsupported register scale for memory operand"
                            mem_opd.scale.val = mem_g_opd.scale.val
                            mem_opd.scale.val_para = mem_g_opd.scale.val_para
                            matched = True
                            break'''
                    if not matched:
                        reg_str, reg_idx = \
                            get_generalized_reg(mem_opd.base.name, reg_idx, reg_gen_mapping)
                        mem_opd.base.name = reg_str
                        if mem_opd.idx.name != "":
                            reg_str, reg_idx = \
                                get_generalized_reg(mem_opd.idx.name, reg_idx, reg_gen_mapping)
                            mem_opd.idx.name = reg_str
                        #if mem_opd.off != "":
                        #    mem_opd.off = "imm_%03d" % off_idx
                        #    off_idx += 1
                        #if mem_opd.scale.typ != "":
                        #    print "Error: unsupported generalization of scale register"
                    mem_gen_mapping[mem_opd.var_name] = mem_opd
    return asm_inst, reg_gen_mapping, mem_gen_mapping
