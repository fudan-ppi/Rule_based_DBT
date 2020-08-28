# Copyright (C) BitBlaze, 2009-2011, and copyright (C) 2010 Ensighta
# Security Inc.  All rights reserved.

export OCAMLMAKEFILE=../ocaml/OCamlMakefile
export VINE_OCAMLDIR=../ocaml
export VINE_TRACEDIR=../trace
export VINE_EXECDIR=../execution
export STP_OCAMLDIR=../stp/ocaml
export IMM_PARSERDIR=../imm_parser

# ocamlfind packages required
export PACKS = str extlib unix
export LIBS = stpvc vine trace execution imm_parser
export INCDIRS = $(VINE_OCAMLDIR) $(VINE_TRACEDIR) $(VINE_EXECDIR) \
                 $(STP_OCAMLDIR) $(IMM_PARSERDIR)

# Include sources from ocaml, trace, execution, stp in the automatically
# generated dependencies.
# It seems like there should be a more elegant way to do this.
export OCAMLDEP = ocamldep -I $(VINE_OCAMLDIR) -I $(VINE_TRACEDIR) \
                   -I $(VINE_EXECDIR) -I $(STP_OCAMLDIR) \
				   -I $(IMM_PARSERDIR)

OCAMLFLAGS = -warn-error Aelz  #-w A

# default subprojects to build
ifndef SUBPROJS
	export SUBPROJS = fuzzball test_insn vinegrind insn_compare
endif

define PROJ_fuzzball
        RESULT=fuzzball
        SOURCES=fuzzball.ml
        DOC_FILES=$(SOURCES)
endef
export PROJ_fuzzball

define PROJ_test_insn
        RESULT=test_insn
        SOURCES=test_insn.ml
        DOC_FILES=$(SOURCES)
endef
export PROJ_test_insn

define PROJ_vinegrind
        RESULT=vinegrind
        SOURCES=vinegrind.ml
        DOC_FILES=$(SOURCES)
endef
export PROJ_vinegrind

define PROJ_insn_compare
        RESULT=insn_compare
        SOURCES=insn_compare.ml
        DOC_FILES=$(SOURCES)
endef
export PROJ_insn_compare

# suffix for bytecode (which when we make all is debug code)
export BCSUFFIX = .dbg

all: dnc

bytecode: dc

%:
	$(if $(filter-out bytecode,$@),make -f $(OCAMLMAKEFILE) subprojs SUBTARGET=$@,@:)

#include $(OCAMLMAKEFILE)
