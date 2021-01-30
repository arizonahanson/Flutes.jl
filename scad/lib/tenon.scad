/*
 * Tenon & mortise using AS568-019 o-rings
 *  (glands scaled 1.5mm above standard)
 */
include <consts.scad>;
use <tools.scad>;

// TODO: externalize all this
// mortise inner bore - 0.925-0.927"
A=25.2;
// piston outer diameter - 0.923-0.922"
C=24.9;
// gland outer diameter - 0.815-0.813"
F=22.2;
// o-ring minor diameter - .067-.073"
CS=1.78;

module mortise(z=0, l=26, b=19) {
  lz=(unshrink(A)-unshrink(b))/2;
  slide(z) difference() {
    hull() {
      frustum(b=A+4, unshrink=true);
      frustum(z=l/2, b=A+8, unshrink=true);
      frustum(z=l-1-LAYER_HEIGHT, b=28, unshrink=true);
      frustum(z=l-LAYER_HEIGHT, b=26, unshrink=true);
    }
    // bore
    frustum(b=A, l=l-lz, unshrink=true);
    // bevel to flute bore
    frustum(z=l-lz, b=A, b2=b, l=lz, unshrink=true);
  }
}

module gland(z=0) {
  lz = (unshrink(C)-unshrink(F))/2;
  slide(z-CS-lz) difference() {
    // piston
    frustum(b=A, l=CS+lz, unshrink=true);
    // flat
    frustum(b=F, l=CS, unshrink=true);
    // bevel to piston
    frustum(z=CS, b=F, b2=C, l=lz, unshrink=true);
  }
}

module tenon(z=0, l=26, b=19) {
  lz=(unshrink(C)-unshrink(b))/2;
  slide(z) difference() {
    union() {
      frustum(b=C, l=l-lz, unshrink=true);
      frustum(z=l-lz, b=C, b2=b, l=lz, unshrink=true);
    }
    gland(z=l-lz-LAYER_HEIGHT);
    gland(z=(l-lz)/2);
    frustum(b=b, l=l, unshrink=true);
  }
}

// example usage
tenon();
mortise();
