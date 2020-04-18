/*
 * Body section
 */
// slider widget for number
BodyLength=0; // [0:400]
// text box for vector
BodyDiameters=[];
// text box for vector
BodyPositions=[];
// slider widget for number
TenonLength=26;

include <lib/index.scad>;

module body() {
  hh=(26-19)/2;
  slide(TenonLength) difference() {
    union() {
      mortise(z=-TenonLength, l=TenonLength);
      shell(b=26, l=BodyLength-TenonLength);
      tenon(z=BodyLength-TenonLength, l=TenonLength);
    }
    // bore
    bore(b=19, l=BodyLength-TenonLength);
    // holes
    for(i=[0:1:len(BodyDiameters)]) let (zh=BodyPositions[i], dh=BodyDiameters[i]) {
      hole(z=zh, b=19, h=hh, d=dh);
    }
  }
}

body();
