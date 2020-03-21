/*
 * Tenon & mortise using AS568-019 o-rings
 */
include <consts.scad>;
use <tools.scad>;

A=23.52; // mortise inner bore
C=23.42; // piston outer diameter
F=20.68; // gland outer diameter
CS=1.78; // o-ring minor diameter
X=23.9;  // o-ring diameter (unstretched)

module mortise(z=0) {
  lz=(A-FLUTE_INNER)/2;
  slide(z) difference() {
    shell(b=FLUTE_OUTER, l=TENON_LENGTH);
    // bore
    bore(b=A, l=TENON_LENGTH-lz);
    // bevel to flute bore
    bore(z=TENON_LENGTH-lz, b=A, b2=FLUTE_INNER, l=lz);
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

module tenon(z=0) {
  lz=(C-FLUTE_INNER)/2;
  lg=(C-F)/2+CS;
  slide(z) difference() {
    union() {
      shell(b=C, l=TENON_LENGTH-lz);
      shell(z=TENON_LENGTH-lz, b=C, b2=FLUTE_INNER, l=lz);
    }
    bore(b=FLUTE_INNER, l=TENON_LENGTH);
    gland(z=TENON_LENGTH-lz-lg-(LAYER_HEIGHT*2));
    gland(z=6);
  }
}

tenon();
mortise();
