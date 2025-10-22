#include <stdio.h>
#include <stdlib.h>
#include <time.h>

float sp2and(float input1sp, float input2sp){
    return input1sp*input2sp;
}

float spNot(float input_sp){
    return 1.0f-input_sp;
}

float sa_from_sp(float s){
    return 2*s*(1.0f-s);
}

int getRandomNumber(double prob){
    return ((double)rand() / (double)RAND_MAX) < prob ? 1 : 0;
}

void monte_carlo(float pa, float pb, float pc, int n){
    int prev_a = getRandomNumber(pa);
    int prev_b = getRandomNumber(pb);
    int prev_c = getRandomNumber(pc);
    int prev_e = prev_a && prev_b;
    int prev_f = !prev_c;
    int prev_d = prev_e && prev_f;

    int count_e_ones = prev_e;
    int count_f_ones = prev_f;
    int count_d_ones = prev_d;

    int e_switches = 0;
    int f_switches = 0;
    int d_switches = 0;

    for(int i = 1; i < n; i++){
        int curr_a = getRandomNumber(pa);
        int curr_b = getRandomNumber(pb);
        int curr_c = getRandomNumber(pc);

        int curr_e = curr_a && curr_b;
        int curr_f = !curr_c;
        int curr_d = curr_e && curr_f;

        count_e_ones += curr_e;
        count_f_ones += curr_f;
        count_d_ones += curr_d;

        if(curr_e != prev_e) e_switches++;
        if(curr_f != prev_f) f_switches++;
        if(curr_d != prev_d) d_switches++;

        prev_a = curr_a;
        prev_b = curr_b;
        prev_c = curr_c;
        prev_e = curr_e;
        prev_f = curr_f;
        prev_d = curr_d;
    }

    float sp_e = (float)count_e_ones / n;
    float sp_f = (float)count_f_ones / n;
    float sp_d = (float)count_d_ones / n;

    float sa_e = (float)e_switches / (n - 1);
    float sa_f = (float)f_switches / (n - 1);
    float sa_d = (float)d_switches / (n - 1);

    printf("Monte Carlo for N=%d\n", n);
    printf("Signal probabilities: \te : %f\t f : %f\t d: %f\n", sp_e, sp_f, sp_d);
    printf("Switching activities: \te : %f\t f : %f\t d: %f\n\n", sa_e, sa_f, sa_d);
}

void print_truth_table(){
    int a,b,c;
    printf("Truth table\n");
    printf("A\tB\tC\tE\tF\tD");
    for(a=0;a<=1;a++)
    for(b=0;b<=1;b++)
    for(c=0;c<=1;c++)
    {
        printf("\n\n %d \t %d \t %d \t %d \t %d \t %d", a,b,c,(a&b),(!c),((a&b)&(!c)));
    }
    printf("\n");
}
int main(int argc ,char *argv[]){
    if (argc == 1){
        print_truth_table();
        return 0;
    }else if(argc != 4){
        printf("Incorrect input. Please enter probabilities for a,b,c e.g. ./a.out 0.2 0.3 0.4");
        return 1;
    }

    float a = atof(argv[1]);
    float b = atof(argv[2]);
    float c = atof(argv[3]);

    float e = sp2and(a,b);
    float f = spNot(c);
    float d = sp2and(e,f);

    float d_sa = sa_from_sp(d);
    float e_sa = sa_from_sp(e);
    float f_sa = sa_from_sp(f);

    printf("Propabilities Input\t");
    printf("a = %f\t b = %f\t c = %f\n\n",a,b,c);
    printf("Signal probabilities: \t");
    printf("e = %f\t f = %f\t d = %f\n",e,f,d);
    printf("Switching activities: \t");
    printf("e = %f\t f = %f\t d = %f\n\n\n",e_sa,f_sa,d_sa);

    srand((unsigned)time(NULL));
    monte_carlo(a,b,c,10);
    monte_carlo(a,b,c,100);
    monte_carlo(a,b,c,5228);
    monte_carlo(a,b,c,5384);
}
