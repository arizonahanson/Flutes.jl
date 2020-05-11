/*
 * Various flute-making tools
 */
include <consts.scad>;

// used to calculate number of polygon segments ($fn)
function fn(b) = floor(PI*b/NOZZLE_DIAMETER/4)*4;

// used to calculate diameter of inscribed polygon
function ins(b) = sqrt(pow(NOZZLE_DIAMETER,2) + 4*pow(1/cos(180/$fn)*b/2,2));

// translate +z axis
module slide(z=LAYER_HEIGHT) {
  translate([0,0,z]) children();
}

// rotate x by r, y by 90 and z by -90 (for holes)
module pivot(r=0) {
  rotate([r,90,-90]) children();
}

// translate z, then cylinder d1=b, d2=b2|b, h=l
module shell(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT) {
  b2 = (b2==undef) ? b : b2;
  maxfn = fn(max(b, b2));
  slide(z) cylinder(d1=b, d2=b2, h=l, $fn=maxfn);
}

// like shell, but inscribed polygon and micron z variance
module bore(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT) {
  b2 = (b2==undef) ? b : b2;
  maxfn = fn(max(b, b2));
  ex = NOZZLE_DIAMETER;
  slide(z-0.001) cylinder(d1=ins(b+ex, $fn=maxfn), d2=ins(b2+ex, $fn=maxfn), h=l+0.002, $fn=maxfn);
}

module chamfer(z=0, b=NOZZLE_DIAMETER, b2, fromend=false) {
  b2 = (b2==undef) ? b+NOZZLE_DIAMETER : b2;
  lz = abs(b2-b)/2;
  zz = !fromend ? z : z-lz;
  shell(z=zz, b=b, b2=b2, l=lz);
}

// tone or embouchure hole
// (b)ore (h)eight (d)iameter (w)idth (r)otate° w(a)ll°
// (s)houlder° (sq)areness
module hole(z=0, b, h, d, w, r=0, a=0, s=0, sq=0) {
  w = (w==undef) ? d : w;
  maxfn = fn(max(d, w));
  rb=b/2;// bore radius
  ih=sqrt(pow(rb+h,2)-pow(d/2,2));//hole z
  oh=rb+h-ih;//shoulder height
  di=d+tan(a)*2*ih;//d+wall angle
  do=d+tan(s)*2*oh;//d+shoulder cut
  sqx=sq*d;
  ex = NOZZLE_DIAMETER/2;
  slide(z) scale([1,1,w/d]) pivot(-r)
    if (sqx>=0.01) {
      minkowski() {
        cube([sqx,sqx,0.001], center=true);
        union() {
          // shoulder cut
          shell(z=ih, b=ins(d-sqx+ex, $fn=maxfn), b2=ins(do-sqx+ex, $fn=maxfn), l=oh);
          // angled wall
          shell(b=ins(di-sqx+ex, $fn=maxfn), b2=ins(d-sqx+ex, $fn=maxfn), l=ih+0.001);
        }
      }
    } else {
      union() {
        // shoulder cut
        shell(z=ih, b=ins(d+ex, $fn=maxfn), b2=ins(do+ex, $fn=maxfn), l=oh);
        // angled wall
        shell(b=ins(di+ex, $fn=maxfn), b2=ins(d+ex, $fn=maxfn), l=ih+0.001);
      }
    }
}
