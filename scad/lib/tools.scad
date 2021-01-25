/*
 * Various flute-making tools
 */
include <consts.scad>;

// next positive multiple of 4 for n
function roundup(n) = max(ceil(n/4)*4, 4);

// number of polygon segments ($fn) for diameter d
function seg(d) = roundup(PI*d/NOZZLE_DIAMETER);

// indiameter of polygon that circumscribes a circle of diameter d
// with arc compensation
function circ(d, fn) =
  let(n = fn ? fn : seg(d))
  sqrt(pow(NOZZLE_DIAMETER,2) + 4*pow((1/cos(180/n)*d)/2,2));

// translate +z axis
module slide(z=LAYER_HEIGHT) {
  translate([0,0,z]) children();
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
module squarify(sq) {
  if (sq > 0) minkowski() {
    children();
    cube([sq,sq,0.00001], center=true);
  } else children();
}

// Frustum circumscribes a truncated cone
module frustum(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT) {
  b2 = (b2==undef) ? b : b2;
  fn = seg(max(b, b2)); // adaptive resolution
  slide(z) cylinder(d1=circ(b, fn), d2=circ(b2, fn), h=l, $fn=fn);
}

// tube: difference of two frustums
module tube(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT, h=NOZZLE_DIAMETER, h2) {
  b2 = (b2==undef) ? b : b2;
  h2 = (h2==undef) ? h : h2;
  difference() {
    frustum(z=z, b=b+2*h, b2=b2+2*h2, l=l);
    frustum(z=z, b=b, b2=b2, l=l);
  }
}

// tone or embouchure hole
// (b)ore (h)eight (d)iameter (w)idth (r)otate° w(a)ll°
// (s)houlder° (sq)areness
module hole(z=0, b, h, d, w, r=0, a=0, s=0, sq=0) {
  w = w==undef ? d : w;
  rh = circ(b + h*2)/2; // outer circumscribed tube radius
  ih = sqrt(pow(rh,2)-pow(d/2,2)); // inner hole depth
  oh = rh-ih; // outer hole height
  di = d+tan(a)*2*ih; // inner hole diameter
  do = d+tan(s)*2*oh; // outer hole diameter
  sqx = sq*d; // square part
  fn = seg((d+w)/2); // segment resolution
  // position/scale/rotate
  slide(z) pivot(r) ovalize(d, w) squarify(sqx) {
    // angled wall
    cylinder(d1=di-sqx, d2=d-sqx, h=ih, $fn=fn);
    // shoulder cut
    slide(ih) cylinder(d1=d-sqx, d2=do-sqx, h=oh, $fn=fn);
  }
}
