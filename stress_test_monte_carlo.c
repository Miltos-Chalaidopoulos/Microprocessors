#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAX_ELEMENTS 200
#define MAX_SIGNALS  500
#define MAX_NAME_LEN 32
#define MAX_INPUTS   200
#define MAX_INPUTS_PER_GATE 5
#define L 2
#define N 2000

typedef struct {
    char type[10];
    char out[MAX_NAME_LEN];
    char inputs[MAX_INPUTS_PER_GATE][MAX_NAME_LEN];
    int num_inputs;
} Element;

typedef struct {
    char name[MAX_NAME_LEN];
    int value;
} Signal;

Element Elements[MAX_ELEMENTS];
Signal Signals[MAX_SIGNALS];
char top_inputs[MAX_INPUTS][MAX_NAME_LEN];
int num_elements = 0, num_signals = 0, num_inputs = 0;

int find_signal_index(const char *name) {
    for (int i = 0; i < num_signals; i++)
        if (strcmp(Signals[i].name, name) == 0)
            return i;
    strcpy(Signals[num_signals].name, name);
    Signals[num_signals].value = 0;
    return num_signals++;
}

int get_signal_value(const char *name) {
    for (int i = 0; i < num_signals; i++)
        if (strcmp(Signals[i].name, name) == 0)
            return Signals[i].value;
    return 0;
}

void set_signal_value(const char *name, int val) {
    for (int i = 0; i < num_signals; i++)
        if (strcmp(Signals[i].name, name) == 0) {
            Signals[i].value = val;
            return;
        }
}

int eval_gate(const char *type, int *inputs, int n) {
    if (strcmp(type, "AND") == 0) {
        int out = 1;
        for (int i = 0; i < n; i++) out &= inputs[i];
        return out;
    } else if (strcmp(type, "NAND") == 0) {
        int out = 1;
        for (int i = 0; i < n; i++) out &= inputs[i];
        return !out;
    } else if (strcmp(type, "OR") == 0) {
        int out = 0;
        for (int i = 0; i < n; i++) out |= inputs[i];
        return out;
    } else if (strcmp(type, "NOR") == 0) {
        int out = 0;
        for (int i = 0; i < n; i++) out |= inputs[i];
        return !out;
    } else if (strcmp(type, "XOR") == 0) {
        int sum = 0;
        for (int i = 0; i < n; i++) sum += inputs[i];
        return sum % 2;
    } else if (strcmp(type, "XNOR") == 0) {
        int sum = 0;
        for (int i = 0; i < n; i++) sum += inputs[i];
        return !(sum % 2);
    } else if (strcmp(type, "NOT") == 0) {
        return !inputs[0];
    } else {
        printf("Unknown gate: %s\n", type);
        exit(1);
    }
}

void evaluate_circuit() {
    for (int i = 0; i < num_elements; i++) {
        int in_vals[MAX_INPUTS_PER_GATE];
        for (int j = 0; j < Elements[i].num_inputs; j++) {
            in_vals[j] = get_signal_value(Elements[i].inputs[j]);
        }
        int out_val = eval_gate(Elements[i].type, in_vals, Elements[i].num_inputs);
        set_signal_value(Elements[i].out, out_val);
    }
}

void load_circuit_struct(const char *filename) {
    FILE *fp = fopen(filename, "r");
    if (!fp) {
        printf("Cannot open %s\n", filename);
        exit(1);
    }

    char line[256];
    int first_line = 1;

    while (fgets(line, sizeof(line), fp)) {
        if (strlen(line) < 2) continue;

        if (first_line && strncmp(line, "TLPINPUTS", 9) == 0) {
            char *token = strtok(line, " \t\n");
            token = strtok(NULL, " \t\n");
            while (token) {
                if (num_inputs >= MAX_INPUTS) {
                    printf("Error: too many inputs (max %d)\n", MAX_INPUTS);
                    exit(1);
                }
                strncpy(top_inputs[num_inputs], token, MAX_NAME_LEN - 1);
                top_inputs[num_inputs][MAX_NAME_LEN - 1] = '\0';
                find_signal_index(token);
                num_inputs++;
                token = strtok(NULL, " \t\n");
            }
            first_line = 0;
            continue;
        }

        first_line = 0;

        char *tokens[10];
        int count = 0;
        char *tok = strtok(line, " \t\n");
        while (tok && count < 10) {
            tokens[count++] = tok;
            tok = strtok(NULL, " \t\n");
        }
        if (count < 2) continue;

        if (num_elements >= MAX_ELEMENTS) {
            printf("Error: too many elements (max %d)\n", MAX_ELEMENTS);
            exit(1);
        }

        Element *e = &Elements[num_elements];
        strncpy(e->type, tokens[0], sizeof(e->type)-1);
        e->type[sizeof(e->type)-1] = '\0';
        strncpy(e->out, tokens[1], sizeof(e->out)-1);
        e->out[sizeof(e->out)-1] = '\0';
        find_signal_index(tokens[1]);

        e->num_inputs = count - 2;
        if (e->num_inputs > MAX_INPUTS_PER_GATE)
            e->num_inputs = MAX_INPUTS_PER_GATE;
        for (int j = 0; j < e->num_inputs; j++) {
            strncpy(e->inputs[j], tokens[j + 2], MAX_NAME_LEN - 1);
            e->inputs[j][MAX_NAME_LEN - 1] = '\0';
            find_signal_index(tokens[j + 2]);
        }

        num_elements++;
    }
    fclose(fp);

    if (num_inputs == 0) {
        printf("Warning: no TLPINPUTS line found.\n");
        exit(1);
    }

    printf("Loaded circuit: %d elements, %d signals, %d inputs\n",
           num_elements, num_signals, num_inputs);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <circuit_file>\n", argv[0]);
        return 1;
    }
    srand(time(NULL));

    load_circuit_struct(argv[1]);

    printf("Top inputs: ");
    for (int i = 0; i < num_inputs; i++)
        printf("%s ", top_inputs[i]);
    printf("\n");

    double total_score = 0;
    int max_score = 0;
    int best_start[MAX_INPUTS], best_end[MAX_INPUTS];

    for (int iter = 0; iter < N; iter++) {
        int test_vectors[L][MAX_INPUTS];
        int signal_values[L][MAX_SIGNALS];

        // generate random inputs
        for (int t = 0; t < L; t++)
            for (int j = 0; j < num_inputs; j++)
                test_vectors[t][j] = rand() % 2;

        // simulate each vector
        for (int t = 0; t < L; t++) {
            for (int j = 0; j < num_inputs; j++)
                set_signal_value(top_inputs[j], test_vectors[t][j]);

            evaluate_circuit();

            for (int s = 0; s < num_signals; s++)
                signal_values[t][s] = Signals[s].value;
        }

        // count switching activity (excluding top-level inputs)
        int switches = 0;
        for (int s = 0; s < num_signals; s++) {
            int is_input = 0;
            for (int j = 0; j < num_inputs; j++) {
                if (strcmp(Signals[s].name, top_inputs[j]) == 0) {
                    is_input = 1;
                    break;
                }
            }
            if (!is_input && signal_values[0][s] != signal_values[1][s])
                switches++;
        }

        total_score += switches;
        if (switches > max_score) {
            max_score = switches;
            for (int j = 0; j < num_inputs; j++) {
                best_start[j] = test_vectors[0][j];
                best_end[j] = test_vectors[1][j];
            }
        }
    }

    printf("Average number of signal switches (excluding inputs): %.2f\n", total_score / N);
    printf("Maximum number of signal switches: %d\n\n", max_score);
    printf("Workload that caused maximum switching activity:\n");
    printf("------------------------------------------------\n");
    for (int i = 0; i < num_inputs; i++)
        printf("%-5s %d -> %d\n", top_inputs[i], best_start[i], best_end[i]);

    return 0;
}
