/*
 * Lip plate
 */
include <consts.scad>;
use <tools.scad>;

// lip-plate
module plate(z=0, b, h, l, r=0, sq=0.4) {
  od=b+2*h;
  sqx=sq*l;
  slide(-l-h+z)
    rotate([0,0,r])
      difference() {
        hull() {
          shell(b=b);
          slide(h) intersection() {
            slide(l) pivot()
              ovalize(od, l) squarish(sqx)
                shell(b=b-sqx, b2=2*l-sqx, l=od/2);
            shell(b=od,l=2*l);
          }
          shell(z=2*l+2*h-LAYER_HEIGHT, b=b);
        }
        bore(b=b, l=2*l+2*h);
      }
}

plate(z=0, b=18, h=4, l=26, r=atan(10/26));
