% Theorems, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).
:- use_module('../prolog/recoverability').

% Domain: every target; every training set (every subset of the four inputs).
tgt(T) :- member(T, [and, or, a, nand, implies]).
data(T, D) :- findall(I, bits(2, I), All), recoverability:subset_of(All, Sub), maplist([I, I-Y]>>target(T, I, Y), Sub, D).

% 1. The fitted net is right on every training example.
theorem(fit_fits_the_data) :- forall(( tgt(T), data(T, D), fit(D, N), N \== none ), forall(member(I-Y, D), forward(N, I, [Y]))).

% 2. With every input as data, every target is recovered (they are all separable).
theorem(full_data_recovers) :- forall(tgt(T), ( rate(T, 4, 1/1) )).

% 3. With no data, recovery is luck: the first net is the same for every target, so at most one target is recovered.
theorem(no_data_no_information) :- findall(T, ( tgt(T), recovered([], T, true) ), Ts), length(Ts, N), N =< 1.

% 4. Recovered means right on every input, not just the training ones.
theorem(recovered_means_everywhere) :- forall(( tgt(T), data(T, D), recovered(D, T, true), fit(D, N) ), forall(bits(2, I), ( target(T, I, Y), forward(N, I, [Y]) ))).
