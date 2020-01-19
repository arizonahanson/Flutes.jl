
$fa=1.0;
$fs=0.1;
fd={{⌀ₓ}};
douter={{⌀₀}}+2*{{ℎ₀}};
dplate={{⌀ₑ}}+2*{{ℎₑ}};
dtenon={{⌀ₙ}}+2*{{ℎₙ}};
difference() {
  // outer shell
  union() {
      cylinder(d=douter,h={{ℓ₀}}+{{ℓₙ}});
      // lip-plate
      translate([0,0,{{ℓ₀}}-{{ℓₚ}}/2-(dplate-douter)])
        hull() {
          cylinder(d=douter,h=ld);
          translate([0,0,dplate-douter])
            intersection() {
              cylinder(d=dplate,h={{ℓₚ}});
              translate([0,0,{{ℓₚ}}/2])
                rotate([0,90,0])
                  scale([1,{{𝜙ₚ}}/{{ℓₚ}},1])
                    cylinder(d={{ℓₚ}},h=dplate);
            }
          translate([0,0,{{ℓₚ}}+(dplate-douter)-ld])
            cylinder(d=douter,h=ld);
        }
      // tenon
      translate([0,0,{{ℓ₀}}+{{ℓₙ}}])
        cylinder(d=dtenon,h={{ℓₐ}}-{{ℓₙ}});
    }
  }
  // bore
  // hole
  translate([0-dplate/2,0,{{ℓ₀}}])
    rotate([atan({{𝜙ₑ}}/{{𝑑ₑ}}/2)*180/PI,-90,0])
      scale([1, ({{𝜙ₑ}}-ld/2)/{{𝑑ₑ}}, 1])
        cylinder(h=dplate/2+ld, d1={{⌀ₑ}}, d2={{𝑑ₑ}});

}
