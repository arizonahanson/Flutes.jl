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
EmbouchureDiameter=10; // [1:0.1:42]
// slider widget for number in range
EmbouchureWidth=12.2; // [1:0.1:42]
// slider widget for number in range
EmbouchureWallAngle=7; // [1:0.1:42]
// slider widget for number in range
EmbouchureShoulderAngle=-7; // [1:1:42]
// slider widget for number in range
EmbouchureSquareness=0.2; // [0:0.01:1]

include <lib/index.scad>;

module head() {
  slide(CrownLength) difference() {
    union() {
      // outer shell & tenon
      shell(z=-CrownLength, b=FluteOuter, l=CrownLength+HeadLength-TenonLength);
      tenon(z=HeadLength-TenonLength, l=TenonLength);
    }
    // reflector->embouchure
    bore(z=-17, b=17, b2=17.4, l=17);
    // embouchure->max bore
    bore(b=17.4, b2=17.6, l=22);
    bore(z=22, b=17.6, b2=17.7, l=10);
    bore(z=32, b=17.7, b2=17.9, l=10);
    bore(z=42, b=17.9, b2=17.9, l=10);
    bore(z=52, b=17.9, b2=18.1, l=10);
    bore(z=62, b=18.1, b2=18.2, l=10);
    bore(z=72, b=18.2, b2=18.3, l=10);
    bore(z=82, b=18.3, b2=18.4, l=10);
    bore(z=92, b=18.4, b2=18.5, l=10);
    bore(z=102, b=18.5, b2=19, l=18);
    bore(z=120, b=19, l=HeadLength-120);
    // embouchure hole (7°wall 45°shoulder 20%square)
    hole(b=17.4, h=(FluteOuter-17.4)/2, d=EmbouchureDiameter, w=EmbouchureWidth, a=EmbouchureWallAngle, s=EmbouchureShoulderAngle, sq=EmbouchureSquareness);
  }
}

color("silver") head();
