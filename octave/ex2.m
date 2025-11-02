function ex2(a, b, c)
  fprintf("Probabilities Input:\n");
  fprintf("a = %.3f\t b = %.3f\t c = %.3f\n\n", a, b, c);
  e = sp2AND(a, b);
  f = spNOT(c);
  d = sp2AND(e, f);
  fprintf("Signal probabilities:\t e = %.6f\t f = %.6f\t d = %.6f\n", e, f, d);
  fprintf("Switching activities:\t e = %.6f\t f = %.6f\t d = %.6f\n\n", ...
          switching_activity(e), switching_activity(f), switching_activity(d));

  simulations_array = [10, 100, 5228, 5384];
  for n = simulations_array
    monte_carlo(a, b, c, n);
  endfor
endfunction

function [e, f, d] = circuit_logic(a, b, c)
  e = a * b;
  f = 1 - c;
  d = e * f;
endfunction

% generates 1 with probability p or 0 with probability 1-p
function val = random_signal(p)
    val = rand() < p;
endfunction

function monte_carlo(pa, pb, pc, n)
  prev_a = random_signal(pa);
  prev_b = random_signal(pb);
  prev_c = random_signal(pc);
  [prev_e, prev_f, prev_d] = circuit_logic(prev_a, prev_b, prev_c);

  count_e_ones = prev_e;
  count_f_ones = prev_f;
  count_d_ones = prev_d;

  e_switches = 0;
  f_switches = 0;
  d_switches = 0;

  for i = 2:n
    curr_a = random_signal(pa);
    curr_b = random_signal(pb);
    curr_c = random_signal(pc);
    [curr_e, curr_f, curr_d] = circuit_logic(curr_a, curr_b, curr_c);

    count_e_ones += curr_e;
    count_f_ones += curr_f;
    count_d_ones += curr_d;

    e_switches += (curr_e ~= prev_e);
    f_switches += (curr_f ~= prev_f);
    d_switches += (curr_d ~= prev_d);

    prev_a = curr_a;
    prev_b = curr_b;
    prev_c = curr_c;
    prev_e = curr_e;
    prev_f = curr_f;
    prev_d = curr_d;
  endfor

  sp_e = count_e_ones / n;
  sp_f = count_f_ones / n;
  sp_d = count_d_ones / n;

  sa_e = e_switches / (n - 1);
  sa_f = f_switches / (n - 1);
  sa_d = d_switches / (n - 1);

  fprintf("Monte Carlo for N = %d\n", n);
  fprintf("Signal probabilities:\t e = %.6f\t f = %.6f\t d = %.6f\n", sp_e, sp_f, sp_d);
  fprintf("Switching activities:\t e = %.6f\t f = %.6f\t d = %.6f\n\n", sa_e, sa_f, sa_d);
endfunction

