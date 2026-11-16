# recoverability

a benchmark for RENN. Training data is generated from a known function (Prolog), a net is fitted to it (the first single-neuron net, by search, that fits every training example), then RENN recovers the net's function and we check whether it is the one the data came from. With all inputs as data a separable function is always recovered; with fewer, a different function can fit, and the benchmark measures how often that happens.

## Use

```prolog
?- use_module(prolog/recoverability).
?- fit([[0,0]-0, [1,1]-1], N), recovered([[0,0]-0, [1,1]-1], and, R).   % R = false: "a" also fits these two
?- rate(and, 4, R).                                                     % R = 1/1 with every input
```

## Proofs

`proofs/theorems.pl` proves 4 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. every target; every training set (every subset of the four inputs).

1. The fitted net is right on every training example.
2. With every input as data, every target is recovered (they are all separable).
3. With no data, recovery is luck: the first net is the same for every target, so at most one target is recovered.
4. Recovered means right on every input, not just the training ones.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.
