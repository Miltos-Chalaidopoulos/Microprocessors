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
