#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    long n = atol(argv[1]);
    printf("Hailstone for n = %ld:\n", n);
    int steps = 1;
    while (n != 1) {
        printf("%ld ", n);
        steps++;
        
        if (n % 2 == 0) {
            n = n / 2;
        } else {
            n = 3 * n + 1;
        }
    }
    printf("1\n");
    steps++;
    printf("Length: %d steps\n", steps);
    return 0;
}
