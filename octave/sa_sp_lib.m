printf("Library for switching_activity an signal probabilities of known gates\n");
function sp=spNOT(a)
  printf("NOT Gate for input probability (%f):\n", a);
  sp = 1 - a;
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

% 2 gates
function sp=sp2AND(a,b)
  printf("AND Gate for input probabilities (%f %f):\n",a,b)
  sp = a*b;
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sp=sp2OR(a,b)
  printf("OR Gate for input probabilities (%f %f):\n",a,b)
  sp = 1 - (1 - a)*(1 - b);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sp=sp2XOR(a,b)
  printf("XOR Gate for input probabilities (%f %f):\n",a,b)
  sp = a*(1-b) + (1-a)*b;
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sp=sp2NAND(a,b)
  printf("NAND Gate for input probabilities (%f %f):\n",a,b)
  sp = 1 - a*b;
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sp=sp2NOR(a,b)
  printf("NOR Gate for input probabilities (%f %f):\n",a,b)
  sp = (1 - a)*(1 - b);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

%%% 3 gates
function sp=sp3AND(a,b,c)
  printf("AND Gate for input probabilities (%f %f %f):\n",a,b,c)
  sp = a*b*c;
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sp=sp3OR(a,b,c)
  printf("OR Gate for input probabilities (%f %f %f):\n",a,b,c)
  s = 1 - (1 - a)*(1 - b)*(1 - c);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sp=sp3XOR(a,b,c)
  printf("XOR Gate for input probabilities (%f %f %f):\n",a,b,c)
  sp = a*(1-b)*(1-c) + (1-a)*b*(1-c) + (1-a)*(1-b)*c + a*b*c;
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sp=sp3NAND(a,b,c)
  printf("NAND Gate for input probabilities (%f %f %f):\n",a,b,c)
  sp = 1 - a*b*c;
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sp=sp3NOR(a,b,c)
  printf("NOR Gate for input probabilities (%f %f %f):\n",a,b,c)
  sp = (1 - a)*(1 - b)*(1 - c);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

% N gates
function sp=spAND_N(p)
  printf("AND Gate for %d-input probabilities:\n", numel(p))
  sp = prod(p);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sp=spOR_N(p)
  printf("OR Gate for %d-input probabilities:\n", numel(p))
  sp = 1 - prod(1 - p);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sp=spXOR_N(p)
  printf("XOR Gate for %d-input probabilities:\n", numel(p))
  sp = 0.5 * (1 - prod(1 - 2*p));
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sp=spNAND_N(p)
  printf("NAND Gate for %d-input probabilities:\n", numel(p))
  sp = 1 - prod(p);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sp=spNOR_N(p)
  printf("NOR Gate for %d-input probabilities:\n", numel(p))
  sp = prod(1 - p);
  printf("Signal Probability = %.6f\n", sp);
  printf("Switching Activity = %.6f\n\n", switching_activity(sp));
endfunction

function sa = switching_activity(sp)
    sa = 2 * sp * (1 - sp);
endfunction
