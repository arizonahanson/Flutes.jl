/*
 * Headjoint section
 */
include <lib/index.scad>;

module head() {
  slide(CROWN_LENGTH) difference() {
    union() {
      // outer shell & tenon
      shell(z=-CROWN_LENGTH, b=FLUTE_OUTER, l=CROWN_LENGTH+HEAD_LENGTH-TENON_LENGTH);
      tenon(z=HEAD_LENGTH-TENON_LENGTH);
    }
    // reflector->embouchure
    bore(z=-17, b=17, b2=17.4, l=11);
    // bore at embouchure
    bore(z=-6, b=17.4, l=12);
    // embouchure->max bore
    bore(z=6, b=17.4, b2=FLUTE_INNER, l=114);
    bore(z=120, b=FLUTE_INNER, l=HEAD_LENGTH-120);
    // embouchure hole
    hole(b=17.4, h=4.3, d=10, s=12, u=7);
  }
}

head();
