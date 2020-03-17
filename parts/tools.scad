/*
 * tools.scad
 *   various flute-making tools
 *   `include` to get vars
 */
include <env.scad>;

// translate +z axis
module slide(z=$fl) {
  translate([0,0,z]) children();
}

// rotate x by r, y by 90 and z by -90
module pivot(r=0) {
  rotate([r,90,-90]) children();
}

// translate z, then cylinder d1=b, d2=b2|b, h=l
module shell(z=0, b, b2, l=$fl) {
  b2 = (b2==undef) ? b : b2;
  slide(z) cylinder(d1=b, d2=b2, h=l);
}

// like shell, but fuzz the diameter and position
module bore(z=0, b, b2, l=$fl) {
  shell(z=z-0.001, b=b+$fd, b2=b2, l=l+0.002);
}

// tone or embouchure hole
module hole(z=0, b, h, d, s, r=0, u=0, o=0) {
  s = (s==undef) ? d : s;
  rz=b/2;
  zo=sqrt(pow(rz+h,2)-pow(d/2,2));
  oh=rz+h-zo;
  do=d+tan(o)*2*oh;
  di=d+tan(u)*2*zo;
  zi=sqrt(pow(rz+$fd/2,2)-pow(di/2,2));
  ih=rz+h-zi-oh;
  slide(z) // position
    scale([1,1,s/d]) // eccentricity
      pivot(-r) // rotation
        union() {
          // shoulder cut
          shell(z=zo, b=d, b2=do, l=oh+0.001);
          // undercut
          shell(z=zi, b=di, b2=d, l=ih+0.001);
        }
}
