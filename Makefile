
PREFIX=../build
SCAD_PATH=scad
SFLAGS=
export

.PHONY: all
all: head body foot

.PHONY: head
head:
	@$(MAKE) -C $(SCAD_PATH) head

.PHONY: body
body:
	@$(MAKE) -C $(SCAD_PATH) body

.PHONY: foot
foot:
	@$(MAKE) -C $(SCAD_PATH) foot

# delete stl files
.PHONY: clean
clean:
	@$(MAKE) -C $(SCAD_PATH) clean
