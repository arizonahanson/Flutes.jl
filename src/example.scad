
use <templates/header.scad>
outer=24.0;
bevel=(outer-19)/2; //19mm bore
tenon=30;
difference() {
    // body
    union() {
      shell(b=outer,l=186-tenon);
      // lip plate
      plate(z=32,b=17.4,h=4.3,l=24,r=22.62);
      // tenon
      shell(z=186-tenon, b=outer-bevel, l=tenon-bevel);
      slide(186-bevel) hull() {
        shell(b=outer-bevel,l=bevel/2);
        shell(z=bevel/2, b=19, l=bevel/2);
      }
    }
    // bore
    slide(15) union() {
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

