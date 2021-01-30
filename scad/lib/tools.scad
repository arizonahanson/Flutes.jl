/*
 * Various flute-making tools
 */
include <consts.scad>;

// number of polygon segments ($fn) for diameter d
// multiple of four
function seg(d) =
  let(ns = PI*d/SEGMENT_SIZE)
  max(floor(ns/4)*4, 4);

// circumscribed polygon
function circ(d, fn) =
  let(n = (fn == undef) ? seg(d) : fn)
  d/cos(180/n);

// shrink correction
function unshrink(d, fn) =
  circ(d, fn)/(1-SHRINK_FACTOR);

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
    cube([sq,sq,NIL], center=true);
  } else children();
}

module frustum(z=0, b=SEGMENT_SIZE, b2, l=LAYER_HEIGHT, fn=0, unshrink=false) {
  b2 = (b2 == undef) ? b : b2;
  ffn = fn ? fn : seg(max(b, b2)); // adaptive resolution
  cb = unshrink ? unshrink(b, ffn) : circ(b, ffn);
  cb2 = unshrink ? unshrink(b2, ffn) : circ(b2, ffn);
  slide(z) cylinder(d1=cb, d2=cb2, h=l, $fn=ffn);
}

// tube: difference of two frustums
module tube(z=0, b=SEGMENT_SIZE, b2, l=LAYER_HEIGHT, h=SEGMENT_SIZE, h2) {
  b2 = (b2==undef) ? b : b2;
  h2 = (h2==undef) ? h : h2;
  difference() {
    frustum(z=z, b=b+2*h, b2=b2+2*h2, l=l, unshrink=true);
    frustum(z=z, b=b, b2=b2, l=l, unshrink=true);
  }
}

// tone or embouchure hole
// (b)ore (h)eight (d)iameter (w)idth (r)otate° w(a)ll°
// (s)houlder° (sq)areness
module hole(z=0, b, h, d, w, r=0, a=0, s=0, sq=0) {
  w = w==undef ? d : w;
  rh = unshrink(b + 2*h)/2; // outer tube radius
  ih = sqrt(pow(rh,2)-pow(d/2,2)); // inner hole depth
  oh = rh-ih; // outer hole height
  di = d+tan(a)*2*ih; // inner hole diameter
  do = d+tan(s)*2*oh; // outer hole diameter
  sqx = sq*d; // square part
  fn = seg((d+w)/2); // polygon segments
  // position/scale/rotate
  slide(z) pivot(r) ovalize(d, w) squarify(sqx) {
    // angled wall
    frustum(b=di-sqx, b2=d-sqx, l=ih, fn=fn);
    // shoulder cut
    frustum(z=ih, b=d-sqx, b2=do-sqx, l=oh, fn=fn);
  }
}
