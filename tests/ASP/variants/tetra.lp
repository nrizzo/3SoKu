#const m = 4.
#const n = 4.
vertex(a; b; c; d).
face(abc; abd; acd; bcd).
angle(a, abc, 0). angle(b, abc, 1). angle(c, abc, 2). % ABC
angle(a, abd, 0). angle(b, abd, 1). angle(d, abd, 2). % ABD
angle(a, acd, 0). angle(c, acd, 1). angle(d, acd, 2). % ACD
angle(b, bcd, 0). angle(c, bcd, 1). angle(d, bcd, 2). % BCD
