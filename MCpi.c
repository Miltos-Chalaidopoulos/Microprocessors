#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define A 1.0f //squere's side

int N[] = {10,100,1000,5228,5384,10000};
float generate_random_number(){
    float random_float = (float)rand()/RAND_MAX;
    random_float = random_float*A - A/2.0f;
    return random_float;
}

int inside_unit_circle(float x,float y){
    float radius = A/2.0f;
    if (((x*x)+(y*y)) <= radius*radius){
        return 1;
    }else{
        return 0;
    }
}

int find_times_inside_cirlce(int N){
    int counter=0;
    float randomX;
    float randomY;
    for (int i=0; i<N; i++){
        randomX = generate_random_number();
        randomY = generate_random_number();
        if (inside_unit_circle(randomX,randomY)){
            counter++;
        }
    }
    return counter;
}

float calculate_pi(int N,int times_inside_circle){
    float pi;
    pi = 4.0f*(float)times_inside_circle/(float)N;
    return pi;
}

int main(void) {
    printf("a =%f\n",A);
    srand(time(NULL));
    int Ns[] = {10, 100, 1000, 5228, 5384, 10000};
    int num_Ns = sizeof(Ns)/sizeof(Ns[0]);

    for (int i = 0; i < num_Ns; i++) {
        int N = Ns[i];
        int times_inside = find_times_inside_cirlce(N);
        float pi = calculate_pi(N, times_inside);
        printf("For N=%d pi = %f\n", N, pi);
    }
    return 0;
}