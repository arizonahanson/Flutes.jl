/*
 * Headjoint section
 */
// slider widget for number in range
HeadLength=156; // [1:0.1:999]
// slider widget for number in range
CrownLength=52; // [1:1:42]
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
EmbouchureShoulderAngle=45; // [1:1:42]
// slider widget for number in range
EmbouchureSquareness=0.2; // [0:0.01:1]

include <lib/index.scad>;

// lip-plate
module plate(z=0, b, h, l, r=0) {
  od=b+2*h;
  slide(-l-h+z)
    rotate([0,0,r])
      hull() {
        shell(b=b);
        slide(h)
          intersection() {
            shell(b=od,l=2*l);
            slide(l) pivot() scale([1,od/l,1])
              shell(b=b, b2=2*l, l=od/2);
          }
        shell(z=2*l+2*h, b=b);
      }
}

module head() {
  slide(CrownLength) difference() {
    union() {
      // reflector->embouchure
      shell(z=-CrownLength, b=24, l=CrownLength-17);
      shell(z=-17, b=24, b2=24.4, l=17);
      // embouchure->max bore
      shell(b=24.4, b2=24.6, l=22);
			// lip plate
			plate(b=17.4, h=4.3, l=24, r=atan(10/26));
      shell(z=22, b=24.6, b2=24.7, l=10);
      shell(z=32, b=24.7, b2=24.9, l=10);
      shell(z=42, b=24.9, b2=24.9, l=10);
      shell(z=52, b=24.9, b2=25.1, l=10);
      shell(z=62, b=25.1, b2=25.2, l=10);
      shell(z=72, b=25.2, b2=25.3, l=10);
      shell(z=82, b=25.3, b2=25.4, l=10);
      shell(z=92, b=25.4, b2=25.5, l=10);
      shell(z=102, b=25.5, b2=26, l=18);
      shell(z=120, b=26, l=HeadLength-120-TenonLength);
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
