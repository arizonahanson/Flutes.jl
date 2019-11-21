

module hcylinder(r1=10,r2=10,w=2,h=10) {
  difference() {
    cylinder(r1=r1+w,r2=r2+w,h=h);
    translate([0,0,-0.005])
      cylinder(r1=r1,r2=r2,h=h+0.01);
  }
}

module hole(pos=0,r1=2,r2=2,h=10) {
  translate([0,0,pos])
    rotate([0,-90,0])
      cylinder(r1=r1,r2=r2,h=h);
}
