/*
 * Body section
 */
// slider widget for number
BodyLength=0; // [0:400]
// text box for vector
BodyDiameters=[];
// text box for vector
BodyPositions=[];

include <lib/index.scad>;

module body(l=BodyLength) {
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
    for(i=[0:1:len(BodyDiameters)]) let (zh=BodyPositions[i], dh=BodyDiameters[i]) {
      hole(z=zh, b=FLUTE_INNER, h=hh, d=dh);
    }
  }
}

body();
