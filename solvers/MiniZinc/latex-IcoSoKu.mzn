% Copy of 3SoKu.mzn with the LaTeX output enabled (randomized search)
include "alldifferent.mzn";

int: m; int: n; % number of vertices and faces of P
enum VERTEX; enum FACE; % vertices and faces of P
array[FACE,0..2] of VERTEX: vrtx; % vertices involved in each face (clockwise)
include "variants/ico.mzn";
array[VERTEX] of int: cap; % capacity of each vertex
array[1..n, 0..2] of int: weight; % description of the tiles (clockwise)
array[FACE] of var 1..n: tile; % mapping of each face to a tile
array[FACE] of var 0..2: rot; % rotation of the tile placed on each face
function var int: vertex_sum(VERTEX: v) =
  sum (f in FACE, r in 0..2 where vrtx[f, r] == v)
      (weight[tile[f], (3 + r - rot[f]) mod 3]);

constraint alldifferent(tile);
constraint forall (v in VERTEX) (vertex_sum(v) == cap[v]);
constraint forall (t in 1..n)
  (if weight[t, 0] == weight[t, 1] /\ weight[t, 1] == weight[t, 2]
   then forall (f in FACE where tile[f] == t) (rot[f] == 0)
   endif);
constraint forall (t1 in 1..n, t2 in 1..n where t1 < t2 /\
                   forall (i in 0..2) (weight[t1,i] == weight[t2,i]))
                  (forall (f1 in FACE, f2 in FACE
                           where tile[f1] == t1 /\ tile[f2] == t2)
                          (f1 < f2));

solve :: int_search(tile, first_fail, indomain_random)
      :: restart_constant(100)
      satisfy;

output [ latex_print_instance(cap), latex_print_solution() ];
