/*
 * Foot
 */
include <consts.scad>;
use <tools.scad>;
use <tenon.scad>;

FOOT_LEN=$ln;
FOOT_HOLES=[];

module foot(l=FOOT_LEN, holes=FOOT_HOLES) {
  slide($ln) difference() {
    union() {
      mortise(z=-$ln);
      shell(b=$outer, l=l);
    }
    // bore
    bore(b=$inner, l=l);
    // holes
    for(h=holes) let(zh=h[0], dh=h[1], hh=($outer-$inner)/2) {
      hole(z=zh, b=$inner, h=hh, d=dh);
    }
  }
}

foot();
