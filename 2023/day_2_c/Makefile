CC=clang
CFLAGS=-g -O2

COMMON=common.c
DAY1=day_1
DAY2=day_2

.PHONY: all

all: $(DAY1) $(DAY2)

$(DAY1): $(COMMON) $(DAY1).c
	$(CC) $(CFLAGS) $^ -o $@ 

$(DAY2): $(COMMON) $(DAY2).c
	$(CC) $(CFLAGS) $^ -o $@ 


.PHONY: clean

clean:
	@rm $(DAY1) $(DAY2)
