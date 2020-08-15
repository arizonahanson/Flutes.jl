/*
 * Various flute-making tools
 */
include <consts.scad>;

// make multiple of quantity
function quant(b, n) = ceil(b/n)*n;

// used to calculate number of polygon segments ($fn) multiple of 4
function fn(b) = quant(max(PI*b/NOZZLE_DIAMETER,4),4);

// segments for maximum of two diameters
function maxfn(b, b2) = fn(max(b, b2));

// used to calculate diameter of circumscribed polygon
function cir(b, n) = 1/cos(180/n)*b;

// used to calculate circumscribed polygon with arc compensation
function arc(b, n) = sqrt(pow(NOZZLE_DIAMETER,2) + 4*pow(cir(b, n)/2,2));

// translate +z axis
module slide(z=LAYER_HEIGHT) {
  translate([0,0,z]) children();
}

// translate z, then cylinder d1=b, d2=b2|b, h=l
module shell(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT) {
  b2 = (b2==undef) ? b : b2;
  slide(z) cylinder(d1=b, d2=b2, h=l, $fn=maxfn(b, b2));
}

// like shell, but circumscribed polygon and micron z variance
module bore(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT) {
  bx = b + NOZZLE_DIAMETER;
  bx2 = (b2==undef ? b : b2) + NOZZLE_DIAMETER;
  fn = maxfn(bx, bx2); // adaptive resolution
  slide(z-0.001) cylinder(d1=arc(bx, fn), d2=arc(bx2, fn), h=l+0.002, $fn=fn);
}

// tube: bore with a shell wall
module tube(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT, h=NOZZLE_DIAMETER, h2) {
  b2 = (b2==undef) ? b : b2;
  h2 = (h2==undef) ? h : h2;
  difference() {
    shell(z=z, b=b+2*h, b2=b2+2*h2, l=l);
    bore(z=z, b=b, b2=b2, l=l);
  }
}

// rotate x by 90, and z by r (for holes)
module pivot(r=0) {
  rotate([90,0,r]) children();
}

// scale into an oval with speciied diameter and width
module ovalize(d, w) {
  scale([1,w/d,1]) children();
}

// minkowski sum children with a square of width sq
module squarish(sq) {
  if (sq>=0.001) {
    minkowski() {
      cube([sq,sq,0.001], center=true);
      children();
    }
  } else {
    children();
  }
}

// tone or embouchure hole
// (b)ore (h)eight (d)iameter (w)idth (r)otate° w(a)ll°
// (s)houlder° (sq)areness
module hole(z=0, b, h, d, w, r=0, a=0, s=0, sq=0) {
  dx = d + NOZZLE_DIAMETER;
  w = quant((w==undef ? d : w),LAYER_HEIGHT);
  rh = b/2 + h; // bore radius + height
  ih = sqrt(pow(rh,2)-pow(dx/2,2)); // inner hole depth
  oh = rh-ih; // outer hole height
  di = dx+tan(a)*2*ih; // inner hole diameter
  do = dx+tan(s)*2*oh; // outer hole diameter
  sqx = sq*dx; // square part
  dq = dx-sqx; doq = do-sqx; diq=di-sqx;
  ofn = maxfn(dq, doq); // outer segments
  ifn = maxfn(dq, diq); // inner segments
  // position/scale/rotate
  slide(z) pivot(r)
    ovalize(dx, w) squarish(sqx) {
      // angled wall
      shell(b=cir(diq, ifn), b2=cir(dq, ifn), l=sqx>=0.001?ih:ih+0.001);
      // shoulder cut
      shell(z=ih, b=cir(dq, ofn), b2=cir(doq, ofn), l=oh);
    }
}
