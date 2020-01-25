
use <header.scad>

// lip-plate
module plate(z=0, d1, d2, l) {
  up(-l/2-(d2-d1)+z)
    hull() {
      turn(d=d1);
      up(d2-d1)
        intersection() {
          turn(d=d2,l=l);
          up(l/2)
            rotate([0,90,0])
              scale([d/l,1,1])
                turn(d=l,l=d2);
        }
      turn(z=l+2*(d2-d1)-$fl, d=d1);
}

module headjoint() {
  up({{ℓ₀}}) {
    difference() {
      // outer shell
      union() {
        // tube
        turn(z=-{{ℓ₀}}, d={{⌀₀}}, l={{ℓ₀}}+{{ℓₐ}}-{{ℓₙ}});
        // tenon
        turn(z={{ℓₐ}}-{{ℓₙ}}, d={{⌀ₛ}}+{{ℎₛ}}, l={{ℓₙ}});
        // lip-plate
        plate(d1={{⌀₀}}, d2={{⌀ₑ}}+2*{{ℎₑ}}, l={{𝑑ₚ}});
      }
      // bore
      union() {
        // taper
        hull() {
          // reflector plate
          bore(z=-{{ℓᵣ}}, d={{⌀ᵣ}});
          // embouchure bore
          bore(z=-{{𝑑ₑ}}/2, d={{⌀ₑ}}, l={{𝑑ₑ}});
          // stationary point
          bore(z={{ℓₛ}}, d={{⌀ₛ}});
        }
        // cylindrical section
        bore(z={{ℓₛ}}, d={{⌀ₛ}}, l={{ℓₐ}}-{{ℓₛ}});
      }
      // embouchure hole
      hole(b={{⌀ₑ}}, h={{ℎₑ}}, d={{𝑑ₑ}}, s={{𝑠ₑ}}, u={{𝜙ₑ}}, r={{𝜃ₑ}});
    }
  }
}

headjoint();
