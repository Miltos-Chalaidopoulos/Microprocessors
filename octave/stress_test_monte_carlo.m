function stress_test_monte_carlo()
    filename = 'circuit.txt';
    L = 2;
    N = 2000;

    [ElementsTableSorted, SignalsTable, ElementTypes, top_inputs, signal_names] = ex3_2(filename);

    internal_signals = setdiff(signal_names, top_inputs);
    score = zeros(1, N);
    workloads_start = zeros(N, length(top_inputs));
    workloads_end = zeros(N, length(top_inputs));

    for i = 1:N
        test_vectors = randi([0 1], L, length(top_inputs));
        signal_values = zeros(L, length(internal_signals));

        for t = 1:L
            SignalsTable_tmp = SignalsTable;
            for j = 1:length(top_inputs)
                idx = find(strcmp(signal_names, top_inputs{j}));
                SignalsTable_tmp(idx) = test_vectors(t, j);
            end
            SignalsTable_tmp = evaluate_circuit_loaded(ElementsTableSorted, SignalsTable_tmp, ElementTypes);
            for k = 1:length(internal_signals)
                idx = find(strcmp(signal_names, internal_signals{k}));
                signal_values(t, k) = round(SignalsTable_tmp(idx));
            end
        end
        diffs = abs(signal_values(2,:) - signal_values(1,:));
        score(i) = sum(diffs);
        workloads_start(i, :) = test_vectors(1, :);
        workloads_end(i, :) = test_vectors(2, :);
    end

    [max_score, idx_max] = max(score);
    fprintf("Average number of signal switches: %.2f\n", mean(score));
    fprintf("Maximum number of signal switches: %d\n\n", max_score);

    fprintf("Workload that caused maximum switching activity:\n");
    fprintf("------------------------------------------------\n");
    for i = 1:length(top_inputs)
        fprintf("%-5s %d -> %d\n", top_inputs{i}, ...
            workloads_start(idx_max, i), workloads_end(idx_max, i));
    end
    figure;
    plot(1:N, score, 'b-', 'LineWidth', 1.5);
    xlabel('Individual');
    ylabel('Score (Number of Switches)');
    title('Stress Test: Random Workload Evaluation');
    grid on;
end

function SignalsTable = evaluate_circuit_loaded(ElementsTable, SignalsTable, ElementTypes)
    for i = 1:length(ElementsTable)
        el = ElementsTable{i};
        type = ElementTypes{el.type_index};
        inp = SignalsTable(el.inputs);
        switch type
            case 'AND'
                SignalsTable(el.output) = prod(inp);
            case 'OR'
                SignalsTable(el.output) = 1 - prod(1 - inp);
            case 'NOT'
                SignalsTable(el.output) = 1 - inp(1);
            case 'XOR'
                SignalsTable(el.output) = mod(sum(round(inp)), 2);
            case 'NAND'
                SignalsTable(el.output) = 1 - prod(inp);
            case 'NOR'
                SignalsTable(el.output) = prod(1 - inp);
            case 'XNOR'
                SignalsTable(el.output) = 1 - mod(sum(round(inp)), 2);
            otherwise
                error("Unknown gate type");
        endswitch
    end
end

