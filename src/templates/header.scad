
$fa=1.0; // min angle
$fs=0.1; // min segment
$fl=0.162; // layer height
$fd=0.4; // nozzle diameter

// translate +z axis
module slide(z=$fl) {
  translate([0,0,z]) children();
}

module pivot(r=0) {
  rotate([r,90,-90]) children();
}

// translate z, then cylinder d=b, h=l
module shell(z=0, b=2*$fd, l=$fl) {
  slide(z) cylinder(d=b, h=l);
}

// like shell, but fuzz the diameter and position
module bore(z=0, b=2*$fd, l=$fl) {
  shell(z=z-0.001, b=b+$fd, l=l+0.002);
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
          slide(zo)
            cylinder(d1=d, d2=do, h=oh+0.001);
          // undercut
          slide(zi)
            cylinder(d1=di, d2=d, h=ih+0.001);
        }
}

// lip-plate
module plate(z=0, b, h, l, r=0) {
  od=b+2*h;
  slide(-l-h+z)
    rotate([0,0,r])
      hull() {
        shell(b=b);
        slide(h)
          intersection() {
            shell(b=od,l=2*l);
            slide(l) pivot() scale([1,od/l,1])
              cylinder(d2=2*l, d1=b, h=od/2);
          }
        shell(z=2*l+2*h, b=b);
      }
}

// example
difference() {
  b=17.4; h=2;
  // outer
  union() {
    shell(b=b+2*h,l=100);
    // plate
    plate(z=32, b=b, h=4.3, l=24, r=22);
  }
  // inner bore
  bore(b=b, l=100);
  // tone-hole style
  hole(z=70, b=b, h=h, d=7);
  hole(z=75, b=b, h=h, d=2, r=20);
  // embouchure style
  hole(z=32, b=b, h=4.3, d=10, s=12, u=8, o=5);
}

