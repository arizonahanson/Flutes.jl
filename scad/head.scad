/*
 * Headjoint section
 */
// slider widget for number
HeadLength=156;
// slider widget for number
CrownLength=32;
// slider widget for number
TenonLength=26;

include <lib/index.scad>;

module head() {
  slide(CrownLength) difference() {
    union() {
      // outer shell & tenon
      shell(z=-CrownLength, b=26, l=CrownLength+HeadLength-TenonLength);
      tenon(z=HeadLength-TenonLength, l=TenonLength);
    }
    // reflector->embouchure
    bore(z=-17, b=17, b2=17.4, l=17);
    // embouchure->max bore
    bore(b=17.4, b2=19, l=120);
    bore(z=120, b=19, l=HeadLength-120);
    // embouchure hole (10x12mm 7°wall 45°shoulder 20%square)
    hole(b=17.4, h=4.3, d=10, w=12, a=7, s=45, sq=0.2);
  }
}

head();
