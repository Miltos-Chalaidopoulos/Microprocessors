#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SIGNALS 20
#define MAX_GATES 20
#define MAX_INPUTS 5

typedef struct {
    char name[10];
    float value;
} Signal;

typedef struct {
    int type_index;       // 0=NOT, 1=AND, 2=OR, 3=XOR, 4=NAND, 5=NOR, 6=XNOR
    char inputs[MAX_INPUTS][10];
    int num_inputs;
    char out[10];
} Gate;

const char* ElementTypes[] = {"NOT","AND","OR","XOR","NAND","NOR","XNOR"};

Signal SignalsTable[MAX_SIGNALS];
int num_signals = 0;

Gate ElementsTable[MAX_GATES];
int num_gates = 0;

Gate ElementsTableSorted[MAX_GATES];
int num_gates_sorted = 0;

char top_inputs[MAX_SIGNALS][10];
int num_top_inputs = 0;

char all_outputs[MAX_SIGNALS][10];
int num_all_outputs = 0;

void set_signal_value(const char* name, float val) {
    for(int i=0;i<num_signals;i++) {
        if(strcmp(SignalsTable[i].name, name)==0) {
            SignalsTable[i].value = val;
            return;
        }
    }
    strcpy(SignalsTable[num_signals].name, name);
    SignalsTable[num_signals].value = val;
    num_signals++;
}

float get_signal_value(const char* name) {
    for(int i=0;i<num_signals;i++)
        if(strcmp(SignalsTable[i].name,name)==0) return SignalsTable[i].value;
    return 0;
}

void load_circuit_struct(const char* filename) {
    FILE* f = fopen(filename,"r");
    if(!f) { printf("File not found\n"); exit(1); }

    char line[256];
    while(fgets(line,sizeof(line),f)) {
        if(line[0]=='\n') continue;
        char* tok = strtok(line," \t\n");
        if(!tok) continue;

        char gate_type[10];
        strcpy(gate_type,tok);
        tok = strtok(NULL," \t\n");
        char out[10];
        strcpy(out,tok);

        Gate g;
        g.num_inputs=0;
        g.type_index=-1;
        strcpy(g.out,out);

        for(int i=0;i<7;i++)
            if(strcmp(gate_type,ElementTypes[i])==0) g.type_index=i;

        tok = strtok(NULL," \t\n");
        while(tok) {
            strcpy(g.inputs[g.num_inputs++], tok);
            set_signal_value(tok,0);
            tok = strtok(NULL," \t\n");
        }

        ElementsTable[num_gates++] = g;
        set_signal_value(out,0);
        strcpy(all_outputs[num_all_outputs++], out);
    }
    fclose(f);

    for(int i=0;i<num_signals;i++) {
        int is_output = 0;
        for(int j=0;j<num_all_outputs;j++)
            if(strcmp(SignalsTable[i].name, all_outputs[j])==0)
                is_output = 1;
        if(!is_output)
            strcpy(top_inputs[num_top_inputs++], SignalsTable[i].name);
    }
}

void evaluate_circuit_struct() {
    for(int i=0;i<num_gates_sorted;i++) {
        Gate g = ElementsTableSorted[i];
        float in_vals[MAX_INPUTS];
        for(int j=0;j<g.num_inputs;j++)
            in_vals[j] = get_signal_value(g.inputs[j]);
        float out_val = 0;
        switch(g.type_index) {
            case 0: out_val = 1 - in_vals[0]; break; // NOT
            case 1: out_val = in_vals[0]*in_vals[1]; break; // AND
            case 2: out_val = 1-(1-in_vals[0])*(1-in_vals[1]); break; // OR
            case 3: out_val = in_vals[0]*(1-in_vals[1]) + (1-in_vals[0])*in_vals[1]; break; // XOR
            case 4: out_val = 1-(in_vals[0]*in_vals[1]); break; // NAND
            case 5: out_val = (1-in_vals[0])*(1-in_vals[1]); break; // NOR
            case 6: out_val = 1-(in_vals[0]*(1-in_vals[1]) + (1-in_vals[0])*in_vals[1]); break; // XNOR
        }
        set_signal_value(g.out, out_val);
    }
}

void topological_sort() {
    int added[MAX_GATES] = {0};
    int total_added = 0;
    num_gates_sorted = 0;

    while(total_added < num_gates) {
        int progress = 0;
        for(int i=0;i<num_gates;i++) {
            if(added[i]) continue;
            int ready = 1;
            for(int j=0;j<ElementsTable[i].num_inputs;j++) {
                int found = 0;
                for(int k=0;k<num_top_inputs;k++)
                    if(strcmp(ElementsTable[i].inputs[j], top_inputs[k])==0) found=1;
                for(int k=0;k<num_gates_sorted;k++)
                    if(strcmp(ElementsTable[i].inputs[j], ElementsTableSorted[k].out)==0) found=1;
                if(!found) { ready=0; break; }
            }
            if(ready) {
                ElementsTableSorted[num_gates_sorted++] = ElementsTable[i];
                added[i] = 1;
                progress = 1;
                total_added++;
            }
        }
        if(!progress) {
            printf("Error: circular dependency detected!\n");
            exit(1);
        }
    }
}

void generate_truth_table_struct() {
    int n = num_top_inputs;
    printf("Truth Table:\n");
    printf(" ");
    for(int i=0;i<n;i++) printf(" %s ",top_inputs[i]);
    printf("| ");
    for(int i=0;i<num_all_outputs;i++) printf("%s ", all_outputs[i]);
    printf("\n--------------------------------\n");

    int total = 1<<n;
    for(int k=0;k<total;k++) {
        for(int i=0;i<n;i++)
            set_signal_value(top_inputs[i], ((k>>(n-1-i))&1));
        evaluate_circuit_struct();
        for(int i=0;i<n;i++) printf(" %d ", (int)(get_signal_value(top_inputs[i])+0.5));
        printf("| ");
        for(int i=0;i<num_all_outputs;i++)
            printf("%d ", (int)(get_signal_value(all_outputs[i])+0.5));
        printf("\n");
    }
}

void testbench() {
    float test_cases[2][3] = {{0.5228,0.5228,0.5228},{0.5384,0.5384,0.5384}};
    printf("\nSwitching Activity (Unknown Workload):\n");
    printf(" a      b      c   | ");
    for(int i=0;i<num_all_outputs;i++) printf("%s_sa  ", all_outputs[i]);
    printf("\n-------------------------------------------\n");

    for(int t=0;t<2;t++) {
        for(int i=0;i<num_top_inputs;i++)
            set_signal_value(top_inputs[i], test_cases[t][i]);
        evaluate_circuit_struct();

        for(int i=0;i<num_top_inputs;i++)
            printf(" %.4f  ", test_cases[t][i]);
        printf("| ");
        for(int i=0;i<num_all_outputs;i++) {
            float val = get_signal_value(all_outputs[i]);
            float sa = 2*val*(1-val);
            printf("%.4f  ", sa);
        }
        printf("\n");
    }
}

int main(int argc, char *argv[]) {
    if(argc < 2) {
        printf("Usage: %s <circuit_file>\n", argv[0]);
        return 1;
    }

    load_circuit_struct(argv[1]);

    topological_sort();
    generate_truth_table_struct();
    testbench();

    return 0;
}
