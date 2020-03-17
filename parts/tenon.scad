/*
 * Tenon & mortise using AS568-019 o-rings
 */
include <env.scad>;
use <tools.scad>;

A=23.52; // mortise inner bore
C=23.42; // piston outer diameter
F=20.68; // gland outer diameter
CS=1.78; // o-ring minor diameter
X=23.9;  // o-ring diameter (unstretched)

module mortise(z=0, l=26) {
  lz=(A-$inner)/2;
  slide(z) difference() {
    shell(b=$outer, l=l);
    // bore
    bore(b=A, l=l-lz);
    // bevel to flute bore
    bore(z=l-lz, b=A, b2=$inner, l=lz);
    // entrance lip
    bore(b=X, b2=A, l=(X-A)/2);
  }
}

module gland(z=0) {
  lz=(C-F)/2;
  slide(z) difference() {
    // piston
    bore(b=C, l=CS+lz);
    // flat
    bore(b=F, l=CS);
    // bevel to piston
    bore(z=CS, b=F, b2=C, l=lz);
  }
}

module tenon(z=0, l=26) {
  lz=(C-$inner)/2;
  lg=(C-F)/2+CS;
  slide(z) difference() {
    union() {
      shell(b=C, l=l-lz);
      shell(z=l-lz, b=C, b2=$inner, l=lz);
    }
    bore(b=$inner, l=l);
    gland(z=l-lz-lg-$fl*2);
    gland(z=6);
  }
}

tenon();
mortise();
