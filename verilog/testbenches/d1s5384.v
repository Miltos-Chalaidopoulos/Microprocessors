module d1s5384(a, b, c, d);
    input a, b, c;
    output d;

    wire e, f;

    and E1(e, a, b);
    not E2(f, c);
    and E3(d, e, f);
endmodule
