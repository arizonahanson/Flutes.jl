/*
 * Tenon & mortise using AS568-019 o-rings
 *  (glands scaled 1.5mm above standard)
 */
include <consts.scad>;
use <tools.scad>;

// mortise inner bore - 0.925-0.927"
A=25.05;
// piston outer diameter - 0.923-0.922"
C=24.92;
// gland outer diameter - 0.815-0.813"
F=22.2;
// o-ring minor diameter - .067-.073"
CS=1.78;
TENON_OUTER=A+3.2;
TENON_LIP=A+(TENON_OUTER-A)/3;

module mortise(z=0) {
  lz=(A-FLUTE_INNER)/2;
  lc=(TENON_OUTER-FLUTE_OUTER)/2;
  slide(z) difference() {
    union() {
      shell(b=TENON_OUTER, l=TENON_LENGTH-lc);
      chamfer(z=TENON_LENGTH, b=TENON_OUTER, b2=FLUTE_OUTER, fromend=true);
    }
    // bore
    bore(b=A, l=TENON_LENGTH-lz);
    // bevel to flute bore
    bore(z=TENON_LENGTH-lz, b=A, b2=FLUTE_INNER, l=lz);
    // entrance lip
    bore(b=TENON_LIP, b2=A, l=(TENON_LIP-A)/2);
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

module tenon(z=0) {
  lz=(C-FLUTE_INNER)/2;
  ll=TENON_LENGTH+LAYER_HEIGHT;
  slide(z) difference() {
    union() {
      shell(b=C, l=ll-lz);
      chamfer(z=ll-lz, b=C, b2=FLUTE_INNER);
    }
    bore(b=FLUTE_INNER, l=ll);
    gland(z=ll, fromend=true);
    gland(z=6);
  }
}

tenon();
mortise();
