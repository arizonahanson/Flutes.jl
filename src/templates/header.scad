
$fa=1.0; // min angle
$fs=0.1; // min segment
$fl=0.162; // layer height
$fd=0.4; // nozzle diameter

// translate +z axis
module up(z=$fl) {
  translate([0,0,z]) children();
}

// translate z, then cylinder d, h=l
module turn(z=0, d=2*$fd, l=$fl) {
  up(z) cylinder(d=d, h=l);
}

// turn, but add $fd to diameter
module bore(z=0, d=2*$fd, l=$fl) {
  turn(z=z, d=d+$fd, l=l);
}

// hole cut
module hole(z=0, b, h, d, s, u=0, r=0, o=0) {
  s = (s==undef) ? d : s;
  rz=b/2;
  zo=sqrt(pow(rz+h,2)-pow(d/2,2));
  oh=rz+h-zo;
  do=d+tan(o)*2*oh;
  di=d+tan(u)*2*zo;
  zi=sqrt(pow(rz,2)-pow(di/2,2));
  ih=rz+h-zi-oh+$fl;
  up(z) // position
    scale([1,1,s/d]) // eccentricity
      rotate([-r,90,0]) // rotation
        union() {
          up(zo) // shoulder cut
            cylinder(d1=d, d2=do, h=oh);
          // undercut
          up(zi)
            cylinder(d1=di, d2=d, h=ih);
        }
}

// example
difference() {
  turn(d=26,l=50);
  bore(z=-$fl, d=17.4, l=50+2*$fl);
  hole(z=40, b=17.4, h=4.3, d=8);
  hole(z=17, b=17.4, h=4.3, d=10, s=12, u=7, r=-22, o=10);
}

