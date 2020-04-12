/*
 * Footjoint section
 * constants:
 *   FOOT_LENGTH
 *   FOOT_HOLES
 */
// slider widget for number
FOOT_LENGTH=0; // [0:400]
//Text box for vector
FOOT_DIAMETERS=[];
//Text box for vector
FOOT_POSITIONS=[];

include <lib/index.scad>;

module foot(l=FOOT_LENGTH, diameters=FOOT_DIAMETERS, positions=FOOT_POSITIONS) {
  hh=(FLUTE_OUTER-FLUTE_INNER)/2;
  slide(TENON_LENGTH) difference() {
    union() {
      mortise(z=-TENON_LENGTH);
      shell(b=FLUTE_OUTER, l=l);
    }
    // bore
    bore(b=FLUTE_INNER, l=l);
    // holes
    for(i=[0:1:len(diameters)]) let (zh=positions[i], dh=diameters[i]) {
      hole(z=zh, b=FLUTE_INNER, h=hh, d=dh);
    }
  }
}

foot();
