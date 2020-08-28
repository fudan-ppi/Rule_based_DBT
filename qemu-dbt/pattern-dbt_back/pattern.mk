PATTERN_PATH=$(SRC_PATH)/pattern-dbt

obj-y += pattern-dbt/expr.tab.o
obj-y += pattern-dbt/expr.lex.o
obj-y += pattern-dbt/arm-instr.o pattern-dbt/arm-parse.o
obj-y += pattern-dbt/x86-instr.o pattern-dbt/x86-parse.o pattern-dbt/x86-asm.o
obj-y += pattern-dbt/parse.o
obj-y += pattern-dbt/rule-translate.o

LIBS += -lfl -lm

pattern-dbt/expr.lex.o: $(PATTERN_PATH)/expr.l
	flex -o pattern-dbt/expr.lex.c $<
	$(CC) $(CFLAGS) -o $@ -c pattern-dbt/expr.lex.c

pattern-dbt/expr.tab.o: $(PATTERN_PATH)/expr.y
	bison -d -o pattern-dbt/expr.tab.c $<
	$(CC) $(CFLAGS) -o $@ -c pattern-dbt/expr.tab.c
