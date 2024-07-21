CC=clang
CFLAGS=-g -O2

COMMON=common.c
PART1=part_1
PART2=part_2

.PHONY: all

all: $(PART1) $(PART2)

$(PART1): $(COMMON) $(PART1).c
	$(CC) $(CFLAGS) $^ -o $@ 

$(PART2): $(COMMON) $(PART2).c
	$(CC) $(CFLAGS) $^ -o $@ 


.PHONY: clean

clean:
	@rm $(PART1) $(PART2)
