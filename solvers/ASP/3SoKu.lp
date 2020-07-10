%
% ASP Solver for 3SoKu: given a polyhedron P with m vertices and n
%   triangular faces, a capacity assigned to each vertex and n triangular
%   tiles presenting integer weight at each corner, find an arrangement of the
%   tiles to the faces (with a rotation) such that the sum of the weights near
%   each vertex adds up to its capacity.
%
% ~ Nicola Rizzo

%
% The polyhedron P that decides the variant of deltahedron-soku played must be
% appended to this file is described by:
%  - the constants m and n, the number of vertices and faces of P;
%  - the functions vertex/1 and face/1 for the vertices and faces of P;
%  - the function vrtx/3 such that vrtx(v, f, 0) means that v is the first
%    vertex involved in face f, vrtx(v, f, 1) means that v is the second
%    vertex of f, vrtx(v, f, 2) the third one.
%

tile(1..n). % tiles
rotation(0..2). % possible (clockwise) rotations

%
% The instance of P-soku to solve must be appended to this file and is decided
% by:
%  - function cap/2, that maps each vertex to an integer such that cap(V, I)
%    indicates that the capacity of V is I;
%  - function weight/3 maps each vrtx of a tile to an integer representing its
%    weight (weight(T, 0, P), weight(T, 1, P), weight(T, 2, P) mean that
%    respectively the first, second and third vrtx of T has weight P).
%

%
% Solution
%
% the solution is a bijection between tiles and faces and each tile can be
% rotated
1 { assign(T, F): face(F) } 1 :- tile(T).
1 { assign(T, F): tile(T) } 1 :- face(F).

1 { rotate(T, R) : rotation(R) } 1 :- tile(T).

% the capacity of each vertex must be filled
:- #sum{ P,F : vrtx(V, F, A), assign(T, F), rotate(T, R), weight(T, (A - R + 3) \ 3, P) } != C, cap(V, C).

% simmetry breaking: uniform tiles should not be rotated
rotate(T, 0) :- weight(T, 0, I), weight(T, 1, I), weight(T, 2, I).

% simmetry breaking: equivalent tiles should keep their relative order when
% assigned to the faces
F1 < F2 :- assign(T1, F1), assign(T2, F2), weight(T1, 0, I1),
  weight(T2, 0 ,I1), weight(T1, 1, I2), weight(T2, 1, I2), weight(T1, 2, I3),
  weight(T2, 2, I3), T1 < T2.

% put/6 is a print predicate, put(W0, W1, W2, V0, V1, V2, C0, C1, C2) means that
% the solution found puts tile (W0, W1, W2) on face (V0, V1, V2) whose vertices
% correspond to capacities C0, C1 and C2.
% WARNING: put/6 affects grounding size, remove if necessary
put(W0, W1, W2, V0, V1, V2, C0, C1, C2) :- assign(T, F), vrtx(V0, F, 0), vrtx(V1, F, 1), vrtx(V2, F, 2), rotate(T, R), weight(T, (3 - R) \ 3, W0), weight(T, (4 - R) \ 3, W1), weight(T, (2 - R) \ 3, W2), cap(V0, C0), cap(V1, C1), cap(V2, C2).

% Output solution
%#show assign/2.
%#show rotate/2.

% Output instructions
#show cap/2.
#show put/9.
