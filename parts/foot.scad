/*
 * Foot
 */
include <consts.scad>;
use <tools.scad>;
use <tenon.scad>;

L=$ln;
HOLES=[];

module foot(l=L, holes=HOLES) {
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
