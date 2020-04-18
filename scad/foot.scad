/*
 * Footjoint section
 */
// slider widget for number
FootLength=0; // [0:400]
// text box for vector
FootDiameters=[];
// text box for vector
FootPositions=[];
// slider widget for number
TenonLength=26;

include <lib/index.scad>;

module foot() {
  hh=(26-19)/2;
  slide(TenonLength) difference() {
    union() {
      mortise(z=-TenonLength, l=TenonLength);
      shell(b=26, l=FootLength);
    }
    // bore
    bore(b=19, l=FootLength);
    // holes
    for(i=[0:1:len(FootDiameters)]) let (zh=FootPositions[i], dh=FootDiameters[i]) {
      hole(z=zh, b=19, h=hh, d=dh);
    }
  }
}

foot();
