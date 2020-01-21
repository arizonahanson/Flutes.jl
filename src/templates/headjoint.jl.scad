
$fa=1.0;
$fs=0.1;
dplate={{⌀ₑ}}+2*{{ℎₑ}};
douter={{⌀ₛ}}+2*{{ℎₛ}};
dtenon={{⌀ₛ}}+{{ℎₛ}};
hplate=dplate-outer;
edepth=2*(dplate-(({{⌀ₑ}}/2)^2-({{𝑑ₑ}}/2)^2)^0.5);
translate([0,0,{{ℓ₀}}])
  difference() {
    // outer shell
    union() {
        translate([0,0,-{{ℓ₀}})
          cylinder(d=douter,h={{ℓ₀}}+{{ℓₐ}}-30);
        // tenon
        translate([0,0,{{ℓₐ}}-30])
          cylinder(d=dtenon,h=30);
        // lip-plate
        translate([0,0,-{{ℓₑ}}-hplate])
          hull() {
            cylinder(d=douter,h={{ℓ₊}});
            translate([0,0,hplate])
              intersection() {
                cylinder(d=dplate,h=2*{{ℓₑ}});
                translate([0,0,{{ℓₑ}}])
                  rotate([0,90,0])
                    scale([dplate/2*{{ℓₑ}},1,1])
                      cylinder(d=2*{{ℓₑ}},h=dplate);
              }
            translate([0,0,2*{{ℓₑ}}+2*hplate-{{ℓ₊}}])
              cylinder(d=douter,h={{ℓ₊}});
          }
      }
    }
    // bore
    union() {
      hull() {
        translate([0,0,{{ℓ₊}}-{{ℓᵣ}}])
          cylinder(d={{⌀ᵣ}}+{{⌀₊}},h={{ℓ₊}});
        translate([0,0,-{{𝑑ₑ}}/2])
          cylinder(d={{⌀ₑ}}+{{⌀₊}},h={{𝑑ₑ}});
        translate([0,0,{{ℓₛ}}])
          cylinder(d={{⌀ₛ}}+{{⌀₊}},h={{ℓ₊}});
      }
      translate([0,0,{{ℓₛ}}])
        cylinder(d={{⌀ₛ}}+{{⌀₊}},h={{ℓₐ}}-{{ℓₛ}}+{{ℓ₊}});
    }
    // hole
    translate([0-dplate/2,0,0])
      rotate([atan({{𝑠ₑ}}/{{𝑑ₑ}}/2)*180/PI,-90,0])
        scale([({{𝑠ₑ}}-{{⌀₊}}/2)/{{𝑑ₑ}}, 1, 1])
          cylinder(h=edepth, d1={{𝑑ₑ}}, d2={{𝑑ₑ}}+tan({{𝜙ₑ}})*edepth);
  }
