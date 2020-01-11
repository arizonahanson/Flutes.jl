
$fa=0.5;
$fs=0.1;


difference() {
    //body
    union() {
        hull() {
            translate([0,0,166.8]) cylinder(d=20.0,h=6);
            translate([0,0,132.8])
                intersection() {
                    cylinder(d=26.0,h=34.0);
                    translate([0,0,17])
                    rotate([0,90,0])
                        scale([1,26/34,1])
                        cylinder(d=34,h=13);
                }
            translate([0,0,126.8]) cylinder(d=20,h=6);
        }
        cylinder(d=20,h=126.8);
    }
    //bore
    hull() {
        translate([0,0,165.8])
            cylinder(d=16.9,h=1);
        translate([0,0,149.8])
            cylinder(d=17.4,h=1);
        translate([0,0,-0.01])
            cylinder(d=19.0,h=1);
    }
    //hole
	translate([0,0,149.8])
		rotate([-21,90,0])
            scale([1, 5.0/6.0, 1])
                cylinder(h=13.0, d1=17.4, d2=12.0);
}
