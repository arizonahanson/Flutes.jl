
$fa=1.0;
$fs=0.1;
fd={{⌀ₓ}};
douter={{⌀ₔ}}+2*{{ℎₔ}};
dplate={{⌀ₑ}}+2*{{ℎₑ}};
dtenon={{⌀ₙ}}+2*{{ℎₙ}};
difference() {
  // outer shell
  union() {
      cylinder(d=douter,h={{ℓ₀}}+{{ℓₙ}});
      // lip-plate
      translate([0,0,{{ℓ₀}}-{{𝑑ₚ}}/2-(dplate-douter)])
        hull() {
          cylinder(d=douter,h=fd);
          translate([0,0,dplate-douter])
            intersection() {
              cylinder(d=dplate,h={{𝑑ₚ}});
              translate([0,0,{{𝑑ₚ}}/2])
                rotate([0,90,0])
                  scale([{{𝜙ₚ}}/{{𝑑ₚ}},1,1])
                    cylinder(d={{𝑑ₚ}},h=dplate);
            }
          translate([0,0,{{𝑑ₚ}}+(dplate-douter)-fd])
            cylinder(d=douter,h=fd);
        }
      // tenon
      translate([0,0,{{ℓ₀}}+{{ℓₙ}}])
        cylinder(d=dtenon,h={{ℓₐ}}-{{ℓₙ}});
    }
  }
  // bore
  translate([0,0,{{ℓ₀}}-{{ℓᵣ}}])
    union() {
      hull() {
        cylinder(d={{⌀ᵣ}}+fd,h=fd);
        translate([0,0,{{ℓᵣ}}-{{𝑑ₑ}}/2])
          cylinder(d={{⌀ₑ}}+fd,h={{𝑑ₑ}});
        translate([0,0,{{ℓₔ}}])
          cylinder(d={{⌀ₔ}}+fd,h=fd);
      }
      translate([0,0,{{ℓₔ}}])
        cylinder(d={{⌀ₔ}}+fd,h={{ℓₐ}}-{{ℓₔ}}+fd);
    }
  // hole
  translate([0-dplate/2,0,{{ℓ₀}}])
    rotate([atan({{𝜙ₑ}}/{{𝑑ₑ}}/2)*180/PI,-90,0])
      scale([({{𝜙ₑ}}-ld/2)/{{𝑑ₑ}}, 1, 1])
        cylinder(h=dplate/2+ld, d1={{𝑑ₑ}}, d2={{𝑑ₑ}}+tan({{𝜃ₑ}})*dplate);
}
