printf("3_2\n");
function [ElementsTable, SignalsTable, ElementTypes, top_inputs, signal_names] = ex3_2(filename)
    ElementTypes = {'AND','NOT','OR','XOR','NAND','NOR','XNOR'};
    [ElementsTable, top_inputs, SignalsTable, signal_names] = load_circuit_file(filename, ElementTypes);
    top_input_indices = zeros(1, length(top_inputs));
    for i = 1:length(top_inputs)
        top_input_indices(i) = find(strcmp(signal_names, top_inputs{i}));
    end
    ElementsTable = topological_sort(ElementsTable, top_input_indices);
endfunction

function [ElementsTable, top_inputs, SignalsTable, signal_names] = load_circuit_file(filename, ElementTypes)
    fid = fopen(filename,'r');
    if fid==-1, error('File not found: %s',filename); end
    lines = {};
    while ~feof(fid)
        line = strtrim(fgetl(fid));
        if isempty(line), continue; end
        lines{end+1} = line;
    end
    fclose(fid);

    if startsWith(lines{1}, 'TLPINPUTS')
        tokens = strsplit(lines{1});
        top_inputs = tokens(2:end);
        lines(1) = [];
    else
        top_inputs = {};
    end

    signal_names = {};
    ElementsTable = {};

    for i = 1:length(lines)
        tokens = strsplit(lines{i});
        type_str = upper(tokens{1});
        out_name = tokens{2};
        input_names = tokens(3:end);

        idx_type = find(strcmpi(ElementTypes,type_str));
        if isempty(idx_type), error('Unknown gate type: %s',type_str); end
        idx_type = idx_type(1);

        % make sure eatch singals is only once in the arrays
        if ~any(strcmp(signal_names,out_name)), signal_names{end+1} = out_name; end
        for j = 1:length(input_names)
            if ~any(strcmp(signal_names,input_names{j})), signal_names{end+1} = input_names{j}; end
        end

        % calculate index of signal in array signal names
        input_idx = zeros(1,length(input_names));
        for j = 1:length(input_names)
            input_idx(j) = find(strcmp(signal_names,input_names{j}));
        end
        output_idx = find(strcmp(signal_names,out_name));

        el_struct = struct('type_index',idx_type,'inputs',input_idx,'output',output_idx,'out',out_name);
        ElementsTable{end+1} = el_struct;
    end

    if isempty(top_inputs)
        all_outputs = cellfun(@(e)e.out, ElementsTable,'UniformOutput',false);
        top_inputs = setdiff(signal_names, all_outputs);
    end

    SignalsTable = zeros(1,length(signal_names));
end

function ElementsTableSorted = topological_sort(ElementsTable, top_input_indices)
    ElementsTableSorted = {};
    ElementsLeft = ElementsTable;
    SignalsAvailable = top_input_indices;

    while ~isempty(ElementsLeft)
        added_this_round = false;
        to_remove = [];

        for i = 1:length(ElementsLeft)
            element = ElementsLeft{i};
            if all(ismember(element.inputs, SignalsAvailable))
                ElementsTableSorted{end+1} = element;
                SignalsAvailable(end+1) = element.output;
                to_remove(end+1) = i;
                added_this_round = true;
            end
        end

        if ~added_this_round
            error('Cannot sort elements: circular dependency detected or missing inputs.');
        end

        ElementsLeft(to_remove) = [];
    end
end

