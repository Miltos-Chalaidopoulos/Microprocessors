function stress_test_ga_runs()
    num_runs = 3;
    N_gen = 100;
    colors = ['b','r','g'];

    max_scores_all = zeros(1,num_runs);
    workloads_all = cell(1,num_runs);
    max_score_per_gen_all = zeros(num_runs, N_gen);

    figure; hold on; grid on;
    xlabel('Generation');
    ylabel('Maximum Score (Number of Switches)');
    title('Stress Test GA: Maximum Switching Activity per Generation');

    for run = 1:num_runs
        fprintf('Running GA execution %d...\n', run);
        [workload_max, max_score_per_gen, max_score] = stress_test_ga_single_run(N_gen);
        max_scores_all(run) = max_score;
        workloads_all{run} = workload_max;
        max_score_per_gen_all(run,:) = max_score_per_gen;

        plot(1:N_gen, max_score_per_gen, colors(run), 'LineWidth', 1.5);
    end

    legend('Run 1','Run 2','Run 3');
    hold off;

    [overall_max, idx] = max(max_scores_all);
    workload_max = workloads_all{idx};
    fprintf("\n=== BEST RUN ===\n");
    fprintf("Maximum number of signal switches: %d\n\n", overall_max);
    fprintf("Workload that caused maximum switching activity:\n");
    fprintf("------------------------------------------------\n");
    n_inputs = size(workload_max,2);
    for i = 1:n_inputs
        fprintf("%-5s %d -> %d\n", sprintf('i%d',i), workload_max(1,i,1), workload_max(1,i,2));
    end
end

function [workload_max, max_score_per_gen, max_score] = stress_test_ga_single_run(N_gen)
    filename = 'circuit.txt';
    pop_size = 30;
    L = 2;

    [ElementsTableSorted, SignalsTable, ElementTypes, top_inputs, signal_names] = ex3_2(filename);
    n_inputs = length(top_inputs);
    internal_signals = setdiff(signal_names, top_inputs);
    population = randi([0 1], pop_size, n_inputs, L);
    max_score = 0;
    workload_max = zeros(1, n_inputs, L);
    max_score_per_gen = zeros(1, N_gen);

    for g = 1:N_gen
        scoreI = zeros(1, pop_size);

        for i = 1:pop_size
            signal_values = zeros(L, length(internal_signals));

            for t = 1:L
                SignalsTable_tmp = SignalsTable;

                % find its circuit input in signal_names and put certain value
                for j = 1:n_inputs
                    idx = find(strcmp(signal_names, top_inputs{j}));
                    SignalsTable_tmp(idx) = population(i,j,t);
                end

                SignalsTable_tmp = evaluate_circuit_loaded(ElementsTableSorted, SignalsTable_tmp, ElementTypes);

                % find its circuit output in signal_names and put certain value
                for k = 1:length(internal_signals)
                    idx = find(strcmp(signal_names, internal_signals{k}));
                    signal_values(t, k) = round(SignalsTable_tmp(idx));
                end
            end

            scoreI(i) = sum(abs(signal_values(2,:) - signal_values(1,:)));
        end

        [parent1, parent2, ~, ~] = gaSelectParents(scoreI, population, pop_size, L);
        while isequal(parent1, parent2)
            idx = randi(pop_size);
            parent2 = population(idx,:,:);
        endwhile

        [max_gen_score, idx_max] = max(scoreI);
        max_score_per_gen(g) = max_gen_score;
        if max_gen_score > max_score
            max_score = max_gen_score;
            workload_max = population(idx_max,:,:);
        end

        new_population = zeros(size(population));
        new_population(1,:,:) = parent1;
        new_population(2,:,:) = parent2;

        for i = 3:2:pop_size
            [child1, child2] = gaCrossoverCoin(parent1, parent2);
            new_population(i,:,:) = child1;
            if i+1 <= pop_size
                new_population(i+1,:,:) = child2;
            end
        end

        new_population = gaMutatePopulation(new_population, 0.05, 2);
        population = new_population;
    end
end

function [parent1, parent2, score1, score2] = gaSelectParents(scores, population, N, L)
    [sorted_scores, idx] = sort(scores, 'descend');
    parent1 = population(idx(1),:,:);
    parent2 = population(idx(2),:,:);
    score1 = sorted_scores(1);
    score2 = sorted_scores(2);
end

function [child1, child2] = gaCrossoverCoin(parent1, parent2)
    [~, n_inputs, L] = size(parent1);
    point = randi([1 n_inputs-1]);
    if rand < 0.5
        child1 = cat(2, parent1(:,1:point,:), parent2(:,point+1:end,:));
        child2 = cat(2, parent2(:,1:point,:), parent1(:,point+1:end,:));
    else
        child1 = cat(2, parent2(:,1:point,:), parent1(:,point+1:end,:));
        child2 = cat(2, parent1(:,1:point,:), parent2(:,point+1:end,:));
    end
end

function mutated_population = gaMutatePopulation(pop, mutation_rate, elite_count)
    [N, n_inputs, L] = size(pop);
    mutated_population = pop;
    for i = (elite_count+1):N
        for j = 1:n_inputs
            for t = 1:L
                if rand < mutation_rate
                    mutated_population(i,j,t) = 1 - mutated_population(i,j,t);
                end
            end
        end
    end
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
                SignalsTable(el.output) = mod(sum(round(inp)),2);
            case 'NAND'
                SignalsTable(el.output) = 1 - prod(inp);
            case 'NOR'
                SignalsTable(el.output) = prod(1 - inp);
            case 'XNOR'
                SignalsTable(el.output) = 1 - mod(sum(round(inp)),2);
            otherwise
                error("Unknown gate type");
        endswitch
    end
end

