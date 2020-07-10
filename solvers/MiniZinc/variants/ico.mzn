m = 12;
n = 20;
VERTEX = {A, B, C, D, E, F, G, H, I, J, K, L};
FACE = {ABC, ACD, ADE, AEF, AFB,
        BFK, BKG, BGC, CGH, CHD,
        DIE, DHI, EIJ, EJF, FJK,
        GKL, GLH, HLI, ILJ, JLK};
vrtx = array2d(FACE, 0..2,
  [A, B, C,  A, C, D,  A, D, E,  A, E, F,  A, F, B,
   B, F, K,  B, K, G,  B, G, C,  C, G, H,  C, H, D,
   D, I, E,  D, H, I,  E, I, J,  E, J, F,  F, J, K,
   G, K, L,  G, L, H,  H, L, I,  I, L, J,  J, L, K]);
