#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>

float sp2AND(float input1sp , float input2sp){
    printf("AND Gate for input probabilities %f %f = ",input1sp,input2sp);
    float s = input1sp * input2sp;
    printf("%f\n", s);
    return s;
}

float sp2OR(float input1sp , float input2sp){
    printf("OR Gate for input probabilities %f %f = ",input1sp,input2sp);
    float s = 1 - (1 - input1sp) * (1 - input2sp);
    printf("%f\n", s);
    return s;
}

float sp2XOR(float input1sp,float input2sp){
    printf("XOR Gate for input probabilities %f %f = ",input1sp,input2sp);
    float s =input1sp*(1-input2sp)+(1-input1sp)*input2sp;
    printf("%f\n", s);
    return s;
}

float sp2NAND(float input1sp,float input2sp){
    printf("NAND Gate for input probabilities %f %f = ",input1sp,input2sp);
    float s =1-input1sp * input2sp;
    printf("%f\n", s);
    return s;
}

float sp2NOR(float input1sp,float input2sp){
    printf("NOR Gate for input probabilities %f %f = ",input1sp,input2sp);
    float s = (1 - input1sp) * (1 - input2sp);
    printf("%f\n", s);
    return s;
}

float sp3AND(float input1sp,float input2sp,float input3sp){
    printf("AND Gate for input probabilities %f %f %f = ",input1sp,input2sp,input3sp);
    float s=input1sp*input2sp*input3sp;
    printf("%f\n", s);
    return s;
}

float sp3OR(float input1sp,float input2sp,float input3sp){
    printf("OR Gate for input probabilities %f %f %f = ",input1sp,input2sp,input3sp);
    float s= 1-(1-input1sp)*(1-input2sp)*(1-input3sp);
    printf("%f\n", s);
    return s;
}

float sp3XOR(float input1sp,float input2sp,float input3sp){
    printf("XOR Gate for input probabilities %f %f %f = ",input1sp,input2sp,input3sp);
    float s= input1sp*(1-input2sp)*(1-input3sp)+(1-input1sp)*input2sp*(1-input3sp)+(1-input1sp)*(1-input2sp)*input3sp+input1sp*input2sp*input3sp;
    printf("%f\n", s);
    return s;
}

float sp3NAND(float input1sp,float input2sp,float input3sp){
    printf("NAND Gate for input probabilities %f %f %f = ",input1sp,input2sp,input3sp);
    float s= 1-(input1sp*input2sp*input3sp);
    printf("%f\n", s);
    return s;
}

float sp3NOR(float input1sp,float input2sp,float input3sp){
    printf("NOR Gate for input probabilities %f %f %f = ",input1sp,input2sp,input3sp);
    float s= (1-input1sp)*(1-input2sp)*(1-input3sp);
    printf("%f\n", s);
    return s;
}

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

float saAND_N(int N, float p[]){
    float s = spAND_N(N, p);
    return 2*s*(1-s);
}

float saOR_N(int N, float p[]){
    float s = spOR_N(N, p);
    return 2*s*(1-s);
}

float saXOR_N(int N, float p[]){
    float s = spXOR_N(N, p);
    return 2*s*(1-s);
}

float saNAND_N(int N, float p[]){
    float s = spNAND_N(N, p);
    return 2*s*(1-s);
}

float saNOR_N(int N, float p[]){
    float s = spNOR_N(N, p);
    return 2*s*(1-s);
}

void signalprobs_N(int N,float p[]){
    printf("AND  Signal Probabilitiy = %.5f, Switching Activity = %.5f\n", spAND_N(N,p), saAND_N(N,p));
    printf("OR   Signal Probabilitiy = %.5f, Switching Activity = %.5f\n", spOR_N(N,p), saOR_N(N,p));
    printf("XOR  Signal Probabilitiy = %.5f, Switching Activity = %.5f\n", spXOR_N(N,p), saXOR_N(N,p));
    printf("NAND Signal Probabilitiy = %.5f, Switching Activity = %.5f\n", spNAND_N(N,p), saNAND_N(N,p));
    printf("NOR  Signal Probabilitiy = %.5f, Switching Activity = %.5f\n", spNOR_N(N,p), saNOR_N(N,p));
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