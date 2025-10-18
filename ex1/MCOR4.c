#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int get_random_bit(){
    return rand()%2;
}

int main(){
    srand(time(NULL));
    
    int N_values[] = {10, 20, 30, 5228,5384};
    int numTests = sizeof(N_values) / sizeof(N_values[0]);
    
    for (int t = 0; t < numTests; t++) {
        int N = N_values[t];
        int gateOutput = 0;
        int switchesCount = 0;

        for (int i = 0; i < N; i++) {
            int I1 = get_random_bit();
            int I2 = get_random_bit();
            int I3 = get_random_bit();
            int I4 = get_random_bit();
            
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