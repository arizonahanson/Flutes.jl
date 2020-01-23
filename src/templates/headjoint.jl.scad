
$fa=1.0;
$fs=0.1;
dplate={{⌀ₑ}}+2*{{ℎₑ}};
dtenon={{⌀ₛ}}+{{ℎₛ}};
hplate=dplate-{{⌀₀}};
edepth=2*(dplate-(({{⌀ₑ}}/2)^2-({{𝑑ₑ}}/2)^2)^0.5);
translate([0,0,{{ℓ₀}}])
  difference() {
    // outer shell
    union() {
        translate([0,0,-{{ℓ₀}})
          cylinder(d={{⌀₀}},h={{ℓ₀}}+{{ℓₐ}}-30);
        // tenon
        translate([0,0,{{ℓₐ}}-30])
          cylinder(d=dtenon,h=30);
        // lip-plate
        translate([0,0,-25-hplate])
          hull() {
            cylinder(d={{⌀₀}},h={{ℓ₊}});
            translate([0,0,hplate])
              intersection() {
                cylinder(d=dplate,h=50);
                translate([0,0,25)
                  rotate([0,90,0])
                    scale([dplate/50,1,1])
                      cylinder(d=50,h=dplate);
              }
            translate([0,0,50+2*hplate-{{ℓ₊}}])
              cylinder(d={{⌀₀}},h={{ℓ₊}});
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
