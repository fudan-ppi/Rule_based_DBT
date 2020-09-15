import sys

# current supported opcode array:
# guest: ARM        host: x86

# parameter: op1
# logical intr
#     add --> addl, addb
#     sub --> subl --> delete: 操作数有顺序，不可以直接参数化
#     and --> andl
#     orr --> orrl
#     eor --> xorl
#     adc --> adcl
#     sbc --> sbbl
#     mul --> imull
#     mla --> imull
# "ands", "orrs", "subs", "adds"
op1_set = ["add", "and", "orr", "eor", "adc", "sbc", "mul", "addl", "andl", "orl", "xorl", "adcl", "sbbl", "imull", "op1"]

# parameter: op2
# mov
#     mov --> movl
op2_set = ["mov", "movl"]

# parameter: op3
# load intr
op3_set = ["ldr", "ldrb", "ldrh", "ldrsh", "movl", "movzbl", "movb", "movzwl", "movw", "movswl", "op3"]

# parameter: op4
# store instr
op4_set = ["str", "strb", "strh", "movl", "movb", "movw", "op4"]


# shift intr  logical
# lsrs --> shrdl
op5_set = ["asr", "lsr", "lsl", "sarl", "shll", "shrl"]

op6_set = ["sub", "subl"]

opS_guest = ["add", "sub", "subs", "lsl", "rsb", "rsbs"]
opS_host = ["incl", "decl", "leal", "negl"]

# global array to restore all parameter rules
t_rules = []
op1_count = 0
op2_count = 0
op3_4_count = 0
count_repeat = 0


# main function start here
def main(argv):
    if(len(argv) != 2):
        usage()
        exit(0)

    old_rules = open(argv[1], 'r')
    rules_lines = []
    # start read rules4all
    for line in old_rules.readlines():
        # line = line.strip()
        if line.startswith("#"):
            continue
        rules_lines.append(line)
        # write_data(open("new_file", 'w'), rules_lines)
        if line == '\n':
            split_rules(rules_lines)
            rules_lines = []

    out_file_name = argv[1] + "_parameter"
    print("rules length: " + str(len(t_rules)))
    # print("op1 parameter: " + str(op1_count))
    # print("op2 parameter: " + str(op2_count))
    # print("ldr str parameter: " + str(op3_4_count))
    # print("replaced count:" + str(op1_count + op2_count + op3_4_count))
    print("count repeat: " + str(count_repeat))
    dump_rules(out_file_name, t_rules)

    out_file_name = argv[1] + "_repeated"
    dump_rules(out_file_name, repeated_rules)
    old_rules.close()

# main function done here

# split rules to translate into parameter rules
def split_rules(rules_lines):
    gp = []
    hp = []
    cp = []
    cm = []
    gp_flag = False
    hp_flag = False
    cp_flag = False
    cm_flag = False
    source_number = 0
    for i in range(0, len(rules_lines)):
        # start of one rule
        if ".Guest:" in rules_lines[i]:
            source_number = rules_lines[i].split(".")[0]
            gp = []
            hp = []
            cp = []
            cm = []
            gp_flag = True
            hp_flag = False
            cp_flag = False
            cm_flag = False
            continue
        # finish parse one rule, parameterize it
        if rules_lines[i] == '\n':
            parameterize_rule(gp, hp, cp, cm, source_number)
            continue
        if ".Host:" in rules_lines[i]:
            hp_flag = True
            gp_flag = False
            continue
        if ".Context:" in rules_lines[i]:
            cp_flag = True
            hp_flag = False
            continue
        if ".Condition Code:" in rules_lines[i]:
            cm_flag = True
            cp_flag = False
            continue
        if gp_flag:
            gp.append(rules_lines[i].strip())
            continue
        if hp_flag:
            hp.append(rules_lines[i].strip())
            continue
        if cp_flag:
            cp.append(rules_lines[i].strip())
            continue
        if cm_flag:
            cm.append(rules_lines[i].strip())
            continue

# split rule done here

# start dump rules copy from mergy rule file
def dump_rules(out_path, t_rules):
    f = open(out_path, 'w')
    for i in range(0, len(t_rules)):
        tr = t_rules[i]
        f.write(str(i+1) + ".Guest:" + '\n')
        for inst in tr.guest:
            f.write("    " + inst + '\n')
        f.write(str(i+1) + ".Host:\n")
        for inst in tr.host:
            f.write("    " + inst + '\n')
        f.write(str(i+1) + ".Context:\n")
        for ln in tr.context:
            f.write("    " + ln + '\n')
        f.write(str(i+1) + ".Condition Code:\n")
        for cm in tr.cc_mapping:
            f.write("    " + cm + '\n')
        f.write('\n')
    f.close()
# done dump files

# write data begin here
# def write_data(new_file, source):
#     for i in range(0, len(source)):
#         new_file.write(source[i])
#     new_file.close()
# write data done here

# start usage
def usage():
    print("Parameterize translation rules")
    print("Usage:")
    print("      parameter.py <rule-file>")
# finish usage

# a kind of object declaration here
class TranslationRule:
    def __init__(self, gp, hp, cp, cc, source):
        self.guest = gp
        self.host = hp
        self.context = cp
        self.cc_mapping = cc
        self.source = source
# class done here

# parameter rule start here
def parameterize_rule(gp, hp, cp, cm, source):

    # abstract function match & replace opcode with specific guest & host array
    def match_replace(gp, hp, set, wildcard):
        g_index = []
        h_index = []
        g_opcode = []
        h_opcode = []
        for i in range(0, len(gp)):
            opcode_g = gp[i].split(" ")[0]
            if opcode_g in set:
                g_opcode.append(opcode_g)
                g_index.append(i)
        for j in range(0, len(hp)):
            opcode_h = hp[j].split(" ")[0]
            if opcode_h in set:
                h_opcode.append(opcode_h)
                h_index.append(j)
        # print(str(g_opcode) + "\n")
        # print(str(h_opcode) + "\n")
        if len(g_index) != 0 and len(g_index) == len(h_index):
            global op1_count
            op1_count = op1_count + 1
            for i in range(0, len(g_index)):
                gp[g_index[i]] = wildcard
                hp[h_index[i]] = wildcard
                # hp[h_index[j]] = hp[h_index[j]].replace(h_opcode[j], wildcard)

    def match_op2(gp, hp, guest, host, wildcard):
        g_index = []
        h_index = []
        g_opcode = []
        h_opcode = []
        g_mov_index = []
        h_mov_index = []
        for i in range(0, len(gp)):
            opcode_g = gp[i].split(" ")[0]
            if opcode_g in guest and opcode_g != "mov":
                g_opcode.append(opcode_g)
                g_index.append(i)
            if opcode_g == "mov":
                g_operation = split_instr(gp[i])[1]
                temp = 0
                for j in range(0, len(g_operation)):
                    if "reg" in g_operation[j]:
                        temp = temp + 1
                if temp == len(g_operation):
                    g_mov_index.append(i)
        for j in range(0, len(hp)):
            opcode_h = hp[j].split(" ")[0]
            if opcode_h in host and opcode_h != "movl":
                h_opcode.append(opcode_h)
                h_index.append(j)
            if opcode_h == "movl":
                h_mov_index.append(j)
        # deal with cmp:
        if len(g_index) != 0 and len(g_index) == len(h_index):
            global op2_count
            op2_count = op2_count + 1
            for i in range(0, len(g_index)):
                gp[g_index[i]] = gp[g_index[i]].replace(g_opcode[i], wildcard)
            for j in range(0, len(h_index)):
                hp[h_index[j]] = hp[h_index[j]].replace(h_opcode[j], wildcard)
        # deal with mov: 
        if len(g_mov_index) != 0 and len(h_mov_index) != 0  and len(g_mov_index) <= len(h_mov_index):
            for i in range(0, len(g_mov_index)):
                if g_mov_index[i] == h_mov_index[i]:
                    op2_count = op2_count + 1
                    gp[g_mov_index[i]] = gp[g_mov_index[i]].replace("mov", wildcard)
                    hp[h_mov_index[i]] = hp[h_mov_index[i]].replace("movl", wildcard)



    def match_simple_instr(gp, hp, set, wildcard):
        g_index = []
        h_index = []
        g_opcode = []
        h_opcode = []
        for i in range(0, len(gp)):
            opcode_g = gp[i].split(" ")[0]
            if opcode_g in set:
                g_opcode.append(opcode_g)
                g_index.append(i)
        for j in range(0, len(hp)):
            opcode_h = hp[j].split(" ")[0]
            if opcode_h in set:
                h_opcode.append(opcode_h)
                h_index.append(j)
        # 仅仅保留顺序相同
        if len(g_index) != 0 and len(h_index) != 0 and len(g_index) <= len(h_index):
            for i in range(0, len(g_index)):
                if g_index[i] == h_index[i]:
                    global op3_4_count
                    op3_4_count = op3_4_count + 1
                    gp[g_index[i]] = wildcard
                    hp[h_index[i]] = wildcard
    # if len(gp) <= len(hp):
    # match_replace(gp, hp, op1_set, "op1")
        # match_replace(gp, hp, op2_set, "op2")
        # match_replace(gp, hp, op3_set, "op3")
        # match_replace(gp, hp, op4_set, "op4")
    # match_replace(gp, hp, op5_set, "op5")
    # match_replace(gp, hp, op6_set, "op6")

        # match_simple_instr(gp, hp, op1_set, "op1")
    match_simple_instr(gp, hp, op2_set, "op2")
    match_simple_instr(gp, hp, op3_set, "op3")
    match_simple_instr(gp, hp, op4_set, "op4")
        # match_simple_instr(gp, hp, op5_set, "op5")
        # match_simple_instr(gp, hp, op6_set, "op6")

    # match_op2(gp, hp, op2_guest, op2_host, "op2")
    # done match and replace

    merge_rules(t_rules, gp, hp, cp, cm, source)
    # ntr = TranslationRule(gp, hp, cp, cm)
    # t_rules.append(ntr)

# parameter rules done here

# functional function for instruction split
def split_instr(instr):
    # ARM instr split
    result = []
    operation = []
    if "[" in instr:
        temp1 = instr.split("[")
        temp2 = temp1[0].split(" ")
        opcode = temp2[0]
        for i in range(1, len(temp2)):
            if temp2[i] != "":
                temp3 = temp2[i].split(",")
                operation.append(temp3[0])
        operation.append("[" + temp1[1])
        result.append(opcode)
        result.append(operation)
    else:
        temp1 = instr.split(" ")
        opcode = temp1[0]
        instr = instr.lstrip(opcode + " ")
        temp2 = instr.split(" ,")
        for i in range(0, len(temp2)):
            operation.append(temp2[i])
        result.append(opcode)
        result.append(operation)

    return result
# finish here

repeated_rules = []
# merge function for remove duplicate rules
def merge_rules(t_rules, gp, hp, cp, cm, source):

    def has_cmp(part):
        for i in part:
            if "cmp" in i:
                return True
        return False

    def unmapped_cc_num(cc_mapping):
        num = 0
        for cm in cc_mapping:
            if "none" in cm:
                num += 1
        return num

    def do_replace(tr, hp, cp, cm):
        tr.host = hp
        tr.context = cp
        tr.cc_mapping = cm
    # remove duplicates

    found = False
    for tr in t_rules:
        # different guest length
        if len(gp) != len(tr.guest):
            continue
        flag = True

        # check each instructions in guest
        for i in range(0, len(gp)):
            if gp[i] != tr.guest[i]:
                flag = False
                break
        # all instructions are same to one exist rule
        if flag:
            found = True
            break

    if found:
        global count_repeat
        count_repeat = count_repeat + 1
        repeated_rules.append(tr)
    if not found:
        # finish merge, save rules
        ntr = TranslationRule(gp, hp, cp, cm, source)
        t_rules.append(ntr)
        # print("tr cp length:" + str(len(tr.context)))
    elif (len(cp[0]) < len(tr.context[0])):
        # We encountered this guest in previous rules, keep the rule that requires less context
        do_replace(tr, hp, cp, cm)
    elif unmapped_cc_num(tr.cc_mapping) > unmapped_cc_num(cm):
        do_replace(tr, hp, cp, cm)
    elif (has_cmp(gp) and not has_cmp(tr.host) and has_cmp(hp)):
        do_replace(tr, hp, cp, cm)
    elif ((len(cp[0]) == len(tr.context[0])) and (len(hp) < len(tr.host))):
        do_replace(tr, hp, cp, cm)
# merge rules done here

main(sys.argv)