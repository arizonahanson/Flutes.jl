/*
 * Parametric CSG Flute Model
 *   Author: Isaac W Hanson
 *   License: MIT
 */
include <lib/config.scad>
use <lib/shapes.scad>

rotate([0,-90,180])
difference() {
  turn(bore1=10,bore2=8,length=180,thick1=2,thick2=4);
  hole(pos=25,r1=5,r2=3,h=12.01);
}
