#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>

float spAND_N(int N, float p[]) {
    float s = 1.0;
    for(int i=0;i<N;i++) s *= p[i];
    return s;
}

float spOR_N(int N, float p[]) {
    float s = 1.0;
    for(int i=0;i<N;i++) s *= (1.0 - p[i]);
    return 1.0 - s;
}

float spNAND_N(int N, float p[]) {
    return 1.0 - spAND_N(N,p);
}

float spNOR_N(int N, float p[]) {
    float s = 1.0;
    for(int i=0;i<N;i++) s *= (1.0 - p[i]);
    return s;
}

float spXOR_N(int N, float p[]) {
    float prod = 1.0;
    for(int i=0;i<N;i++) prod *= (1.0 - 2.0*p[i]);
    return 0.5*(1.0 - prod);
}

float switching_activity(float s){
    return 2*s*(1-s);
}

void signalprobs_N(int N,float p[]){
    float s;
    s = spAND_N(N,p);
    printf("AND  Signal Probabilitiy = %.5f, Switching Activity = %.5f\n", s, switching_activity(s));
    s = spOR_N(N,p);
    printf("OR   Signal Probabilitiy = %.5f, Switching Activity = %.5f\n", s, switching_activity(s));
    s = spXOR_N(N,p);
    printf("XOR  Signal Probabilitiy = %.5f, Switching Activity = %.5f\n", s, switching_activity(s));
    s = spNAND_N(N,p);
    printf("NAND Signal Probabilitiy = %.5f, Switching Activity = %.5f\n", s, switching_activity(s));
    s = spNOR_N(N,p);
    printf("NOR  Signal Probabilitiy = %.5f, Switching Activity = %.5f\n", s, switching_activity(s));
}


int main(int argc,char *argv[]){
    if (argc<3){
        printf("Usage: %s N p1 p2 ... pN\n", argv[0]);
    }
    int N = atoi(argv[1]);
    if(argc != N+2) {
        printf("Error: Number of probabilities provided does not match N\n");
        return 1;
    }
    float p[N];
    for(int i=0;i<N;i++) {
        p[i] = atof(argv[i+2]);
    }
    signalprobs_N(N, p);
    return 0;
}