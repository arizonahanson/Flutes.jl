/*
 * Tenon & mortise using AS568-019 o-rings
 */
include <consts.scad>;
use <tools.scad>;

//A=23.55; // mortise inner bore - 0.925-0.927"
A=24.25; //+0.7
//C=23.42; // piston outer diameter - 0.923-0.922"
C=24.12; //+0.7
//F=20.70; // gland outer diameter - 0.815-0.813"
F=21.4; //+0.7
CS=1.78; // o-ring minor diameter - .067-.073"
TENON_OUTER=26.65;
TENON_LIP=A+(TENON_OUTER-A)/3;

module mortise(z=0) {
  lz=(A-FLUTE_INNER)/2;
  slide(z) difference() {
    shell(b=TENON_OUTER, l=TENON_LENGTH);
    // bore
    bore(b=A, l=TENON_LENGTH-lz);
    // bevel to flute bore
    bore(z=TENON_LENGTH-lz, b=A, b2=FLUTE_INNER, l=lz);
    // entrance lip
    bore(b=TENON_LIP, b2=A, l=(TENON_LIP-A)/2);
  }
}

module gland(z=0) {
  lz=(C-F)/2;
  slide(z) difference() {
    // piston
    bore(b=C, l=CS+lz);
    // flat
    shell(b=F, l=CS);
    // bevel to piston
    shell(z=CS, b=F, b2=C, l=lz);
  }
}

module tenon(z=0) {
  lz=(C-FLUTE_INNER)/2;
  lg=(C-F)/2+CS;
  ll=TENON_LENGTH+LAYER_HEIGHT;
  slide(z) difference() {
    union() {
      shell(b=C, l=ll-lz);
      shell(z=ll-lz, b=C, b2=FLUTE_INNER, l=lz);
    }
    bore(b=FLUTE_INNER, l=ll);
    gland(z=ll-lz-lg-LAYER_HEIGHT);
    gland(z=6);
  }
}

tenon();
mortise();
