/*
 * Headjoint section
 */
// slider widget for number in range
HeadLength=156; // [1:0.1:999]
// slider widget for number in range
CrownLength=32; // [1:1:42]
// slider widget for number in range
TenonLength=26; // [0:1:42]
// slider widget for number in range
FluteOuter=26; // [1:0.1:42]
// slider widget for number in range
FluteInner=19; // [1:0.1:42]
// slider widget for number in range
PlateInner=17; // [1:0.1:42]
// slider widget for number in range
PlateLength=17; // [1:0.1:42]
// slider widget for number in range
EmbouchureInner=17.4; // [1:0.1:42]
// slider widget for number in range
EmbouchureDiameter=10; // [1:0.1:42]
// slider widget for number in range
EmbouchureWidth=12; // [1:0.1:42]
// slider widget for number in range
EmbouchureWallAngle=7; // [1:0.1:42]
// slider widget for number in range
EmbouchureShoulderAngle=45; // [1:1:42]
// slider widget for number in range
EmbouchureSquareness=0.2; // [0:0.01:1]
// slider widget for number in range
TaperLength=120; // [0:0.1:999]

include <lib/index.scad>;

module head() {
  slide(CrownLength) difference() {
    union() {
      // outer shell & tenon
      shell(z=-CrownLength, b=FluteOuter, l=CrownLength+HeadLength-TenonLength);
      tenon(z=HeadLength-TenonLength, l=TenonLength);
    }
    // reflector->embouchure
    bore(z=-PlateLength, b=PlateInner, b2=EmbouchureInner, l=PlateLength);
    // embouchure->max bore
    bore(b=EmbouchureInner, b2=FluteInner, l=TaperLength);
    bore(z=TaperLength, b=FluteInner, l=HeadLength-TaperLength);
    // embouchure hole (7°wall 45°shoulder 20%square)
    hole(b=EmbouchureInner, h=(FluteOuter-EmbouchureInner)/2, d=EmbouchureDiameter, w=EmbouchureWidth, a=EmbouchureWallAngle, s=EmbouchureShoulderAngle, sq=EmbouchureSquareness);
  }
}

head();
