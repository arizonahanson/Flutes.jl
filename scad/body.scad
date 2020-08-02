/*
 * Body section
 */
// slider widget for number in range
BodyLength=0; // [0:0.1:999]
// text box for vector
HoleDiameters=[]; // [1:42]
// text box for vector
HolePositions=[]; // [1:42]
// slider widget for number in range
MortiseLength=26; // [0:1:42]
// slider widget for number in range
TenonLength=26; // [0:1:42]

include <lib/index.scad>;

FluteInner=19;
FluteWall=3.5;

module body() {
  slide(MortiseLength) difference() {
    union() {
      mortise(z=-MortiseLength, l=MortiseLength);
      tube(b=FluteInner, l=BodyLength-TenonLength, h=FluteWall);
      tenon(z=BodyLength-TenonLength, l=TenonLength);
    }
    // holes
    for(i=[0:1:len(HoleDiameters)]) let (zh=HolePositions[i], dh=HoleDiameters[i]) {
      hole(z=zh, b=FluteInner, h=FluteWall, d=dh);
    }
  }
}

color("silver") body();
