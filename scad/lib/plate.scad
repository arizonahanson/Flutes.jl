/*
 * Lip plate
 */
include <consts.scad>;
use <tools.scad>;

// lip-plate
module plate(z=0, b, h, l, r=0) {
  od=b+2*h;
  slide(-l-h+z) difference() {
    hull() {
      frustum(b=b);
      slide(h) intersection() {
        slide(l) pivot(r) frustum(b=b, b2=2*l, l=grow(od)/2, grow=0);
        frustum(b=od, l=2*l);
      }
      frustum(z=2*l+2*h-LAYER_HEIGHT, b=b);
    }
    frustum(b=b, l=2*l+2*h);
  }
}

// example usage
difference() {
  plate(b=17.4, h=4.3, l=24, r=atan(10.4/26));
  hole(b=17.4, h=4.3, d=10.4, w=12.2, a=7, s=45, sq=0.1);
}
