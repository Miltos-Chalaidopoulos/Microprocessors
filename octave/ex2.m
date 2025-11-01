function ex2(a, b, c)
  if nargin ~= 3
    fprintf("Usage: ex2(0.2,0.3,0.4)\n");
    return;
  end

% Theoretical calculations
  circuit_logic = @(a,b,c) deal(a.*b, 1.0 - c, (a.*b) .* (1.0 - c));
  sa_from_sp = @(s) 2 .* s .* (1.0 - s);
  [e,f,d] = circuit_logic(a,b,c);

  e_sa = sa_from_sp(e);
  f_sa = sa_from_sp(f);
  d_sa = sa_from_sp(d);

  fprintf("Probabilities Input:\n");
  fprintf("a = %.3f\t b = %.3f\t c = %.3f\n\n", a, b, c);
  fprintf("Signal probabilities:\t e = %.6f\t f = %.6f\t d = %.6f\n", e, f, d);
  fprintf("Switching activities:\t e = %.6f\t f = %.6f\t d = %.6f\n\n", e_sa, f_sa, d_sa);

% Monte Carlo
  Ns = [10, 100, 5228, 5384];
  for n = Ns
    monte_carlo(a, b, c, n, circuit_logic);
  endfor
endfunction


function monte_carlo(pa, pb, pc, n, circuit_logic)
  getRandomNumber = @(p) rand() < p;

  prev_a = getRandomNumber(pa);
  prev_b = getRandomNumber(pb);
  prev_c = getRandomNumber(pc);
  [prev_e, prev_f, prev_d] = circuit_logic(prev_a, prev_b, prev_c);

  count_e_ones = prev_e;
  count_f_ones = prev_f;
  count_d_ones = prev_d;

  e_switches = 0;
  f_switches = 0;
  d_switches = 0;

  for i = 2:n
    curr_a = getRandomNumber(pa);
    curr_b = getRandomNumber(pb);
    curr_c = getRandomNumber(pc);
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

% print results
  fprintf("Monte Carlo for N = %d\n", n);
  fprintf("Signal probabilities:\t e = %.6f\t f = %.6f\t d = %.6f\n", sp_e, sp_f, sp_d);
  fprintf("Switching activities:\t e = %.6f\t f = %.6f\t d = %.6f\n\n", sa_e, sa_f, sa_d);
endfunction

