/*
 * Headjoint
 */
include <consts.scad>;
use <tools.scad>;
use <tenon.scad>;

module head() {
  slide($lo) difference() {
    union() {
      // outer shell & tenon
      shell(z=-$lo, b=$outer, l=$lo+$la-$ln);
      tenon(z=$la-$ln);
    }
    // reflector->embouchure
    bore(z=-17, b=17, b2=17.4, l=11);
    // bore at embouchure
    bore(z=-6, b=17.4, l=12);
    // embouchure->max bore
    bore(z=6, b=17.4, b2=$inner, l=114);
    bore(z=120, b=$inner, l=$la-120);
    // embouchure hole
    hole(b=17.4, h=4.3, d=10, s=12, u=7);
  }
}

head();
