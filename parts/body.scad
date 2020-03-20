/*
 * Body
 */
include <consts.scad>;
use <tools.scad>;
use <tenon.scad>;

BODY_LEN=$ln;
BODY_HOLES=[];

module body(l=BODY_LEN, holes=BODY_HOLES) {
  slide($ln) difference() {
    union() {
      mortise(z=-$ln);
      shell(b=$outer, l=l-$ln);
      tenon(z=l-$ln);
    }
    // bore
    bore(b=$inner, l=l-$ln);
    // holes
    for(h=holes) let (zh=h[0], dh=h[1], hh=($outer-$inner)/2) {
      hole(z=zh, b=$inner, h=hh, d=dh);
    }
  }
}

body();
