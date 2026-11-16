:- module(cases, [title/1, case/3]).
:- use_module('../prolog/recoverability').
:- use_module(engine).
title('recoverability').
tgt_g(T) :- rnd_pick([and, or, a, nand, implies], T).
data_g(T, D) :- findall(I, bits(2, I), All), rnd_subset(All, Sub), maplist([I, I-Y]>>target(T, I, Y), Sub, D).
case(rate, [T, S], rate) :- tgt_g(T), rnd_int(0, 4, S).
case(recovered, [D, T], recovered) :- tgt_g(T), data_g(T, D).
case(fit, [D], fit) :- tgt_g(T), data_g(T, D).
