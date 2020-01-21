
$fa=1.0;
$fs=0.1;
douter={{⌀ᵦ}}+2*{{ℎᵦ}};
dplate={{⌀ₑ}}+2*{{ℎₑ}};
dtenon={{⌀ₙ}}+2*{{ℎₙ}};
hplate=dplate-outer;
difference() {
  // outer shell
  union() {
      cylinder(d=douter,h={{ℓ₀}}+{{ℓₙ}});
      // tenon
      translate([0,0,{{ℓ₀}}+{{ℓₙ}}])
        cylinder(d=dtenon,h={{ℓₐ}}-{{ℓₙ}});
      // lip-plate
      translate([0,0,{{ℓ₀}}-{{𝑑ₚ}}/2-hplate])
        hull() {
          cylinder(d=douter,h={{⌀₊}});
          translate([0,0,hplate])
            intersection() {
              cylinder(d=dplate,h={{𝑑ₚ}});
              translate([0,0,{{𝑑ₚ}}/2])
                rotate([0,90,0])
                  scale([{{𝑠ₚ}}/{{𝑑ₚ}},1,1])
                    cylinder(d={{𝑑ₚ}},h=dplate);
            }
          translate([0,0,{{𝑑ₚ}}+hplate-{{⌀₊}}])
            cylinder(d=douter,h={{⌀₊}});
        }
    }
  }
  // bore
  translate([0,0,{{ℓ₀}}-{{ℓᵣ}}])
    union() {
      hull() {
        cylinder(d={{⌀ᵣ}}+{{⌀₊}},h={{⌀₊}});
        translate([0,0,{{ℓᵣ}}-{{𝑑ₑ}}/2])
          cylinder(d={{⌀ₑ}}+{{⌀₊}},h={{𝑑ₑ}});
        translate([0,0,{{ℓᵦ}}])
          cylinder(d={{⌀ᵦ}}+{{⌀₊}},h={{⌀₊}});
      }
      translate([0,0,{{ℓᵦ}}])
        cylinder(d={{⌀ᵦ}}+{{⌀₊}},h={{ℓₐ}}-{{ℓᵦ}}+{{⌀₊}});
    }
  // hole
  translate([0-dplate/2,0,{{ℓ₀}}])
    rotate([atan({{𝑠ₑ}}/{{𝑑ₑ}}/2)*180/PI,-90,0])
      scale([({{𝑠ₑ}}-{{⌀₊}}/2)/{{𝑑ₑ}}, 1, 1])
        cylinder(h=2*{{ℎₑ}}+{{⌀₊}}, d1={{𝑑ₑ}}, d2={{𝑑ₑ}}+tan({{𝜙ₑ}})*2*{{ℎₑ}}); // d1=𝑑ₑ, d2=𝑑ₑ+tan(𝜙ₑ)*2ℎₑ
}
