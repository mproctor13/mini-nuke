OSC=openscad
STL_SOURCE := $(wildcard parts/*.scad)
LASER_SOURCE := $(wildcard laser/*.scad)
TARGET_DXF := $(patsubst laser/%.scad,dxf/%.dxf,$(LASER_SOURCE))
TARGET_SVG := $(patsubst laser/%.scad,svg/%.svg,$(LASER_SOURCE))
TARGET_STL := $(patsubst parts/%.scad,stl/%.stl,$(STL_SOURCE))
TARGET_PNG := $(patsubst parts/%.scad,img/%.png,$(STL_SOURCE))
world:
	@echo "Choose 'make all' or make <one of the following>:"
	@echo $(TARGET_DXF) $(TARGET_SVG) $(TARGET_STL)
all: svg dxf
svg: $(TARGET_SVG)

dxf: $(TARGET_DXF)

.PHONY: $(TARGET_DXF) $(TARGET_SVG) rendering

svg/%.svg: laser/%.scad mini-nuke.scad
	mkdir -p svg
	$(OSC) -m make -o $@ $<

dxf/%.dxf: laser/%.scad mini-nike.scad
	mkdir -p dxf
	$(OSC) -m make -o $@ $<

stl: $(TARGET_STL)

stl/%.stl: parts/%.scad mini-nuke.scad
	mkdir -p stl
	$(OSC) -m make -o $@ $<

img/%.png: parts/%.scad mini-nuke.scad
	mkdir -p stl
	$(OSC) -m make -o $@ $<

rendering: img/mini-nuke.png $(TARGET_PNG)

img/mini-nuke.png: mini-nuke.scad
	mkdir -p img
	$(OSC) -m make -o $@ $<

clean:
	rm -rf $(TARGET_DXF) $(TARGET_SVG) dxf svg img
