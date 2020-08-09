/*
 * Various flute-making tools
 */
include <consts.scad>;

// used to calculate number of polygon segments ($fn) multiple of 4
function fn(b) = ceil(max(PI*b/NOZZLE_DIAMETER,4)/4)*4;

// segments for maximum of two diameters
function maxfn(b, b2) = fn(max(b, b2));

// used to calculate diameter of circumscribed polygon with arc compensation
function cir(b, n) = sqrt(pow(NOZZLE_DIAMETER,2) + 4*pow(1/cos(180/n)*b/2,2));

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
  slide(z-0.001) cylinder(d1=cir(bx, fn), d2=cir(bx2, fn), h=l+0.002, $fn=fn);
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

// rotate x by r, y by 90 and z by -90 (for holes)
module pivot(r=0) {
  rotate([r,90,-90]) children();
}

// tone or embouchure hole
// (b)ore (h)eight (d)iameter (w)idth (r)otate° w(a)ll°
// (s)houlder° (sq)areness
module hole(z=0, b, h, d, w, r=0, a=0, s=0, sq=0) {
  dx = d + NOZZLE_DIAMETER;
  wx = (w==undef ? d : w) + NOZZLE_DIAMETER;
  sqx = sq*dx; // square part
  rh = b/2 + h; // bore radius + height
  ih = sqrt(pow(rh,2)-pow(dx/2,2)); // inner hole depth
  oh = rh-ih; // outer hole height
  di = dx+tan(a)*2*ih; // inner hole diameter
  do = dx+tan(s)*2*oh; // outer hole diameter
  ofn = maxfn(dx-sqx, do-sqx); // outer segments
  ifn = maxfn(dx-sqx, di-sqx); // inner segments
  // position/scale/rotate
  slide(z) scale([1,1,wx/dx]) pivot(-r)
    if (sqx >= 0.001) {
      // squarish hole
      minkowski() {
        cube([sqx,sqx,0.001], center=true);
        union() {
          // shoulder cut
          shell(z=ih, b=cir(dx-sqx, ofn), b2=cir(do-sqx, ofn), l=oh);
          // angled wall
          shell(b=cir(di-sqx, ifn), b2=cir(dx-sqx, ifn), l=ih);
        }
      }
    } else {
      // round hole
      union() {
        // shoulder cut
        shell(z=ih, b=cir(dx, ofn), b2=cir(do, ofn), l=oh);
        // angled wall
        shell(b=cir(di, ifn), b2=cir(dx, ifn), l=ih+0.001);
      }
    }
}
