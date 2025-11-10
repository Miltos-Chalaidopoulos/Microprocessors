function testbench_loaded()
    filename = 'circuit_small.txt';
    [ElementsTable, SignalsTable, ElementTypes, top_inputs, signal_names] = ex3_2(filename);

    n_inputs = length(top_inputs);

    fprintf("Truth Table Output:\n");
    fprintf(" %s |", strjoin(top_inputs,' '));
    for i = 1:length(ElementsTable)
        fprintf(" %s", ElementsTable{i}.out);
    end
    fprintf("\n");
    fprintf('%s\n', repmat('-',1,4*n_inputs + 1 + 4*length(ElementsTable)));

    % Truth table
    truth = dec2bin(0:(2^n_inputs-1), n_inputs) - '0';

    for i = 1:rows(truth)
        SignalsTable(:) = 0;
        for j = 1:n_inputs
            idx = find(strcmp(signal_names, top_inputs{j}));
            SignalsTable(idx) = truth(i,j);
        end
        SignalsTable = evaluate_circuit_loaded(ElementsTable, SignalsTable, ElementTypes);

        fprintf(" %d", truth(i,1));
        for j = 2:n_inputs
            fprintf(" %d", truth(i,j));
        end
        fprintf(" |");
        for j = 1:length(ElementsTable)
            fprintf(" %d", round(SignalsTable(ElementsTable{j}.output)));
        end
        fprintf("\n");
    endfor

    test_cases_sa = [0.5000 0.5000 0.5000;
                     0.5228 0.5228 0.5228;
                     0.5384 0.5384 0.5384];

    fprintf("\nSwitching Activity Model for probabilities:\n");
    fprintf(" %s |", strjoin(top_inputs,' '));
    for i = 1:length(ElementsTable)
        fprintf(" %s_sa", ElementsTable{i}.out);
    end
    fprintf('\n');
    fprintf('%s\n', repmat('-',1,4*n_inputs + 3 + 8*length(ElementsTable)));

    for t = 1:size(test_cases_sa,1)
        st = zeros(1,length(signal_names));
        for i = 1:n_inputs
            idx = find(strcmp(signal_names, top_inputs{i}));
            st(idx) = test_cases_sa(t,i);
        end
        st = evaluate_circuit_loaded(ElementsTable, st, ElementTypes);

        line = '';
        for i = 1:n_inputs
            idx = find(strcmp(signal_names, top_inputs{i}));
            line = [line sprintf(' %.4f', st(idx))];
        end
        line = [line ' |'];
        for i = 1:length(ElementsTable)
            sa = switching_activity(st(ElementsTable{i}.output));
            line = [line sprintf(' %.4f', sa)];
        end
        fprintf('%s\n', line);
    end
end

function SignalsTable = evaluate_circuit_loaded(ElementsTable, SignalsTable, ElementTypes)
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
    end
end

