PART1=part_1
PART2=part_2

.PHONY: all

all: $(PART1) $(PART2)

$(PART1): $(PART1).ml
	ocamlopt $^ -o $@ 

$(PART2): $(PART2).ml
	ocamlopt $^ -o $@ 


.PHONY: clean

clean:
	@rm -f $(PART1) $(PART2) $(PART1).o $(PART2).o $(PART1).cmo $(PART2).cmo $(PART1).cmx $(PART2).cmx $(PART1).cmi $(PART2).cmi
