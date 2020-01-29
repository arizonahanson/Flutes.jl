
use <header.scad>

// module parameters
L0={{ℓ₀}};
B0={{⌀₀}};
Lr={{ℓᵣ}};
Br={{⌀ᵣ}};

module headjoint() {
  slide(L0) {
    difference() {
      // outer shell
      union() {
        // tube
        shell(z=-L0, b=B0, l=L0+La-Ln);
        // tenon
        shell(z=La-Ln, b=Bs+Hs, l=Ln);
        // lip-plate
        plate(d1=B0, d2=Be+2*He, l=Dp);
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
      hole(b=Be, h=He, d=De, s=Se, r=Re, u=Ue, o=Oe);
    }
  }
}

headjoint();
