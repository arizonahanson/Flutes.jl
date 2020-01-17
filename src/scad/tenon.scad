$fa=1.0;
$fs=0.1;
noz=0.4;
outer=24.0;
inner=19.0+noz;
bevel=(outer-inner)/2;
slen=15.0;
tlen=10.0;
difference() {
    // body
    union() {
        // sounding length
        cylinder(d=outer,h=slen);
        // tenon
        translate([0,0,slen])
            cylinder(d=outer-bevel,h=tlen-bevel);
        translate([0,0,slen+tlen-bevel])
            hull() {
                cylinder(d=outer-bevel,h=bevel/2);
                translate([0,0,bevel/2])
                    cylinder(d=inner,h=bevel/2);
            }
    }
    // bore
    translate([0,0,-0.005])
        union() {
            // mortise
            cylinder(d=outer-bevel+noz,h=tlen - bevel + 0.01);
            translate([0,0,tlen-bevel])
                hull() {
                    cylinder(d=outer-bevel+noz,h=(bevel/2) + 0.01);
                    translate([0,0,bevel/2])
                        cylinder(d=inner,h=(bevel/2) + 0.01);
                }
            // sounding length
            translate([0,0,tlen])
                cylinder(d=inner,h=slen+0.01);
        }
}
