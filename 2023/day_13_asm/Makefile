ASM=fasm
FLAGS=

PART1=part_1
PART2=part_2
EXT=asm

.PHONY: all

all: $(PART1) $(PART2)

$(PART1): $(PART1).$(EXT)
	$(ASM) $(FLAGS) $^

$(PART2): $(PART2).$(EXT)
	$(ASM) $(FLAGS) $^


.PHONY: clean

clean:
	@rm $(PART1) $(PART2)
