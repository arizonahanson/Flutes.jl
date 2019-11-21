/*
 * Parametric CSG Flute Model
 *   Author: Isaac W Hanson
 *   License: MIT
 */
include <lib/config.scad>
use <lib/shapes.scad>

difference() {
  w = 2;
  r = 10;
  color("Brown")
    hcylinder(r1=r,r2=r,h=200,w=w);
  color("BurlyWood")
    hole(pos=3,r1=2,r2=2,h=r+w);
}
