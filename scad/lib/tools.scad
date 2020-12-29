/*
 * Various flute-making tools
 */
include <consts.scad>;

// round up fn to nearest multiple of n
function roundup(fn, n) = max(ceil(fn/n)*n, n);

// used to calculate number of polygon segments ($fn) multiple of 4
function fns(b) = roundup(PI*b/NOZZLE_DIAMETER, 4);

// used to calculate diameter of circumscribed polygon
function cir(b, fn) = 1/cos(180/fn)*b + NOZZLE_DIAMETER;

// used to calculate circumscribed polygon with arc compensation
function arc(b, fn) = sqrt(pow(NOZZLE_DIAMETER,2) + 4*pow(cir(b, fn)/2,2));

// translate +z axis
module slide(z=LAYER_HEIGHT) {
  translate([0,0,z]) children();
}

// translate z, then cylinder d1=b, d2=b2|b, h=l
module post(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT) {
  b2 = (b2==undef) ? b : b2;
  fn = fns(max(b, b2)); // adaptive resolution
  slide(z) cylinder(d1=b, d2=b2, h=l, $fn=fn);
}

// like post, but circumscribed polygon compensation
module bore(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT) {
  b2 = (b2==undef) ? b : b2;
  fn = fns(max(b, b2)); // adaptive resolution
  slide(z) cylinder(d1=arc(b, fn), d2=arc(b2, fn), h=l, $fn=fn);
}

// tube: post with bore removed
module tube(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT, h=NOZZLE_DIAMETER, h2) {
  b2 = (b2==undef) ? b : b2;
  h2 = (h2==undef) ? h : h2;
  difference() {
    post(z=z, b=b+2*h, b2=b2+2*h2, l=l);
    bore(z=z, b=b, b2=b2, l=l);
  }
}

// rotate x by 90, and z by r (for holes)
module pivot(r=0) {
  rotate([90,0,r]) children();
}

// scale into an oval with specified diameter and width
module ovalize(d, w) {
  scale([1,w/d,1]) children();
}

// minkowski sum children with a square of width sq
module squarish(sq) {
  if (sq > 0) minkowski() {
    children();
    cube([sq,sq,0.00001], center=true);
  } else children();
}

// tone or embouchure hole
// (b)ore (h)eight (d)iameter (w)idth (r)otate° w(a)ll°
// (s)houlder° (sq)areness
module hole(z=0, b, h, d, w, r=0, a=0, s=0, sq=0) {
  w = w==undef ? d : w;
  rh = b/2 + h; // bore radius + height
  ih = sqrt(pow(rh,2)-pow(d/2,2)); // inner hole depth
  oh = rh-ih; // outer hole height
  di = d+tan(a)*2*ih; // inner hole diameter
  do = d+tan(s)*2*oh; // outer hole diameter
  sqx = sq*d; // square part
  fn = fns((d+w)/2); // segment resolution
  // position/scale/rotate
  slide(z) pivot(r) ovalize(d, w) squarish(sqx) {
    // angled wall
    cylinder(d1=di-sqx, d2=d-sqx, h=ih, $fn=fn);
    // shoulder cut
    slide(ih) cylinder(d1=d-sqx, d2=do-sqx, h=oh, $fn=fn);
  }
}
