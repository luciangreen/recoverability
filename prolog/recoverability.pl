% recoverability: a benchmark for RENN. Training data is generated from a known function
% (Prolog), a net is fitted to it (the first single-neuron net, by search, that fits every
% training example), then RENN recovers the net's function and we check whether it is the one
% the data came from. With all inputs as data a separable function is always recovered; with
% fewer, a different function can fit, and the benchmark measures how often that happens.
%?- fit([[0,0]-0, [1,1]-1], N), recovered([[0,0]-0, [1,1]-1], and, R).   % R = false: "a" also fits these two
%?- rate(and, 4, R).                                                     % R = 1/1 with every input
:- module(recoverability, [neuron/3, forward/3, bits/2, truth/3, target/3, fit/2, recovered/3, rate/3]).
:- use_module(library(lists)).
:- use_module(library(apply)).

neuron(n(Ws, B), Xs, Y) :- foldl([W, X, A0, A]>>(A is A0 + W * X), Ws, Xs, B, S), ( S > 0 -> Y = 1 ; Y = 0 ).
forward([], Xs, Xs).
forward([L|Ls], Xs, Out) :- maplist([N, Y]>>neuron(N, Xs, Y), L, Ys), forward(Ls, Ys, Out).
bits(K, Bs) :- length(Bs, K), maplist([X]>>member(X, [0, 1]), Bs).
truth(Net, K, T) :- findall(O, ( bits(K, I), forward(Net, I, O) ), T).

% target(Name, Input, Output): the functions data is made from.
target(and, [A, B], Y) :- Y is A * B.
target(or, [A, B], Y) :- Y is max(A, B).
target(a, [A, _], A).
target(nand, [A, B], Y) :- Y is 1 - A * B.
target(implies, [A, B], Y) :- Y is max(1 - A, B).

% fit(+Data, -Net): the first single neuron (weights -2..2, bias -3..3) right on every example; none if no neuron fits.
fit(D, Net) :- ( length(Ws, 2), maplist([W]>>between(-2, 2, W), Ws), between(-3, 3, B), forall(member(I-Y, D), neuron(n(Ws, B), I, Y)) -> Net = [[n(Ws, B)]] ; Net = none ).

% recovered(+Data, +Target, -Bool): does the fitted net compute the target on every input?
recovered(D, T, R) :- fit(D, Net), ( Net \== none, forall(bits(2, I), ( target(T, I, Y), forward(Net, I, [Y]) )) -> R = true ; R = false ).

% rate(+Target, +Size, -Fraction): over every training set of Size distinct inputs, the fraction recovered.
rate(T, S, N/D) :- findall(I, bits(2, I), All), findall(R, ( subset_of(All, Sub), length(Sub, S), maplist([I, I-Y]>>target(T, I, Y), Sub, Data), recovered(Data, T, R) ), Rs),
    length(Rs, D0), include(==(true), Rs, Ts), length(Ts, N0), G is max(1, gcd(N0, D0)), N is N0 // G, D is max(1, D0 // G).
subset_of([], []).
subset_of([X|Xs], [X|Ys]) :- subset_of(Xs, Ys).
subset_of([_|Xs], Ys) :- subset_of(Xs, Ys).
