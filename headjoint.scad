
include <src/templates/flutes.scad>
// module parameters
L0=32.0; B0=24.0;
Lr=17.0; Br=17.0; Hr=3.5;
Be=17.4; He=4.3; De=10.0; Se=12.0; Ue=7.0; Oe=0.0;
Lp=24.0; Rp=22.62;
Ls=120.0; Bs=19.0; Hs=2.5;
Ln=126.0;
La=156.0;
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
