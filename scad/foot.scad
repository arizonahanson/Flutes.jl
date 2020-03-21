/*
 * Footjoint section
 * constants:
 *   FOOT_LENGTH
 *   FOOT_HOLES
 */
include <lib/index.scad>;

FOOT_LENGTH=0;
FOOT_HOLES=[];

module foot(l=FOOT_LENGTH, holes=FOOT_HOLES) {
  hh=(FLUTE_OUTER-FLUTE_INNER)/2;
  slide(TENON_LENGTH) difference() {
    union() {
      mortise(z=-TENON_LENGTH);
      shell(b=FLUTE_OUTER, l=l);
    }
    // bore
    bore(b=FLUTE_INNER, l=l);
    // holes
    for(h=holes) let(zh=h[0], dh=h[1]) {
      hole(z=zh, b=FLUTE_INNER, h=hh, d=dh);
    }
  }
}

foot();
