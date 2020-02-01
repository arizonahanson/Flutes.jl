
include <src/templates/flutes.scad>
// module parameters
L0={{ℓ₀}}; B0={{⌀₀}};
Lr={{ℓᵣ}}; Br={{⌀ᵣ}}; Hr={{ℎᵣ}};
Be={{⌀ₑ}}; He={{ℎₑ}}; De={{𝑑ₑ}}; Se={{𝑠ₑ}}; Ue={{𝜓ₑ}}; Oe={{𝜙ₑ}};
Lp={{ℓₚ}}; Rp={{𝜃ₚ}};
Ls={{ℓₛ}}; Bs={{⌀ₛ}}; Hs={{ℎₛ}};
Ln={{ℓₙ}};
La={{ℓₐ}};
module headjoint() {
  slide(L0) {
    difference() {
      // outer shell
      union() {
        // cylindrical outer tube
        shell(z=-L0, b=B0, l=L0+Ln);
        // tenon
        tenon(z=Ln, b=Bs, h=Hs/2, l=La-Ln);
        // lip-plate
        plate(b=Be, h=He, l=Lp, r=Rp);
      }
      // bore
      union() {
        // taper
        hull() {
          bore(z=-Lr, b=Br);         // reflector plate
          bore(z=-Se/2, b=Be, l=Se); // embouchure bore
          bore(z=Ls, b=Bs);          // stationary point
        }
        // cylindrical section
        bore(z=Ls, b=Bs, l=La-Ls);
      }
      // embouchure hole
      hole(b=Be, h=He, d=De, s=Se, u=Ue, o=Oe);
    }
  }
}

headjoint();
