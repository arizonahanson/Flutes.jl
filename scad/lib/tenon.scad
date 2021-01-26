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
  lz=(A-b)/2;
  slide(z) difference() {
    hull() {
      frustum(b=A+4);
      frustum(z=l/2, b=A+8);
      frustum(z=l-1-LAYER_HEIGHT, b=28);
      frustum(z=l-LAYER_HEIGHT, b=26);
    }
    // bore
    frustum(b=A, l=l-lz);
    // bevel to flute bore
    frustum(z=l-lz, b=A, b2=b, l=lz);
  }
}

module gland(z=0) {
  lz = (C-F)/2;
  slide(z-CS-lz) difference() {
    // piston
    frustum(b=A, l=CS+lz);
    // flat
    frustum(b=F, l=CS);
    // bevel to piston
    frustum(z=CS, b=F, b2=C, l=lz);
  }
}

module tenon(z=0, l=26, b=19) {
  lz=(C-b)/2;
  slide(z) difference() {
    union() {
      frustum(b=C, l=l-lz);
      frustum(z=l-lz, b=C, b2=b, l=lz);
    }
    gland(z=l-lz-LAYER_HEIGHT);
    gland(z=(l-lz)/2);
    frustum(b=b, l=l);
  }
}

// example usage
tenon();
mortise();
