tile(1..n). % tiles
rotation(0..2). % possible (clockwise) rotations
1 { assign(T, F): face(F) } 1 :- tile(T).
1 { assign(T, F): tile(T) } 1 :- face(F).
1 { rotate(T, R) : rotation(R) } 1 :- tile(T).
:- #sum{ P,F : vrtx(V, F, A), assign(T, F), rotate(T, R), weight(T, (A - R + 3) \ 3, P) } != C, cap(V, C).
rotate(T, 0) :- weight(T, 0, I), weight(T, 1, I), weight(T, 2, I).
F1 < F2 :- assign(T1, F1), assign(T2, F2), weight(T1, 0, I1),
  weight(T2, 0 ,I1), weight(T1, 1, I2), weight(T2, 1, I2), weight(T1, 2, I3),
  weight(T2, 2, I3), T1 < T2.
put(W0, W1, W2, V0, V1, V2, C0, C1, C2) :- assign(T, F), vrtx(V0, F, 0), vrtx(V1, F, 1), vrtx(V2, F, 2), rotate(T, R), weight(T, (3 - R) \ 3, W0), weight(T, (4 - R) \ 3, W1), weight(T, (2 - R) \ 3, W2), cap(V0, C0), cap(V1, C1), cap(V2, C2).
#show cap/2.
#show put/9.
