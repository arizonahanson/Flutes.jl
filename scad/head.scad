/*
 * Headjoint section
 */
// slider widget for number in range
HeadLength=156.369; // [128:0.1:999]
// slider widget for number in range
CrownLength=42; // [1:1:42]
// slider widget for number in range
TenonLength=26; // [0:1:42]
// slider widget for number in range
FluteOuter=26; // [1:0.1:42]
// slider widget for number in range
FluteInner=19; // [1:0.1:42]
// slider widget for number in range
EmbouchureDiameter=10; // [1:0.1:42]
// slider widget for number in range
EmbouchureWidth=12; // [1:0.1:42]
// slider widget for number in range
EmbouchureWallAngle=7; // [1:0.1:42]
// slider widget for number in range
EmbouchureShoulderAngle=45; // [1:1:42]
// slider widget for number in range
EmbouchureSquareness=0.1; // [0:0.01:1]
// slider widget for number in range
CorkPosition=17.4; // [0:0.1;42]

include <lib/index.scad>;

// lip-plate
module plate(z=0, b, h, l, r=0, sq=0.4) {
  od=b+2*h;
  sqx=sq*l;
  slide(-l-h+z)
    rotate([0,0,r])
      hull() {
        shell(b=b);
        slide(h) intersection() {
          slide(l) pivot() scale([1,od/l,1])
            minkowski() {
              cube(size=[sqx,sqx,0.001], center=true);
              shell(b=b-sqx, b2=2*l-sqx, l=od/2);
            }
          shell(b=od,l=2*l);
        }
        shell(z=2*l+2*h-LAYER_HEIGHT, b=b);
      }
}

module head() {
  wh=7.0;
  slide(CrownLength) difference() {
    union() {
      // crown/cork
      shell(z=-CrownLength,  b=17+wh, l=CrownLength-CorkPosition);
      // reflector->embouchure
      shell(z=-CorkPosition, b=17+wh, b2=17.4+wh, l=CorkPosition);
			plate(z=0.0, b=17.4, h=4.3, l=24, r=atan(10/26));
      // embouchure->max shell
      shell(z=0.0, b=17.4+wh, b2=17.6+wh, l=22);
      shell(z=22,  b=17.6+wh, b2=17.7+wh, l=10);
      shell(z=32,  b=17.7+wh, b2=17.9+wh, l=10);
      shell(z=42,  b=17.9+wh, b2=17.9+wh, l=10);
      shell(z=52,  b=17.9+wh, b2=18.1+wh, l=10);
      shell(z=62,  b=18.1+wh, b2=18.2+wh, l=10);
      shell(z=72,  b=18.2+wh, b2=18.3+wh, l=10);
      shell(z=82,  b=18.3+wh, b2=18.4+wh, l=10);
      shell(z=92,  b=18.4+wh, b2=18.5+wh, l=10);
      shell(z=102, b=18.5+wh, b2=19.0+wh, l=18);
      shell(z=120, b=19.0+wh, l=HeadLength-TenonLength-120);
      tenon(z=HeadLength-TenonLength, l=TenonLength);
    }
    // reflector->embouchure
    bore(z=-CorkPosition, b=17, b2=17.4, l=CorkPosition);
    // embouchure->max bore
    bore(z=0.0,   b=17.4, b2=17.6, l=22);
    bore(z=22.0,  b=17.6, b2=17.7, l=10);
    bore(z=32.0,  b=17.7, b2=17.9, l=10);
    bore(z=42.0,  b=17.9, b2=17.9, l=10);
    bore(z=52.0,  b=17.9, b2=18.1, l=10);
    bore(z=62.0,  b=18.1, b2=18.2, l=10);
    bore(z=72.0,  b=18.2, b2=18.3, l=10);
    bore(z=82.0,  b=18.3, b2=18.4, l=10);
    bore(z=92.0,  b=18.4, b2=18.5, l=10);
    bore(z=102.0, b=18.5, b2=19.0, l=18);
    bore(z=120.0, b=19.0, l=HeadLength-120);
    // embouchure hole
    hole(b=17.4, h=(FluteOuter-17.4)/2, d=EmbouchureDiameter, w=EmbouchureWidth, a=EmbouchureWallAngle, s=EmbouchureShoulderAngle, sq=EmbouchureSquareness);
  }
}

color("silver") head();
