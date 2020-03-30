include "alldifferent.mzn";

%
% Description of P
%
int: m; int: n; % number of vertices and faces of P
enum VERTEX; enum FACE; % vertices and faces of P
array[FACE,0..2] of VERTEX: vrtx; % vertices involved in each face (clockwise)

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

%
% Input of P-SoKu
%
array[VERTEX] of int: cap; % capacity of each vertex
array[1..n, 0..2] of int: weight; % description of the tiles (clockwise)

%
% Solution
%
array[FACE] of var 1..n: tile; % mapping of each face to a tile
array[FACE] of var 0..2: rot; % rotation of the tile placed on each face

%
% Auxiliary functions
%
function var int: vertex_sum(VERTEX: v) =
  sum (f in FACE, r in 0..2 where vrtx[f, r] == v)
      (weight[tile[f], (3 + r - rot[f]) mod 3]);

%
% Constraints
%
% two tiles cannot be mapped to the same face
constraint alldifferent(tile);

% each vertex has its surrounding weights adding up to its capacity
constraint forall (v in VERTEX) (vertex_sum(v) == cap[v]);

% simmetry breaking: uniform tiles should not be rotated
constraint forall (t in 1..n)
  (if weight[t, 0] == weight[t, 1] /\ weight[t, 1] == weight[t, 2]
   then forall (f in FACE where tile[f] == t) (rot[f] == 0)
   endif);

% simmetry breaking: equivalent tiles should conserve their order when mapped
% to the faces of P
constraint forall (t1 in 1..n, t2 in 1..n where t1 < t2 /\
                   forall (i in 0..2) (weight[t1,i] == weight[t2,i]))
                  (forall (f1 in FACE, f2 in FACE
                           where tile[f1] == t1 /\ tile[f2] == t2)
                          (f1 < f2));

% random search strategy + constant restart
solve :: int_search(tile, first_fail, indomain_random)
      :: restart_constant(100)
      satisfy;
