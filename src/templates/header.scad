
$fa=1.0; // min angle
$fs=0.1; // min segment
$fl=0.162; // layer height
$fd=0.4; // nozzle diameter

// translate +z axis
module up(z=$fl) {
  translate([0,0,z]) children();
}

// translate z, then cylinder d=b, h=l
module turn(z=0, b=2*$fd, l=$fl) {
  up(z) cylinder(d=b, h=l);
}

// fudge the bore diameter
function fdge(b) {
  return b+$fd;
}

// like turn, but fuzz the diameter and position
module bore(z=0, b=2*$fd, l=$fl) {
  turn(z=z-0.0005, b=fdge(b), l=l+0.001);
}

// tone or embouchure hole
module hole(z=0, b, h, d, s, r=0, u=0, o=0) {
  s = (s==undef) ? d : s;
  rz=b/2;
  zo=sqrt(pow(rz+h,2)-pow(d/2,2));
  oh=rz+h-zo;
  do=d+tan(o)*2*oh;
  di=d+tan(u)*2*zo;
  zi=sqrt(pow(fdge(rz)/2,2)-pow(di/2,2));
  ih=rz+h-zi-oh;
  up(z) // position
    scale([1,1,s/d]) // eccentricity
      rotate([-r,90,0]) // rotation
        union() {
          // shoulder cut
          up(zo)
            cylinder(d1=d, d2=do, h=oh+0.0005);
          // undercut
          up(zi)
            cylinder(d1=di, d2=d, h=ih+0.0005);
        }
}

// example
difference() {
  b=17.4; h=4.3;
  // outer
  turn(b=b+2*h,l=50);
  // inner bore
  bore(b=b, l=50);
  // tone-hole style
  hole(z=42, b=b, h=h, d=7);
  // embouchure style
  hole(z=17, b=b, h=h, d=10, s=12, u=7, r=-22, o=7);
}

