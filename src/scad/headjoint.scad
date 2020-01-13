
$fa=1.0;
$fs=0.1;
outer=23;
difference() {
    // body
    union() {
        // lip plate
        hull() {
            cylinder(d=outer,h=5);
            translate([0,0,5])
                intersection() {
                    cylinder(d=26,h=50);
                    translate([0,0,25])
                        rotate([0,90,0])
                            scale([1,0.6,1])
                                cylinder(d2=50,d1=outer/.6,h=13);
                }
            translate([0,0,55])
                cylinder(d=outer,h=5);
        }
        translate([0,0,60])
            cylinder(d=outer,h=96);
        // tenon
        translate([0,0,156])
            cylinder(d=outer-2,h=30);
    }
    // bore
    translate([0,0,13])
        union() {
            hull() {
                cylinder(d=17,h=1);
                translate([0,0,11])
                    cylinder(d=17.4,h=12);
                translate([0,0,142])
                    cylinder(d=19,h=1.01);
            }
            translate([0,0,143])
                cylinder(d=19,h=30.01);
        }
    // hole
	translate([0,0,30])
		rotate([21,90,0])
            scale([1, 5/6, 1])
                cylinder(h=13.01, d1=17.4, d2=12);
}

