%%% >> signalprobs([p1 p2 p3 ...])

function signalprobs(varargin)
  args = cell2mat(varargin);
  N = numel(args);

  if N == 2
    a = args(1); b = args(2);
    sp2AND(a,b)
    sp2OR(a,b)
    sp2XOR(a,b)
    sp2NAND(a,b)
    sp2NOR(a,b)

  elseif N == 3
    a=args(1); b=args(2); c=args(3);
    sp3AND(a,b,c)
    sp3OR(a,b,c)
    sp3XOR(a,b,c)
    sp3NAND(a,b,c)
    sp3NOR(a,b,c)

  else
    printf("Gate %d input:\n", N);
    spAND_N(args)
    spOR_N(args)
    spXOR_N(args)
    spNAND_N(args)
    spNOR_N(args)
  endif
endfunction

% 2 gates
function s=sp2AND(a,b)
  printf("AND Gate for input probabilities (%f %f):\n",a,b)
  sp = a*b;
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function s=sp2OR(a,b)
  printf("OR Gate for input probabilities (%f %f):\n",a,b)
  sp = 1 - (1 - a)*(1 - b);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function s=sp2XOR(a,b)
  printf("XOR Gate for input probabilities (%f %f):\n",a,b)
  sp = a*(1-b) + (1-a)*b;
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function s=sp2NAND(a,b)
  printf("NAND Gate for input probabilities (%f %f):\n",a,b)
  sp = 1 - a*b;
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function s=sp2NOR(a,b)
  printf("NOR Gate for input probabilities (%f %f):\n",a,b)
  sp = (1 - a)*(1 - b);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

%%% 3 gates
function s=sp3AND(a,b,c)
  printf("AND Gate for input probabilities (%f %f %f):\n",a,b,c)
  sp = a*b*c;
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function s=sp3OR(a,b,c)
  printf("OR Gate for input probabilities (%f %f %f):\n",a,b,c)
  s = 1 - (1 - a)*(1 - b)*(1 - c);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function s=sp3XOR(a,b,c)
  printf("XOR Gate for input probabilities (%f %f %f):\n",a,b,c)
  sp = a*(1-b)*(1-c) + (1-a)*b*(1-c) + (1-a)*(1-b)*c + a*b*c;
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function s=sp3NAND(a,b,c)
  printf("NAND Gate for input probabilities (%f %f %f):\n",a,b,c)
  sp = 1 - a*b*c;
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function s=sp3NOR(a,b,c)
  printf("NOR Gate for input probabilities (%f %f %f):\n",a,b,c)
  sp = (1 - a)*(1 - b)*(1 - c);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

% N gates
function s=spAND_N(p)
  printf("AND Gate for %d-input probabilities:\n", numel(p))
  sp = prod(p);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function s=spOR_N(p)
  printf("OR Gate for %d-input probabilities:\n", numel(p))
  sp = 1 - prod(1 - p);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function s=spXOR_N(p)
  printf("XOR Gate for %d-input probabilities:\n", numel(p))
  sp = 0.5 * (1 - prod(1 - 2*p));
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function s=spNAND_N(p)
  printf("NAND Gate for %d-input probabilities:\n", numel(p))
  sp = 1 - prod(p);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function s=spNOR_N(p)
  printf("NOR Gate for %d-input probabilities:\n", numel(p))
  sp = prod(1 - p);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sa = switching_activity(sp)
    sa = 2 * sp * (1 - sp);
endfunction
