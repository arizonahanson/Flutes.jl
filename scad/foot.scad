/*
 * Footjoint section
 */
// slider widget for number
FootLength=0; // [0:400]
// text box for vector
FootDiameters=[];
// text box for vector
FootPositions=[];

include <lib/index.scad>;

module foot(l=FootLength) {
  hh=(FLUTE_OUTER-FLUTE_INNER)/2;
  slide(TENON_LENGTH) difference() {
    union() {
      mortise(z=-TENON_LENGTH);
      shell(b=FLUTE_OUTER, l=l);
    }
    // bore
    bore(b=FLUTE_INNER, l=l);
    // holes
    for(i=[0:1:len(FootDiameters)]) let (zh=FootPositions[i], dh=FootDiameters[i]) {
      hole(z=zh, b=FLUTE_INNER, h=hh, d=dh);
    }
  }
}

foot();
