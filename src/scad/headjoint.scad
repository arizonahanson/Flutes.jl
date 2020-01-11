
$fa=0.5;
$fs=0.1;
outer=22;
difference() {
    //body
    union() {
        hull() {
            translate([0,0,166.8])
                cylinder(d=outer,h=8);
            translate([0,0,124.8])
                intersection() {
                    cylinder(d=26,h=50);
                    translate([0,0,25])
                        rotate([0,90,0])
                            scale([1,0.5,1])
                                cylinder(d2=50,d1=44,h=13);
                }
            translate([0,0,120.8])
                cylinder(d=outer,h=4);
        }
        translate([0,0,40])
            cylinder(d=outer,h=80.8);
        cylinder(d=20,h=40);
    }
    //bore
    hull() {
        translate([0,0,165.8])
            cylinder(d=16.9,h=1);
        translate([0,0,149.8])
            cylinder(d=17.4,h=1);
        translate([0,0,-0.01])
            cylinder(d=19,h=1);
    }
    //hole
	translate([0,0,149.8])
		rotate([-21,90,0])
            scale([1, 5/6, 1])
                cylinder(h=13, d1=17.4, d2=12);
}
