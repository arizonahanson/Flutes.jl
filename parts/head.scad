/*
 * Headjoint
 */
include <consts.scad>;
use <tools.scad>;
use <tenon.scad>;

L0=32; // embouchure-origin distance

module head(z=0, l=156) {
  slide(L0) difference() {
    union() {
      // outer shell & tenon
      shell(z=-L0, b=$outer, l=L0+l-26);
      tenon(z=l-26);
    }
    // reflector->embouchure
    bore(z=-17, b=17, b2=17.4, l=11);
    // bore at embouchure
    bore(z=-6, b=17.4, l=12);
    // embouchure->max bore
    bore(z=6, b=17.4, b2=$inner, l=114);
    bore(z=120, b=$inner, l=l-120);
    // embouchure hole
    hole(b=17.4, h=4.3, d=10, s=12, u=7);
  }
}

head();
