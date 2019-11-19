/*
 * Headjoint
 */
use <lib/shapes.scad>;

module headjoint(r1=20,r2=20,h=200,w=10) {
  difference() {
    tube(r1=r1,r2=r2,h=h,w=w);
    translate([r1+w+1,0,20])
      rotate([0,-90,0])
        #cylinder(r1=9,r2=9,h=w*1.5);
  }
}
