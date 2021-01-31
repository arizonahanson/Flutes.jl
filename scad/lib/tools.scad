/*
 * Various flute-making tools
 */
include <consts.scad>;

// number of polygon segments ($fn) for diameter d
// multiple of four
function seg(d) =
  let(fn = PI*d/SEGMENT_SIZE)
  max(floor(fn/4)*4, 4);

// circumscribed polygon
function circ(d, fn) =
  let(fn = fn ? fn : seg(d))
  d/cos(180/fn);

// shrink correction
function unshrink(d, fn) =
  circ(d, fn)/(1-SHRINK_FACTOR);

// translate +z axis
module slide(z=0) {
  translate([0,0,z]) children();
}

// rotate x by 90, and z by r (for holes)
module pivot(r=0) {
  rotate([90,0,r]) children();
}

// scale Y axis (Z after pivot())
module stretch(a=1) {
  scale([1,a,1]) children();
}

// minkowski sum children with a square of width sq
module squarify(sq=0) {
  if (sq > 0) minkowski() {
    children();
    cube([sq,sq,NANO], center=true);
  } else children();
}

// frustrum circumscribes diameters b, b2
module frustum(z=0, b, b2, l=LAYER_HEIGHT, fn, unshrink=true) {
  b2 = b2 ? b2 : b;
  fn = fn ? fn : seg(max(b, b2)); // adaptive resolution
  d1 = unshrink ? unshrink(b, fn) : circ(b, fn);
  d2 = unshrink ? unshrink(b2, fn) : circ(b2, fn);
  slide(z) cylinder(d1=d1, d2=d2, h=l, $fn=fn);
}

// tube: difference of two frustums
module tube(z=0, b=SEGMENT_SIZE, b2, l=LAYER_HEIGHT, h=SEGMENT_SIZE, h2) {
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
  fn = seg((d+w)/2); // polygon segments
  ud = unshrink(d, fn);
  rh = unshrink(b + 2*h)/2; // outer tube radius
  ih = sqrt(pow(rh,2)-pow(ud/2,2)); // inner hole depth
  oh = rh-ih; // outer hole height
  di = ud+tan(a)*2*ih; // inner hole diameter
  do = ud+tan(s)*2*oh; // outer hole diameter
  sqx = sq*ud; // square part
  // position/scale/rotate
  slide(z) pivot(r) stretch(w/ud) squarify(sqx) {
    // angled wall
    frustum(b=di-sqx, b2=ud-sqx, l=ih, fn=fn, unshrink=0);
    // shoulder cut
    frustum(z=ih, b=ud-sqx, b2=do-sqx, l=oh, fn=fn, unshrink=0);
  }
}
