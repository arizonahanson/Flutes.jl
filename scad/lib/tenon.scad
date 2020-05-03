/*
 * Tenon & mortise using AS568-019 o-rings
 *  (glands scaled 1.5mm above standard)
 */
include <consts.scad>;
use <tools.scad>;

// TODO: externalize all this
// mortise inner bore - 0.925-0.927"
A=25.05;
// piston outer diameter - 0.923-0.922"
C=24.92;
// gland outer diameter - 0.815-0.813"
F=22.2;
// o-ring minor diameter - .067-.073"
CS=1.78;

module mortise(z=0, l=26) {
  lz=(A-19)/2;
  slide(z) difference() {
    hull() {
      shell(b=A+3.8);
      shell(z=1, b=A+4.8);
      shell(z=l/2-1, b=A+6);
      shell(z=l/2, b=A+7);
      shell(z=l/2+1, b=A+6);
      shell(z=l-LAYER_HEIGHT-1, b=27);
      shell(z=l-LAYER_HEIGHT, b=26);
    }
    // bore
    bore(b=A, l=l-lz);
    // bevel to flute bore
    bore(z=l-lz, b=A, b2=19, l=lz);
  }
}

module gland(z=0, fromend=false) {
  lz=(C-F)/2;
  zz = !fromend ? z : z-(2*(lz+CS));
  slide(zz) difference() {
    // piston
    bore(b=C, l=CS+lz);
    // flat
    shell(b=F, l=CS);
    // bevel to piston
    chamfer(z=CS, b=F, b2=C);
  }
}

module tenon(z=0, l=26) {
  lz=(C-19)/2;
  ll=l+LAYER_HEIGHT;
  slide(z) difference() {
    union() {
      shell(b=C, l=ll-lz);
      chamfer(z=ll-lz, b=C, b2=19);
    }
    gland(z=ll, fromend=true);
    gland(z=(ll+lz)/2, fromend=true);
  }
}

tenon();
mortise();
