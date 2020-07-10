%
% MiniZinc Solver for 3SoKu: given a polyhedron P with m vertices and n
%   triangular faces, a capacity assigned to each vertex and n triangular
%   tiles presenting integer weight at each corner, find an arrangement of the
%   tiles to the faces (with a rotation) such that the sum of the weights near
%   each vertex adds up to its capacity.
%
% ~ Nicola Rizzo

include "alldifferent.mzn";

%
% Description of P
%
int: m; int: n; % number of vertices and faces of P
enum VERTEX; enum FACE; % vertices and faces of P
array[FACE,0..2] of VERTEX: vrtx; % vertices involved in each face (clockwise)

%include "variants/tetra.mzn";
include "variants/ico.mzn";

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

%
% Solving strategies
%

solve satisfy;

% random search strategy + constant restart
%solve :: int_search(tile, first_fail, indomain_random)
%      :: restart_constant(100)
%      satisfy;

%
% Print functions
%
function string: instruction(FACE: f) =
  let { 0..3: w0 = weight[fix(tile[f]), (3 - fix(rot[f])) mod 3],
        0..3: w1 = weight[fix(tile[f]), (4 - fix(rot[f])) mod 3],
        0..3: w2 = weight[fix(tile[f]), (2 - fix(rot[f])) mod 3],
        VERTEX: v0 = vrtx[f, 0],
        VERTEX: v1 = vrtx[f, 1],
        VERTEX: v2 = vrtx[f, 2],
        1..12: c0 = cap[v0],
        1..12: c1 = cap[v1],
        1..12: c2 = cap[v2] }
  in "Put tile (" ++ show(w0) ++ ", " ++ show(w1) ++ ", " ++ show(w2) ++ ")" ++
     " on face corresponding to pegs " ++ show(c0) ++ ", " ++ show(c1) ++ ", " ++ show(c2) ++
     " (face " ++ show(v0) ++ show(v1) ++ show(v2) ++ ").\n";

%
% Output
%
% human-readable instructions to the solution
output [ instruction(f) | f in FACE ];
