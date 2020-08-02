/*
 * Headjoint section
 */
// slider widget for number in range
CrownLength=57; // [1:1:99]
// slider widget for number in range
CorkPosition=17.4; // [0:0.1;42]
// slider widget for number in range
FluteWall=3.5; // [0:0.1;10]
// slider widget for number in range
HeadLength=154.6; // [128:0.1:999]
// slider widget for number in range
TenonLength=26; // [0:1:42]
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

include <lib/index.scad>;

// lip-plate
module plate(z=0, b, h, l, r=0, sq=0.4) {
  od=b+2*h;
  sqx=sq*l;
  slide(-l-h+z)
    rotate([0,0,r])
      difference() {
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
        bore(b=b, l=2*l+2*h);
      }
}

module head() {
  slide(CrownLength) difference() {
    union() {
      // crown/cork
      shell(z=-CrownLength,  b=17.0+2*FluteWall, l=CrownLength-CorkPosition);
      // reflector->embouchure
      tube(z=-CorkPosition, b=17, b2=17.4, l=CorkPosition, h=FluteWall);
      // lip plate
      plate(z=0.0,  b=18.0, l=24, h=4.0, r=atan(EmbouchureDiameter/26.0));
      // embouchure -> tenon
      tube(z=0.0,  b=17.4, b2=17.8, l=26.5, h=FluteWall);
      tube(z=26.5, b=17.8, b2=17.9, l=10.0, h=FluteWall);
      tube(z=36.5, b=17.9, b2=18.1, l=10.0, h=FluteWall);
      tube(z=46.5, b=18.1, b2=18.3, l=10.0, h=FluteWall);
      tube(z=56.5, b=18.3, b2=18.4, l=10.0, h=FluteWall);
      tube(z=66.5, b=18.4, b2=18.6, l=10.0, h=FluteWall);
      tube(z=76.5, b=18.6, b2=18.8, l=10.0, h=FluteWall);
      tube(z=86.5, b=18.8, b2=18.8, l=10.0, h=FluteWall);
      tube(z=96.5, b=18.8, b2=19.0, l=10.0, h=FluteWall);
      tube(z=106.5, b=19.0, l=10.1, h=FluteWall);
      // extra untapered
      tube(z=116.6, b=19.0, l=HeadLength-TenonLength-116.6, h=FluteWall);
      // tenon
      tenon(z=HeadLength-TenonLength, l=TenonLength);
    }
    // embouchure hole
    hole(b=17.4, h=4.3, d=EmbouchureDiameter, w=EmbouchureWidth, a=EmbouchureWallAngle, s=EmbouchureShoulderAngle, sq=EmbouchureSquareness);
  }
}

color("silver") head();
