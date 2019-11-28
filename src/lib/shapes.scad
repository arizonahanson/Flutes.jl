/*
 * Parametric CSG Flute Model
 *   Author: Isaac W Hanson
 *   License: MIT
 *
 * Shape modules
 */

module hole(pos=0,r1=2,r2=2,h=10) {
  translate([0,0,pos])
    rotate([0,90,0])
      cylinder(r1=r1,r2=r2,h=h);
}

module turn(length=1,bore1=1,bore2=1,thick1=1,thick2=1) {
  difference() {
    cylinder(r1=bore1+thick1,r2=bore2+thick2,h=length);
    translate([0,0,-0.005])
      cylinder(r1=bore1,r2=bore2,h=length+0.01);
  }
}
