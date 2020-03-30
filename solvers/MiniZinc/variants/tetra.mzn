m = 4;
n = 4;
VERTEX = {A, B, C, D};
FACE = {ABC, ACD, ADB, BDC};
vrtx = array2d(FACE, 0..2,
      [A, B, C,
       A, C, D,
       A, D, B,
       B, D, C]);