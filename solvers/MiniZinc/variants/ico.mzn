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
% LaTeX print functions (pgfplotstable)
%
function string: latex_print_instance(array[VERTEX] of int: cap) =
  concat( [ " & "++show(v) | v in VERTEX ] ) ++
  " \\\\\n" ++
  concat( [ " & "++show(cap[v]) | v in VERTEX ] ) ++
  " \\\\\n";

function string: latex_print_partial_solution(FACE: f) =
  "\\pgfplotstabletypeset[]{\n" ++
  show(vrtx[f, 0]) ++ " " ++
  show(vrtx[f, 1]) ++ " " ++
  show(vrtx[f, 2]) ++ "\n" ++
  show(weight[fix(tile[f]), (3 - fix(rot[f])) mod 3]) ++ " " ++
  show(weight[fix(tile[f]), (4 - fix(rot[f])) mod 3]) ++ " " ++
  show(weight[fix(tile[f]), (2 - fix(rot[f])) mod 3]) ++ "\n" ++
  "}";

function string: latex_print_solution() =
  concat( [ latex_print_partial_solution(f) ++ "\\qquad\n" | f in FACE ] );
