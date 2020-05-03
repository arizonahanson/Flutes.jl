/*
 * Various flute-making tools
 */
include <consts.scad>;

// used to calculate number of segments
function fn(b) = floor(PI*b/4/(NOZZLE_DIAMETER-0.01))*4;

// translate +z axis
module slide(z=LAYER_HEIGHT) {
  translate([0,0,z]) children();
}

// translate z, then cylinder d1=b, d2=b2|b, h=l
module shell(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT) {
  b2 = (b2==undef) ? b : b2;
  maxfn = fn(max(b, b2));
  slide(z) cylinder(d1=b, d2=b2, h=l, $fn=maxfn);
}

module chamfer(z=0, b=NOZZLE_DIAMETER, b2, fromend=false) {
  b2 = (b2==undef) ? b+NOZZLE_DIAMETER : b2;
  lz = abs(b2-b)/2;
  zz = !fromend ? z : z-lz;
  shell(z=zz, b=b, b2=b2, l=lz);
}

// used to correct hole sizes
function fuzz(b) = NOZZLE_DIAMETER + sqrt(pow(NOZZLE_DIAMETER,2) + 4*pow(1/cos(180/$fn)*b/2,2));

// like shell, but fuzz the diameter and position
module bore(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT) {
  b2 = (b2==undef) ? b : b2;
  maxfn = fn(max(b, b2));
  slide(z-0.001) cylinder(d1=fuzz(b, $fn=maxfn), d2=fuzz(b2, $fn=maxfn), h=l+0.002, $fn=maxfn);
}

// rotate x by r, y by 90 and z by -90 (for holes)
module pivot(r=0) {
  rotate([r,90,-90]) children();
}

// tone or embouchure hole
// (b)ore (h)eight (d)iameter (w)idth (r)otate° w(a)ll°
// (s)houlder° (sq)areness
module hole(z=0, b, h, d, w, r=0, a=0, s=0, sq=0) {
  w = (w==undef) ? d : w;
  rz=b/2;// bore radius
  zo=sqrt(pow(rz+h,2)-pow(d/2,2));//hole z
  di=d+tan(a)*2*zo;//d+wall angle
  oh=rz+h-zo;//shoulder height
  do=d+tan(s)*2*oh;//d+shoulder cut
  sqx=sq*d;
  slide(z) scale([1,1,w/d]) pivot(-r)
    if (sqx>=0.01) {
      minkowski() {
        cube([sqx,sqx,0.001], center=true);
        union() {
          // shoulder cut
          shell(z=zo, b=d-sqx, b2=do-sqx, l=oh);
          // angled wall
          shell(b=di-sqx, b2=d-sqx, l=zo);
        }
      }
    } else {
      union() {
        // shoulder cut
        shell(z=zo, b=d, b2=do, l=oh);
        // angled wall
        shell(b=di, b2=d, l=zo+0.001);
      }
    }
}
