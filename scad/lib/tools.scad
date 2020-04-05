/*
 * Various flute-making tools
 */
include <consts.scad>;

// translate +z axis
module slide(z=LAYER_HEIGHT) {
  translate([0,0,z]) children();
}

// translate z, then cylinder d1=b, d2=b2|b, h=l
module shell(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT) {
  b2 = (b2==undef) ? b : b2;
  slide(z) cylinder(d1=b, d2=b2, h=l);
}

module chamfer(z=0, b=NOZZLE_DIAMETER, b2, fromend=false) {
  b2 = (b2==undef) ? b+NOZZLE_DIAMETER : b2;
  lz = abs(b2-b)/2;
  zz = !fromend ? z : z-(2*lz);
  shell(z=zz, b=b, b2=b2, l=lz);
}

// used to correct hole sizes
function fuzz(b) = NOZZLE_DIAMETER + sqrt(pow(NOZZLE_DIAMETER,2) + 4*pow(1/cos(180/$fn)*b/2,2));

// like shell, but fuzz the diameter and position
module bore(z=0, b=NOZZLE_DIAMETER, b2, l=LAYER_HEIGHT) {
  b2 = (b2==undef) ? b : b2;
  shell(z=z-0.001, b=fuzz(b), b2=fuzz(b2), l=l+0.002);
}

// rotate x by r, y by 90 and z by -90 (for holes)
module pivot(r=0) {
  rotate([r,90,-90]) children();
}

// tone or embouchure hole
module hole(z=0, b, h, d, s, r=0, u=0, o=0, sq=0) {
  s = (s==undef) ? d : s;
  rz=b/2;
  zo=sqrt(pow(rz+h,2)-pow(d/2,2));
  di=d+tan(u)*2*zo;
  zi=sqrt(pow(rz,2)-pow(di/2,2));
  oh=rz+h-zo;
  ih=zo-zi;
  do=d+tan(o)*2*oh;
  slide(z) scale([1,1,s/d]) pivot(-r)
    if (sq>0) {
      minkowski() {
        cube([sq,sq,0.0001], center=true);
        union() {
          // shoulder cut
          shell(z=zo, b=d-sq, b2=do-sq, l=oh, $fn=64);
          // undercut
          shell(z=zi+0.001, b=di-sq, b2=d-sq, l=ih, $fn=64);
        }
      }
    } else {
      union() {
        // shoulder cut
        shell(z=zo, b=d, b2=do, l=oh);
        // undercut
        shell(z=zi+0.001, b=di, b2=d, l=ih);
      }
    }
}
