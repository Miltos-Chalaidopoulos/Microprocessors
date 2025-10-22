# Microprocessors exercises

This repository contains several C used to calculate or aproximate (using Monte Carlo),signal probabilities and switching activities in digital logic circuits.

## Contents

1. **Monte Carlo π Approximation**
2. **Monte Carlo Simulation for Switching Activity of a 4-input OR Gate**
3. **Signal Probability and Switching Activity Calculator**
4. **Monte Carlo and Truth Table Analysis for a Simple Logic Circuit**

---

## 1. Monte Carlo π Approximation

This program approximates the value of π using the Monte Carlo method, a squere and its inscribed circle.

- Random points are generated inside a square
- The number of points that fall inside the inscribed circle is counted.
- The ratio of points inside the circle to total points is used to estimate π:

\[
\pi \approx 4 \times \frac{\text{points inside circle}}{\text{total points}}
\]
## Execution:
``` bash
gcc MCpi.c
./a.out
```

## 2. Monte Carlo Simulation for Switching Activity of a 4-input OR Gate

This program calculates the switching activity of a 4-input OR gate using a Monte Carlo simulation.

### Concept:

- Random input vectors are generated with given input probability 
- The output signal is computed.
- Switching activity is measured as the fraction of output changes between consecutive iterations.

## Execution
``` bash
gcc MCOR4.c 
./a.out # for default probabilities 
./a.out p1 p2 p3 p4 # for certain input probabilities
```

## 3. Signal Probability and Switching Activity Calculator

This program calculates the **signal probabilities** and **switching activities** for N inputs logic gates given their input probabilities.

**Execution:**

```bash
gcc signalprobs.c
./a.out N p1 p2 ... pN
# where
# N number of gate inputs
# pi,p2,pN probabilities of each input being 1 
```

## 4. Monte Carlo and Truth Table Analysis for a Simple Logic Circuit

This program evaluates a small logic circuit with three inputs (`A, B, C`) and three outputs (`E, F, D`):  
*E = A AND B*    
*F = NOT C*  
*D = E AND F*  


### Features:

1. **Truth table generation:** prints all 8 combinations of inputs and corresponding outputs.
2. **Signal probability calculation:** computes the probability of each output being `1` given probabilistic inputs.
3. **Switching activity calculation:** computes the expected switching activity for each output.
4. **Monte Carlo simulation:** estimates signal probabilities and switching activities by generating random input sequences.

### Usage:

```bash
gcc ex2.c

# Print truth table
./a.out

# Compute probabilities and switching activities
./a.out 0.2 0.3 0.4
