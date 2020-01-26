
use <templates/header.scad>
outer=24.0;
bevel=(outer-19)/2; //19mm bore
tenon=30;
difference() {
    // body
    union() {
      turn(b=outer,l=186-tenon);
      // lip plate
      plate(z=32,b=17.4,h=4.3,l=24,r=22.62);
      // tenon
      turn(z=186-tenon, b=outer-bevel, l=tenon-bevel);
      rise(186-bevel) hull() {
        turn(b=outer-bevel,l=bevel/2);
        turn(z=bevel/2, b=19, l=bevel/2);
      }
    }
    // bore
    rise(15) union() {
      hull() {
        bore(b=17);
        bore(z=11, b=17.4, l=12);
        bore(z=143, b=19);
      }
      bore(z=143, b=19, l=28);
    }
    // hole
    hole(z=32, b=17.4, h=4.3, d=10, s=12, u=7, o=7);
}

