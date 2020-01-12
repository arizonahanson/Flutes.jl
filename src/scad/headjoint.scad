
$fa=0.5;
$fs=0.1;
od=21;
difference() {
    // body
    union() {
        hull() {
            cylinder(d=od,h=5);
            translate([0,0,5])
                // lip plate
                intersection() {
                    cylinder(d=26,h=50);
                    translate([0,0,25])
                        rotate([0,90,0])
                            scale([1,0.5,1])
                                cylinder(d2=50,d1=42,h=13);
                }
            translate([0,0,55])
                cylinder(d=od,h=5);
        }
        translate([0,0,60])
            cylinder(d=od,h=115);
    }
    // bore
    translate([0,0,13])
        hull() {
            cylinder(d=17,h=1);
            translate([0,0,11])
                cylinder(d=17.4,h=12);
            translate([0,0,161])
                cylinder(d=19,h=1.01);
        }
    // hole
	translate([0,0,30])
		rotate([21,90,0])
            scale([1, 5/6, 1])
                cylinder(h=13.01, d1=17.4, d2=12);
}

