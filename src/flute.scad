/*
 * Parametric CSG Flute Model
 *   Author: Isaac W Hanson
 *   License: MIT
 */
include <lib/config.scad>
use <lib/shapes.scad>

difference() {
  turn(bore1=12,bore2=9,length=50,thick1=2,thick2=2);
  hole(pos=10,r1=3,r2=3,h=14.01);
}
