
use <templates/header.scad>
outer=24.0;
tenon=30;
slen=186;
difference() {
    // body
    union() {
      shell(b=outer,l=slen-tenon);
      // lip plate
      plate(z=32,b=17.4,h=4.3,l=24,r=22.62);
      // tenon
      tenon(z=slen-tenon, b=19, h=1.25, l=tenon);
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

