#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int get_random_bit_with_prob(double p) {
    double r = (double)rand() / RAND_MAX;
    return (r < p) ? 1 : 0;
}

int main(int argc, char *argv[]) {
    srand(time(NULL));

    double p1 = 0.8, p2 = 0.5, p3 = 0.3, p4 = 0.7;

    if (argc == 5) {
        p1 = atof(argv[1]);
        p2 = atof(argv[2]);
        p3 = atof(argv[3]);
        p4 = atof(argv[4]);
    } else {
        printf("Using default probabilities: %.2f %.2f %.2f %.2f\n", p1, p2, p3, p4);
        printf("Give probabilities with: ./a.out p1 p2 p3 p4\n");
    }

    int N_values[] = {10, 20, 30, 5228, 5384};
    int numTests = sizeof(N_values) / sizeof(N_values[0]);

    for (int t = 0; t < numTests; t++) {
        int N = N_values[t];
        int gateOutput = 0;
        int switchesCount = 0;

        for (int i = 0; i < N; i++) {
            int I1 = get_random_bit_with_prob(p1);
            int I2 = get_random_bit_with_prob(p2);
            int I3 = get_random_bit_with_prob(p3);
            int I4 = get_random_bit_with_prob(p4);

            int newGateOutput = I1 | I2 | I3 | I4;
            if (newGateOutput != gateOutput) {
                switchesCount++;
                gateOutput = newGateOutput;
            }
        }
        printf("Total vectors: %d \t", N);
        printf("Number of switches: %d\t", switchesCount);
        printf("Switching Activity: %f\n", (double)switchesCount / N);
    }

    return 0;
}
