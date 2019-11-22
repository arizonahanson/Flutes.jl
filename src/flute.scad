/*
 * Parametric CSG Flute Model
 *   Author: Isaac W Hanson
 *   License: MIT
 */
include <lib/config.scad>
use <lib/shapes.scad>

difference() {
  w = 10;
  r = 19;
  color("Gray")
    hcylinder(r1=r,r2=r-1,h=182.5,w=w);
  color("BurlyWood")
    hole(pos=61,r1=8.5,r2=8.5,h=r+w);
}
