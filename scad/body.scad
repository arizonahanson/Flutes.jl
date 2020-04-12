/*
 * Body section
 * constants:
 *   BODY_LENGTH
 *   BODY_HOLES
 */
// slider widget for number
BODY_LENGTH=0; // [0:400]
//Text box for vector
BODY_DIAMETERS=[];
//Text box for vector
BODY_POSITIONS=[];

include <lib/index.scad>;

module body(l=BODY_LENGTH, diameters=BODY_DIAMETERS, positions=BODY_POSITIONS) {
  hh=(FLUTE_OUTER-FLUTE_INNER)/2;
  slide(TENON_LENGTH) difference() {
    union() {
      mortise(z=-TENON_LENGTH);
      shell(b=FLUTE_OUTER, l=l-TENON_LENGTH);
      tenon(z=l-TENON_LENGTH);
    }
    // bore
    bore(b=FLUTE_INNER, l=l-TENON_LENGTH);
    // holes
    for(i=[0:1:len(diameters)]) let (zh=positions[i], dh=diameters[i]) {
      hole(z=zh, b=FLUTE_INNER, h=hh, d=dh);
    }
  }
}

body();
