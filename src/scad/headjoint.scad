
$fa=0.1;
$fs=0.1;

difference() {
    union() {
        //body
        cylinder(d1=20.0,d2=18.4,h=166.8);
        translate([0,0,131.8])
            cylinder(d=26.0,h=36);
    }
    //bore
	translate([0,0,-0.01])
		cylinder(d1=19.0,d2=17.4,h=166.8);
    //hole
	translate([0,0,149.8])
		rotate([0,90,0])
            scale([1, 5.0/6.0, 1])
                cylinder(h=13.0, d1=12.0, d2=12.0);
}
