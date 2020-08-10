/*
 * Lip plate
 */
include <consts.scad>;
use <tools.scad>;

// lip-plate
module plate(z=0, b, h, l, r=0, sq=0.4) {
  od=b+2*h;
  sqx=sq*l;
  slide(-l-h+z) difference() {
    hull() {
      shell(b=b);
      slide(h) intersection() {
        slide(l) pivot(r)
          squarish(sqx)
            shell(b=b-sqx, b2=2*l-sqx, l=od/2);
        shell(b=od,l=2*l);
      }
      shell(z=2*l+2*h-LAYER_HEIGHT, b=b);
    }
    bore(b=b, l=2*l+2*h);
  }
}

difference() {
  plate(b=17.4, h=4.3, l=24, r=atan(10/26));
  hole(b=17.4, h=4.3, d=10, w=12, a=7, s=45, sq=0.1);
}
