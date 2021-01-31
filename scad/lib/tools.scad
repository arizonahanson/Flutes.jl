/*
 * Various flute-making tools
 */
include <consts.scad>;

// number of polygon segments (fn) for diameter d
function seg(d) =
  let(fn = PI*d/SEGMENT_SIZE) // segments
  max(floor(fn/4)*4, 4); // round down to multiple 4

// diameter of circle that circumscribes a polygon
// with 'fn' sides and the same area as a circle with diameter 'd'
//  polygon area: a = fn*pow(r,2)*tan(180/fn)
function circ(d, fn) =
  let(a = PI*pow(d/2,2)) // target circle area
  let(fn = fn ? fn : seg(d)) // number of sides
  let(r = sqrt(a/fn/tan(180/fn))) // polygon apothem
  2*r/cos(180/fn); // circumscribe diameter

// shrink correction (set SHRINK_FACTOR=0 to disable)
function grow(d, fn) =
  circ(d, fn)/(1-SHRINK_FACTOR);

// translate +z axis
module slide(z=0) {
  translate([0,0,z]) children();
}

// rotate 90 around x, by r around z (Y becomes Z)
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
module frustum(z=0, b, b2, l=LAYER_HEIGHT, fn, grow=true) {
  b2 = b2 ? b2 : b;
  fn = fn ? fn : seg(max(b, b2)); // adaptive resolution
  d1 = grow ? grow(b, fn) : circ(b, fn);
  d2 = grow ? grow(b2, fn) : circ(b2, fn);
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
  w = w ? w : d; // default to circular
  fn = seg((d+w)/2); // polygon segments
  ud = grow(d, fn); // grow hole X axis here
  rh = grow(b + 2*h)/2; // outer tube radius (unshrunk)
  ih = sqrt(pow(rh,2)-pow(ud/2,2)); // inner hole depth
  oh = rh-ih; // outer hole height
  di = ud+tan(a)*2*ih; // inner hole diameter
  do = ud+tan(s)*2*oh; // outer hole diameter
  sqx = sq*ud; // square part
  // position/rotate/scale/minkowski
  slide(z) pivot(r) stretch(w/ud) squarify(sqx) {
    // hole with angled wall
    frustum(b=di-sqx, b2=ud-sqx, l=ih, fn=fn, grow=0);
    // outer shoulder cut
    frustum(z=ih, b=ud-sqx, b2=do-sqx, l=oh, fn=fn, grow=0);
  }
}
