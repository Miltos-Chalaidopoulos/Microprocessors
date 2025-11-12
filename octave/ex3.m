function ex3()
    ElementTypes = {'AND', 'NOT', 'OR', 'XOR', 'NAND', 'NOR', 'XNOR'};

    % signals index: A=1, B=2, C=3, E=4, F=5, D=6
    ElementsTable = {
        struct('type_index', find(strcmp(ElementTypes,'AND')), 'inputs', [1,2], 'output', 4),
        struct('type_index', find(strcmp(ElementTypes,'NOT')), 'inputs', [3],   'output', 5),
        struct('type_index', find(strcmp(ElementTypes,'AND')), 'inputs', [4,5], 'output', 6)
    };

    run_testbench(ElementsTable, ElementTypes);
endfunction

function run_testbench(ElementsTable, ElementTypes)
    truth = [
        0 0 0;
        0 0 1;
        0 1 0;
        0 1 1;
        1 0 0;
        1 0 1;
        1 1 0;
        1 1 1
    ];

    fprintf("Truth Table Output:\n");
    fprintf(" a b c | e f d\n");
    fprintf("------------------\n");

    for i = 1:rows(truth)
        SignalsTable = zeros(1,6);
        SignalsTable(1:3) = truth(i,:);

        SignalsTable = evaluate_circuit(ElementsTable, ElementTypes, SignalsTable);

        fprintf(" %d %d %d | %d %d %d\n", ...
            truth(i,1), truth(i,2), truth(i,3), ...
            round(SignalsTable(4)), round(SignalsTable(5)), round(SignalsTable(6)));
    endfor
    test_cases = [
        0.5000  0.5000  0.5000;  % unknown workload
        0.5228  0.5228  0.5228;
        0.5384  0.5384  0.5384
    ];

    fprintf("\nSwitching Activity Model for probabilities:\n");
    fprintf(" a       b       c      |  e_sa    f_sa    d_sa   avg_sa\n");
    fprintf("--------------------------------------------------------\n");

    for i = 1:rows(test_cases)
        st = zeros(1,6);          % SignalsTable: [a b c e f d]
        st(1:3) = test_cases(i,:);

        st = evaluate_circuit(ElementsTable, ElementTypes, st);

        sa_e = switching_activity(st(4));
        sa_f = switching_activity(st(5));
        sa_d = switching_activity(st(6));


        sa_avg = (sa_e + sa_f + sa_d) / 3;


        fprintf(" %.4f  %.4f  %.4f | %.4f  %.4f  %.4f  %.4f\n", ...
            st(1), st(2), st(3), sa_e, sa_f, sa_d, sa_avg);
    endfor
endfunction

function SignalsTable = evaluate_circuit(ElementsTable, ElementTypes, SignalsTable)
    for i = 1:length(ElementsTable)
        el = ElementsTable{i};
        type = ElementTypes{el.type_index};
        inp = SignalsTable(el.inputs);
        switch type
            case 'AND'
                SignalsTable(el.output) = spAND_N(inp);
            case 'OR'
                SignalsTable(el.output) = spOR_N(inp);
            case 'NOT'
                SignalsTable(el.output) = spNOT(inp(1));
            case 'XOR'
                SignalsTable(el.output) = spXOR_N(inp);
            case 'NAND'
                SignalsTable(el.output) = spNAND_N(inp);
            case 'NOR'
                SignalsTable(el.output) = spNOR_N(inp);
            case 'XNOR'
                SignalsTable(el.output) = 1 - spXOR_N(inp);
            otherwise
                error("Unknown gate type");
        endswitch
    endfor
endfunction
