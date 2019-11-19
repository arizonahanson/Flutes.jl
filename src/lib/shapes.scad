/*
 * Shapes
 */

module tube(r1=20,r2=20,h=200,w=10) {
  difference() {
    cylinder(r1=r1+w,r2=r2+w,h=h);
    translate([0,0,-0.01]) #cylinder(r1=r1,r2=r2,h=h+0.02);
  }
}
