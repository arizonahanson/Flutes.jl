/*
 * Footjoint section
 */
// slider widget for number in range
FootLength=0; // [0:0.1:999]
// text box for vector
HoleDiameters=[]; // [1:42]
// text box for vector
HolePositions=[]; // [1:42]
// text box for vector
HoleRotations=[]; // [-359:359]
// slider widget for number in range
MortiseLength=26; // [0:1:42]

include <lib/index.scad>;

FluteInner=19;
FluteWall=3.5;

module foot() {
  slide(MortiseLength) difference() {
    union() {
      mortise(z=-MortiseLength, l=MortiseLength);
      tube(b=FluteInner, l=FootLength, h=FluteWall);
    }
    // holes
    union() for(i=[0:1:len(HoleDiameters)]) let (zh=HolePositions[i], dh=HoleDiameters[i], rh=HoleRotations[i]) {
      hole(z=zh, b=FluteInner, h=FluteWall, d=dh, r=rh);
    }
  }
}

// example usage
foot();
