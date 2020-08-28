import re
import copy
import sys

ARCH_STR = "x86"

CC = "/home/ppi/dbt/build/bin/clang"
LC = "/home/ppi/dbt/build/bin/llc"
BC = "x86_bc"
IR = "x86_ir"
ASM = BC + ".s"
ASM_D = BC + "_dump.s"
OBJ = BC + ".o"

AS = "/usr/bin/as"
OBJDUMP = "/usr/bin/objdump"

x86_DEBUG_ENABLE = 1

class Reg_Info:
    def __init__(self):
        self.name = ""
        self.dk = "" # def or kill
        self.live_in_acc = False # if this access is a live in access
        self.last_def = False # if this definition is the last one 

class Reg_Opd:
    def __init__(self):
        self.reg = Reg_Info()

class Mem_Opd:
    def __init__(self):
        self.base = Reg_Info()
        self.idx = Reg_Info()
        self.scale = "" # possible values for x86: 1, 2, 4, 8
        self.scale_para = ""         # parameterized scale: imm_xxx
        self.scale_para_flag = False # if the scale has bee parameterized
        self.disp = ""
        self.disp_para = ""         # parameterized displacement: imm_xxx
        self.disp_para_flag = False # if the displacement has been parameterized
        self.var_name = ""          # variable name of this memory location
        self.row_column = ""        # row and column number of source for this location
        self.asm_str = ""           # string of this memory in assembly code
        self.inst = ""              # points the instruction of this mem opd

class Imm_Opd:
    def __init__(self):
        self.val = ""
        self.val_para = ""          # parameterized immediate value: imm_xxx
        self.para_flag = False  # if this immediate has been parameterized

class Lab_Opd:
    def __init__(self):
        self.name = ""

class x86_Opd:
    def __init__(self, typ, opd):
        self.typ = typ
        self.opd = opd

class x86_Inst:
    def __init__(self):
        self.isa = "x86"
        self.pc = ""        # start from 0x8048000
        self.asm = ""       # line of asm
        self.ir = ""        # line of ir
        self.opc = ""       # opcode
        self.opd_list = []  # operand list
        self.binary = ""    # assembled binary code

inst_list = []
var_list = {}

def parse_opcode(inst, line_asm, idx):
    opc_str = ""
    while line_asm[idx] != ' ' and line_asm[idx] != '\t' and line_asm[idx] != '\n':
        opc_str += line_asm[idx]
        idx += 1
        if idx >= len(line_asm):
            inst.opc = opc_str
            return idx
    inst.opc = opc_str
    while line_asm[idx] == ' ' or line_asm[idx] == '\t':
        idx += 1
    return idx

def get_dk_info(reg_str, line_ir, flag):
    pattern = "\%" + reg_str.upper() + "<(.+?)>"
    dk_list = re.findall(pattern, line_ir)
    if (len(dk_list) == 0): # didn't find def/kill info, potentially live after this reference
        return "live"
    elif (len(dk_list) == 1): # just found one
        return dk_list[0]
    elif (len(dk_list) == 2): # found two
        if flag:
            dk_i = dk_list[1]
        else:
            dk_i = dk_list[0]
        #print "==================dk_i: %s" % dk_i
        if "tied" in dk_list[0] and "tied" in dk_list[1]:
            if "def" in dk_i or "INC" in line_ir or "DEC" in line_ir or \
               "ADD" in line_ir or "XOR" in line_ir or "SHL" in line_ir or\
               "SHR" in line_ir or "OR" in line_ir:
               return "kill-def"
            else:
               return "kill"
        else:
            return dk_i
    elif (len(dk_list) == 3): # found  three, i.e., the register is uesd for source and dest
        if flag:
            dk_i = dk_list[1]
        else:
            dk_i = dk_list[0]
        if "undef" in dk_i or "tied" in dk_i:
            return "kill"
        elif "def" in dk_i:
            return "def"
        elif x86_DEBUG_ENABLE:
            print "[x86] Error: cannot get dk information for reg: %s" % reg_str
    elif x86_DEBUG_ENABLE:
        print "[x86] Error: too many matchings found (%d) for reg: %s" % (len(dk_list), reg_str)

def is_first_ref(opd_list, reg):
    for opd in opd_list:
        if opd.typ == "reg":
            if opd.opd.reg.name == reg:
                return False
        elif opd.typ == "mem":
            if opd.opd.base.name == reg or \
               opd.opd.idx.name == reg:
                return False
    return True

def get_reg_info(reg_info, line_asm, idx, line_ir, opd_list):
    reg_str = ""
    while idx < len(line_asm):
        fc = line_asm[idx]
        if fc == ',' or fc == '\n' or fc == ' ' or fc == ')' or fc == '\t':
            break
        reg_str += fc
        idx += 1
    reg_info.name = reg_str

    flag = is_first_ref(opd_list, reg_str)

    # get def/kill info for this reg from LLVM IR
    reg_info.dk = get_dk_info(reg_str, line_ir, flag)

    # skip the following ',' and ' '
    while idx < len(line_asm):
        fc = line_asm[idx]
        if fc != ',' and fc != ' ' and fc != '\t':
            break
        idx += 1
    return idx

def get_mem_var_name(line_ir):
    var_name = ""
    substr = re.search("[1248]\[[\%\@]*(.+?)\]((\(tbaa=\![0-9]+\))|( dbg)|(\(align=[1248]\)))", line_ir)
    if substr:
        var_name = substr.group(1)
    elif x86_DEBUG_ENABLE:
        print "[x86] Warnning: cannot find var name from this line of ir:\n%s" % line_ir
    # We also try to get the row and column number for this memory variable, in
    #   case LLVM generates different variable names for guest and host
    row_column = ""
    pattern = "dbg:.+\.c[cp{2}]*:([0-9]+):([0-9]+)"
    substr = re.search(pattern, line_ir)
    if substr:
        row_column = substr.group(1) + ":" + substr.group(2)
    elif x86_DEBUG_ENABLE:
        print "[x86] Warnning: cannot find row and column number for this ir:\n%s" % line_ir
    return var_name, row_column

def get_mem_asm_str(line_asm):
    asm_str = ""
    substr = re.search("((\-)*(0x)*[0-9a-f]*\(.+?\))", line_asm)
    if substr: 
        asm_str = substr.group(1)
    elif x86_DEBUG_ENABLE:
        print "[x86] Warnning: cannot find mem asm string from this line of asm: \n%s" % line_asm
    #print "==============asm_str: %s" % asm_str
    return asm_str

def parse_mem_opd(inst, line_asm, idx, line_ir, const_idx):
    mem_opd = Mem_Opd()
    if inst.opc != "leal" and inst.opc != "lea":
        mem_opd.var_name, mem_opd.row_column = get_mem_var_name(line_ir)
    mem_opd.asm_str = get_mem_asm_str(line_asm)

    global var_list
    mem_opd_pre = ""
    if var_list.has_key(mem_opd.var_name):
        mem_opd_pre = var_list[mem_opd.var_name][0]

    fc = line_asm[idx]
    if fc == '-' or fc.isdigit() or fc == 'B': # parse offset
        disp_str = ""
        while line_asm[idx] != '(':
            disp_str += line_asm[idx]
            idx += 1
        if fc == 'B':
            mem_opd.disp = '0'
        else:
            mem_opd.disp = disp_str
            if mem_opd_pre != "":
                mem_opd.disp_para = mem_opd_pre.disp_para
            else:
                mem_opd.disp_para = "imm_" + const_idx
                const_idx = next_const_index(const_idx)
    else:
        # Hack: add artificial disp to improve match probability
        mem_opd.disp = '0'
        if mem_opd_pre != "":
            mem_opd.disp_para = mem_opd_pre.disp_para
        else:
            mem_opd.disp_para = "imm_" + const_idx
            const_idx = next_const_index(const_idx)
        mem_opd.asm_str = mem_opd.asm_str.replace("(", "0(")
    idx += 2 # skip '(%'
    idx = get_reg_info(mem_opd.base, line_asm, idx, line_ir, \
                       inst.opd_list)
    if line_asm[idx] != ')': # parse idx register
        idx += 1 # skip '%'
        idx = get_reg_info(mem_opd.idx, line_asm, idx, line_ir, \
                           inst.opd_list)
    if line_asm[idx] != ')': # parse scale
        scale_str = ""
        while line_asm[idx] != ')':
            scale_str += line_asm[idx]
            idx += 1
        mem_opd.scale = scale_str
        if mem_opd_pre != "":
            mem_opd.scale_para = mem_opd_pre.scale_para
        else:
            mem_opd.scale_para = "imm_" + const_idx
            const_idx = next_const_index(const_idx)

    return mem_opd, idx, const_idx

def next_const_index(const_idx):
    return str(int(const_idx) + 1).zfill(3)

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
        if fc == '%': # register operand
            reg_opd = Reg_Opd()
            idx += 1 # skip '%'
            idx = get_reg_info(reg_opd.reg, line_asm, idx, line_ir, \
                               inst.opd_list)
            inst.opd_list.append(x86_Opd("reg", reg_opd))
        elif fc == '(' or fc == '-' or ishexdigit(fc): # memory operand or label
            if '(' in line_asm:
                mem_opd, idx, const_idx = \
                    parse_mem_opd(inst, line_asm, idx, line_ir, const_idx)
                memory_operand = mem_opd
                inst.opd_list.append(x86_Opd("mem", mem_opd))
                idx += 1 # skip ')'
            elif 'j' in inst.opc: # this is a branch label
                lab_opd = Lab_Opd()
                lab_opd.name = "Label"
                inst.opd_list.append(x86_Opd("lab", lab_opd))
                while(idx < line_asm_len and ishexdigit(line_asm[idx])):
                    idx = idx + 1
            else: # this is also a data label for relocation, treat as an immediate
                opd_str = ""
                while(idx < line_asm_len and line_asm[idx] != ',' and line_asm[idx] != '\n'):
                    opd_str += line_asm[idx]
                    idx += 1
                imm_opd = Imm_Opd()
                imm_opd.val = opd_str
                imm_opd.val_para = "imm_" + const_idx
                const_idx = next_const_index(const_idx)
                inst.opd_list.append(x86_Opd("imm", imm_opd))
                while(line_asm[idx] == ',' or line_asm[idx] == ' '):
                    idx += 1
        elif fc == '$' or fc == '.' or fc == 's': # immediate or label operand, or stderr
            if fc != 's':
                idx += 1 # skip '$' or '.'
            opd_str = ""
            while idx < line_asm_len and line_asm[idx] != ',' and line_asm[idx] != ' ' and line_asm[idx] != '\t':
                opd_str += line_asm[idx]
                idx += 1
            if fc == '$':
                imm_opd = Imm_Opd()
                imm_opd.val = opd_str
                imm_opd.val_para = "imm_" + const_idx
                const_idx = next_const_index(const_idx)
                inst.opd_list.append(x86_Opd("imm", imm_opd))
            else:
                if only_one_label:
                    lab_opd = Lab_Opd()
                    lab_opd.name = "Label"
                    inst.opd_list.append(x86_Opd("lab", lab_opd))
                elif x86_DEBUG_ENABLE:
                    print "[x86] unsupported: too many labels"
        elif fc == 'B': # Need to check if it is a memory or immediate opd
            fidx = idx
            while line_asm[fidx] != '(' and line_asm[fidx] != ',' and \
                  line_asm[fidx] != ' ' and line_asm[fidx] != '\t':
                fidx += 1
            if line_asm[fidx] == '(': # memory
                mem_opd, idx, const_idx = parse_mem_opd(inst, line_asm, idx, line_ir, const_idx)
                memory_operand = mem_opd
                inst.opd_list.append(x86_Opd("mem", mem_opd))
                idx += 1 # skip ')'
            else: # immediate
                imm_opd = Imm_Opd()
                imm_opd.val = "0"
                inst.opd_list.append(x86_Opd("imm", imm_opd))
                idx = fidx
        else:
            if x86_DEBUG_ENABLE:
                print "[x86] Error to parse inst (fc: %c):\n%s" % (fc, line_asm)
            return memory_operand, const_idx
        while idx < line_asm_len and (line_asm[idx] == ',' or line_asm[idx] == ' ' or line_asm[idx] == '\t'):
            idx += 1

    return memory_operand, const_idx

def parse_inst_list(asm, binary, ir):
    global var_list
    const_idx = "100"
    inst_list = []
    var_list = {}
    pc = "0x8048000"
    for i in range(0, len(asm)):
        line_asm = asm[i]
        line_binary = binary[i]
        line_ir = ir[i]

        inst = x86_Inst()
        inst.pc = pc
        inst.asm = line_asm
        inst.ir = line_ir
        inst.binary = line_binary
        pc = hex(int(pc, 0) + ((len(inst.binary) + 1) / 3))

        idx = 0
        while(line_asm[idx] == ' ' or line_asm[idx] == '\t'):
            idx += 1

        # 1. parse opcode
        idx = parse_opcode(inst, line_asm, idx)

        # 2. parse operand
        mem_opd, const_idx = parse_operand(inst, line_asm, idx, line_ir, const_idx)
        if mem_opd != "" and mem_opd.var_name != "":
            var_name = mem_opd.var_name
            if var_list.has_key(var_name): # just add this pc to the list
                (mem_opd, pc_list) = var_list[var_name]
                pc_list.append(inst.pc)
            else:
                pc_list = [inst.pc]
                var_list[var_name] = (mem_opd, pc_list)
            mem_opd.inst = inst

        # Immplicit operands for imul
        #if (inst.opc == "imull")
        #    inst.opd_list

        inst_list.append(inst)

    return inst_list, var_list


def print_inst_silent(inst, flag):
    inst_str = ""
    if flag:
        inst_str += "%s" % inst.pc
    inst_str += "\t%s " % inst.opc
    for opd in inst.opd_list:
        if opd.typ == "reg":
            reg_opd = opd.opd
            reg_str = reg_opd.reg.name
            if flag:
                reg_str += "<%s, live-in-acc: %s, last-def: %s>" % \
                    (reg_opd.reg.dk, reg_opd.reg.live_in_acc, reg_opd.reg.last_def)
            if reg_str.isdigit(): # This register is parametrized to 0
                inst_str += "$"
            inst_str += "%s, " % reg_str
        elif opd.typ == "mem":
            mem_opd = opd.opd
            mem_str = ""
            if mem_opd.disp != "" and mem_opd.disp_para != "0":
                if flag:
                    mem_str += "%s(%s)" % (mem_opd.disp, mem_opd.disp_para)
                elif mem_opd.disp_para_flag:
                    mem_str += "%s" % mem_opd.disp_para
                else:
                    mem_str += "%s" % mem_opd.disp
            mem_str += '(' + mem_opd.base.name
            if flag:
                mem_str += "<%s, live-in-acc: %s, last-def: %s>" % \
                    (mem_opd.base.dk, mem_opd.base.live_in_acc, mem_opd.base.last_def)
            if mem_opd.idx.name != "":
                reg_idx = mem_opd.idx
                mem_str += ", %s" % reg_idx.name
                if flag:
                    mem_str += "<%s, live-in-acc: %s, last-def: %s>" % \
                        (reg_idx.dk, reg_idx.live_in_acc, reg_idx.last_def)
                if mem_opd.scale != "":
                    if flag:
                        mem_str += ", %s(%s)" % (mem_opd.scale, mem_opd.scale_para)
                    else:
                        if mem_opd.scale_para_flag:
                            if mem_opd.scale_para != "1":
                                mem_str += ", %s" % mem_opd.scale_para
                        elif mem_opd.scale != "1":
                            mem_str += ", %s" % mem_opd.scale
            mem_str += ")"
            if flag and inst.opc != "leal":
                mem_str += "(var: %s)" % mem_opd.var_name
            inst_str += "%s, " % mem_str
        elif opd.typ == "imm":
            imm_opd = opd.opd
            if imm_opd.para_flag:
                imm_str = "$%s" % imm_opd.val_para
            else:
                imm_str = "$%s" % imm_opd.val
            if flag:
                imm_str += "(%s)" % imm_opd.val_para
            inst_str += "%s, " % imm_str
        elif opd.typ == "lab":
            lab_opd = opd.opd
            inst_str += "$L0, "
    inst_str = inst_str[0:-2] # erase ", "
    return inst_str

def print_inst(inst, flag):
    inst_str = print_inst_silent(inst, flag)
    print inst_str
    return inst_str

def reg_rename(reg):
    if reg == "ah" or reg == "al" or reg == "ax":
        return "eax"
    elif reg == "bh" or reg == "bl" or reg == "bx":
        return "ebx"
    elif reg == "ch" or reg == "cl" or reg == "cx":
        return "ecx"
    elif reg == "dh" or reg == "dl" or reg == "dx":
        return "edx"
    else:
        return reg

def analyze_register_liveness(asm_inst):
    live_in_reg = []
    def_reg = []
    use_reg = []
    last_def = {}
    def check(reg_info, live_in_reg, def_reg, last_def):
        reg = reg_rename(reg_info.name)
        print "=========dk: %s" % reg_info.dk
        dk = reg_info.dk
        if ("kill" in dk or "live" in dk or "imp-use" in dk): # this register is used
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
    for inst in asm_inst:
        print "======== %s" % inst.ir
        for opd in inst.opd_list:
            if opd.typ == "reg":
                reg_opd = opd.opd
                live_in_reg, def_reg, use_reg = \
                    check(reg_opd.reg, live_in_reg, def_reg, last_def)
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

            # we found a definition to this register
            if inst.opc == "movl" or inst.opc == "movzwl":
                opd = inst.opd_list[j-1]
                if opd.typ == "mem":
                    return "mem-" + opd.opd.var_name
                elif opd.typ == "reg":
                    return opd.opd.reg.name
            elif inst.opc == "leal":
                opd0 = inst.opd_list[0]
                assert(opd0.typ == "mem")
                mem_opd = opd0.opd
                if not mem_opd.base.live_in_acc:
                    bstr = backtrack_live_in_access(inst_list, i, mem_opd.base.name, imm_para)
                else:
                    bstr = mem_opd.base.name
                istr = ""
                if mem_opd.idx.name != "":
                    if not mem_opd.idx.live_in_acc:
                        istr = backtrack_live_in_access(inst_list, i, mem_opd.idx.name, imm_para)
                    else:
                        istr = mem_opd.idx.name
                    if mem_opd.scale != "" and mem_opd.scale != "1":
                        istr = 'MUL(' + istr + ',' + mem_opd.scale_para + ')'
                        imm_para.append([inst, mem_opd.scale, mem_opd.scale_para])
                        mem_opd.scale_para_flag = True
                if istr != "":
                    bstr = 'ADD(' + bstr + ',' + istr + ')'
                if mem_opd.disp != "":
                    bstr = 'ADD(' + bstr + ',' + mem_opd.disp_para + ')'
                    mem_opd.disp_para_flag = True
                return bstr
            elif inst.opc == "addl":
                # The last operand is the defined register
                opd0 = inst.opd_list[0]
                opd1 = inst.opd_list[1]
                if opd0.typ != "reg" or opd1.typ != "reg":
                    if x86_DEBUG_ENABLE:
                        print "[x86] unsupported operand type for ADDL when normalize memory address"
                else:
                    reg_opd0 = opd0.opd
                    reg_opd1 = opd1.opd
                    if not reg_opd0.reg.live_in_acc:
                        str0 = backtrack_live_in_access(inst_list, i, reg_opd0.reg.name, imm_para)
                    else:
                        str0 = reg_opd0.reg.name
                    if not reg_opd1.reg.live_in_acc:
                        str1 = backtrack_live_in_access(inst_list, i, reg_opd1.reg.name, imm_para)
                    else:
                        str1 = reg_opd1.reg.name
                    return 'ADD(' + str0 + ',' + str1 + ')'
            elif inst.opc == "shll":
                if len(inst.opd_list) == 1:
                    return ""
                opd0 = inst.opd_list[0]
                opd1 = inst.opd_list[1]
                if opd0.typ != "imm" or opd1.typ != "reg":
                    if x86_DEBUG_ENABLE:
                        print "[x86] unsupported operand type for SHLL when normalize memory address"
                else:
                    imm_opd0 = opd0.opd
                    reg_opd1 = opd1.opd
                    str0 = imm_opd0.val_para
                    imm_opd0.para_flag = True
                    imm_para.append([inst, imm_opd0.val, imm_opd0.val_para])
                    if not reg_opd1.reg.live_in_acc:
                        str1 = backtrack_live_in_access(inst_list, i, reg_opd1.reg.name, imm_para)
                    else:
                        str1 = reg_opd1.reg.name
                    return 'LSH(' + str1 + ',' + str0 + ')'
            elif x86_DEBUG_ENABLE:
                print "[x86] unsupported opcode when noramlize memory address: %s" % inst.opc  
    return ""

# normalize memory location to base + idx * scale + off
# only live-in register and memory variable are allowed after normalization
def normalize_memory_location(inst_list, mem_opd, normalized_mloc, imm_para):
    base = ""
    # check if the base is a live in access
    if mem_opd.base.live_in_acc:
        base = mem_opd.base.name
    else:
        inst_idx = inst_list.index(mem_opd.inst)
        base = backtrack_live_in_access(inst_list, inst_idx, mem_opd.base.name, imm_para)
        #print "=============[x86] base: %s" % base

    # check if the idx is a live in access
    idx = ""
    if mem_opd.idx.name != "":
        if mem_opd.idx.live_in_acc:
            idx = mem_opd.idx.name
        else:
            inst_idx = inst_list.index(mem_opd.inst)
            idx = backtrack_live_in_access(inst_list, inst_idx, mem_opd.idx.name, imm_para)

    scale = ""
    if mem_opd.scale != "":
        scale = mem_opd.scale_para

    disp = ""
    if mem_opd.disp != "":
        disp = mem_opd.disp_para
        mem_opd.disp_para_flag = True

    normalized_mloc.base = base
    normalized_mloc.idx = idx
    normalized_mloc.scale = scale
    normalized_mloc.off = disp

# Extract the instruction from the asm line
def extract_inst(asm_line):
    i_asm = ""
    substr = re.search("\t(.+)# ", asm_line)
    if substr:
        i_asm = '\'' + substr.group(1).rstrip() + '\''
    else:
        print "[x86] Error: cannot extract instruction from this line: %s" % asm_line
    if "leal" in i_asm: # Replace leal to lea
        i_asm = i_asm.replace("leal", "lea")
    if "cmpl" in i_asm: # Replace cmpl to cmp
        i_asm = i_asm.replace("cmpl", "cmp")
    # Replace decimal integer to hexadecimal format
    def replace_int_string(i_asm, i_str):
        def tohex(val, nbits):
            return hex((val + (1 << nbits)) % (1 << nbits)).rstrip('L')
        if not i_str.lstrip('-').isdigit():
            return i_asm
        h_str = tohex(int(i_str, 10), 32)
        i_asm = i_asm.replace(i_str, h_str)
        return i_asm
    substr = re.search("[\t\s-]([0-9]+)\(", i_asm)
    if substr:
        i_asm = replace_int_string(i_asm, substr.group(1))
    substr = re.search("\$([-0-9]+)", i_asm)
    if substr:
        i_asm = replace_int_string(i_asm, substr.group(1))
    return i_asm
 
def get_unmapped_immediate(asm_inst_list):
    def str2si(s):
        val = int(s, 0)
        if val >= 2**31:
            val -= 2**32
        return val
    unmapped_imm = []
    for inst in asm_inst_list:
        if "shr" in inst.opc or "shl" in inst.opc:
            # Do NOT try to parameterize these immediates 
            #  because it will fail the verification.
            continue
        for opd in inst.opd_list:
            if opd.typ == "imm" and not opd.opd.para_flag:
                unmapped_imm.append([inst, str2si(opd.opd.val), opd.opd.val_para, opd, False])
            elif opd.typ == "mem" and inst.opc == "leal":
                if not opd.opd.disp_para_flag and opd.opd.disp != "":
                    unmapped_imm.append([inst, str2si(opd.opd.disp), opd.opd.disp_para, opd, False])
                if not opd.opd.scale_para_flag and opd.opd.scale != "1" and opd.opd.idx.name != "":
                    unmapped_imm.append([inst, str2si(opd.opd.scale), opd.opd.scale_para, opd, True])
    '''for ui in unmapped_imm:
        print "=========%s" % ui[0]
        print "=========%s" % ui[1]
        print "=========%s" % ui[2]'''
    return unmapped_imm

def get_opc_access_live_in_reg(inst_list, reg_name):
    for inst in inst_list:
        for opd in inst.opd_list:
            if opd.typ != "reg":
                continue
            if opd.opd.reg.name != reg_name:
                continue
            if opd.opd.reg.live_in_acc:
                return inst.opc
    return ""

def is_destination_live_in_reg(inst_list, reg_name):
    for inst in inst_list:
        if inst.opc == "cmpl" or inst.opc == "cmpw" or inst.opc == "cmpb" or \
           inst.opc == "testl" or inst.opc == "testw" or inst.opc == "testb":
            continue
        for i, opd in enumerate(inst.opd_list):
            if opd.typ != "reg":
                continue
            if opd.opd.reg.name != reg_name:
                continue
            if opd.opd.reg.live_in_acc:
                if inst.opc == "incl" or inst.opc == "decl" or i > 0:
                    return True
    return False


def set_unmapped_imm_para_flag(opd):
    if opd.typ == "imm" and not opd.opd.para_flag:
        opd.opd.para_flag = True
    elif opd.typ == "mem":
        if not opd.opd.disp_para_flag and opd.opd.disp != "":
            opd.opd.disp_para_flag = True
        if not opd.opd.scale_para_flag and opd.opd.scale != "1" and opd.opd.idx.name != "":
            opd.opd.scale_para_flag = True

def is_defined_before(inst, inst_l, reg_str):
    for i in inst_l:
        if i.pc == inst.pc:
            return False
        for opd in i.opd_list:
            if opd.typ == "reg" and opd.opd.reg.name == reg_str and \
               "def" in opd.opd.reg.dk:
                return True
    return False

def get_generalized_reg(inst, inst_l, reg_i, temp_idx, reg_mapping_init, \
                        reg_mapping_def, last_def_flag, reg_mapping):
    reg_str = ""
    reg = reg_rename(reg_i.name)
    live_in_acc = reg_i.live_in_acc
    last_def = reg_i.last_def
    if live_in_acc:
        if  not last_def:
            if reg_mapping_init.has_key(reg):
                reg_str = reg_mapping_init[reg]
                # Check if this register was defined before this instruction,
                #  since different host registers can be mapped to the same guest register
                if is_defined_before(inst, inst_l, reg_str):
                    if x86_DEBUG_ENABLE:
                        print "Differnet host registers mapped to the same guest register"
                    return False, reg, temp_idx;
            elif reg_mapping.has_key(reg): # use a temp register
                reg_str = reg_mapping[reg]
            else:
                if x86_DEBUG_ENABLE:
                    print "Temp register is not supported currently"
                return False, reg, temp_idx;
                reg_str = "temp%d" % temp_idx
                temp_idx += 1
                reg_mapping[reg] = reg_str
        else:
            if reg_mapping_def.has_key(reg) and reg_mapping_init.has_key(reg):
                if reg_mapping_def[reg] != reg_mapping_init[reg]:
                    if x86_DEBUG_ENABLE:
                        print "Host register has differet mapping: %s" % reg
                    return False, reg, temp_idx
                else:
                    reg_str = reg_mapping_def[reg]
            else:
                if x86_DEBUG_ENABLE:
                    print "Host register has incosistent live-in and live-out mappings: %s" % reg
                return False, reg, temp_idx
    elif not live_in_acc:
        if last_def: # might be removed
            last_def_flag[reg] = True
        if reg_mapping_def.has_key(reg):
            if reg_mapping_init.has_key(reg) and reg_mapping_def[reg] != reg_mapping_init[reg]:
                if x86_DEBUG_ENABLE:
                    print "Host register has differet mapping: %s" % reg
                return False, reg, temp_idx
            reg_str = reg_mapping_def[reg]
        elif reg_mapping.has_key(reg):
            reg_str = reg_mapping[reg]
        else: # use a temp register
            if x86_DEBUG_ENABLE:
                print "Temp register is not supported currently"
            return False, reg, temp_idx;
            reg_str = "temp%d" % temp_idx
            temp_idx += 1
            reg_mapping[reg] = reg_str
    return True, reg_str, temp_idx

def find_initial_mapping(tstr, im):
    ret = tstr
    found = False
    for mapping in im:
        for item in mapping:
            if item != tstr:
                continue
            ret = mapping[0]
            if isinstance(ret, basestring):
                if ret[0] == '\'':
                    ret = ret[1:]
                if ret[-1] == '\'':
                    ret = ret[:-1]
            found = True
            break
        if found:
            break
    return ret

def generalize_inst(asm_inst, reg_mapping_def, reg_mapping_init, \
                    mem_mapping, def_reg, initial_mapping):
    temp_idx = 0
    last_def_flag = {}
    reg_mapping = {}
    for inst in asm_inst:
        reg_mapping_inst = {}
        for opd in reversed(inst.opd_list):
            if opd.typ == "imm":
                imm_opd = opd.opd
                if imm_opd.para_flag:
                    imm_opd.val_para = find_initial_mapping(imm_opd.val_para, initial_mapping)
            elif opd.typ == "reg":
                reg_opd = opd.opd
                flag, reg_str, temp_idx = \
                    get_generalized_reg(inst, asm_inst, reg_opd.reg, temp_idx, reg_mapping_init, \
                                        reg_mapping_def, last_def_flag, reg_mapping)
                if reg_mapping_inst.has_key(reg_str):
                    if reg_mapping_inst[reg_str] != reg_opd.reg and inst.opc == "subl":
                        return False, ""
                else:
                    reg_mapping_inst[reg_str] = reg_opd.reg;
                if not flag:
                    return False, ""
                reg_opd.reg.name = reg_str
            elif opd.typ == "mem":
                mem_opd = opd.opd
                flag, reg_str, temp_idx = \
                    get_generalized_reg(inst, asm_inst, mem_opd.base, temp_idx, reg_mapping_init, \
                                        reg_mapping_def, last_def_flag, reg_mapping)
                if not flag:
                    return False, ""
                if mem_mapping.has_key(mem_opd.var_name):
                    arm_opd = mem_mapping[mem_opd.var_name]
                    if arm_opd.base.name != reg_str:
                        mem_opd.base.name = arm_opd.base.name
                    else:
                        mem_opd.base.name = reg_str
                else:
                    mem_opd.base.name = reg_str
                if mem_opd.idx.name != "":
                    flag, reg_str, temp_idx = \
                        get_generalized_reg(inst, asm_inst, mem_opd.idx, temp_idx, reg_mapping_init, \
                                            reg_mapping_def, last_def_flag, reg_mapping)
                    if not flag:
                        return False, ""
                    if reg_str == '0':
                        mem_opd.idx.name = ""
                    else:
                        mem_opd.idx.name = reg_str
                if mem_opd.scale != "":
                    mem_opd.scale_para = find_initial_mapping(mem_opd.scale_para, initial_mapping)
                new_disp_para = find_initial_mapping(mem_opd.disp_para, initial_mapping)
                if new_disp_para != mem_opd.disp_para:
                    mem_opd.disp_para = new_disp_para
                    mem_opd.disp_para_flag = True

                '''if mem_mapping.has_key(mem_opd.var_name):
                    arm_opd = mem_mapping[mem_opd.var_name]
                    if reg_mapping.has_key(mem_opd.base.name):
                        mem_opd.base.name = reg_mapping[mem_opd.base.name]
                    else:
                        mem_opd.base.name = arm_opd.base.name
                    if mem_opd.idx.name != "":
                        if reg_mapping.has_key(mem_opd.idx.name):
                            mem_opd.idx.name = reg_mapping[mem_opd.idx.name]
                        else:
                            mem_opd.idx.name = arm_opd.idx.name
                    if mem_opd.scale != 1:
                        mem_opd.scale_para = find_initial_mapping(mem_opd.scale_para, initial_mapping)
                    mem_opd.disp_para = find_initial_mapping(mem_opd.disp_para, initial_mapping)
                elif inst.opc == "leal":
                    reg_str, temp_idx = \
                        get_generalized_reg(mem_opd.base.name, temp_idx, reg_mapping)
                    mem_opd.base.name = reg_str
                    if mem_opd.idx.name != "":
                        reg_str, temp_idx = \
                            get_generalized_reg(mem_opd.idx.name, temp_idx, reg_mapping)
                        mem_opd.idx.name = reg_str
                else:
                    print "Error: cannot find corresponding var for this memory"'''
    return True, asm_inst
