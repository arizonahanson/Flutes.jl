/*
 * Footjoint section
 */
// slider widget for number in range
FootLength=0; // [0:0.1:999]
// text box for vector
HoleDiameters=[]; // [1:42]
// text box for vector
HolePositions=[]; // [1:42]
// slider widget for number in range
MortiseLength=26; // [0:1:42]

include <lib/index.scad>;

// TODO: currently fixed
FluteOuter=26;
FluteInner=19;

module foot() {
  hh=(FluteOuter-FluteInner)/2;
  slide(MortiseLength) difference() {
    union() {
      mortise(z=-MortiseLength, l=MortiseLength);
      shell(b=FluteOuter, l=FootLength);
    }
    // bore
    bore(b=FluteInner, l=FootLength);
    // holes
    for(i=[0:1:len(HoleDiameters)]) let (zh=HolePositions[i], dh=HoleDiameters[i]) {
      hole(z=zh, b=FluteInner, h=hh, d=dh);
    }
  }
}

color("silver") foot();
