#include <stdio.h>

int cmpfunc(const void * a, const void * b) {
    return (*(int*)a - *(int *)b );
}

int solution(int K, int A[], int N) {
    int n;
    int P, Q, len, min, max;
    int * pos;
    n = 0;
    min = 0;
    max = 0;
    for (P = 0; P < N; P++) {
        for (Q = 0 ; Q < N; Q++) {

            len = 0;
            min = 0;
            max = 0;
            len = Q - P + 1;
            if (P == Q)  {
                n++;
                printf("Pair: (%d, %d): count = %d\n", P, Q, n);
            } else if (P <= Q) {
                pos = A;
                int tmp[len];
                int x;
                for(x = 0; x < len; x++) {
                    tmp[x] = *(pos + x);
                }

                pos = tmp;
                if (len > 1) {
                    qsort(tmp, len, sizeof(int), cmpfunc);
                    min = tmp[0];
                    max = tmp[len - 1];
                } else {
                    min = tmp[0];
                    max = tmp[0];
                }

                printf("Pair: (%d, %d): min: %d, max: %d, count = %d\n", P, Q, min, max, n);
                int delta = 0;
                delta = max - min;
                if ((delta > 0) && (delta <= K)) {
                    n++;
                    printf("Pair: (%d, %d): min: %d, max: %d, count = %d\n", P, Q, min, max, n);
                }

                for(x = 0; x < len; x++) {
                    tmp[x] = 0;
                }

                pos = NULL;


            }
        }
    }

    printf("bounded slice: %d\n", n);

    return n;
}

int main() {
    int A[] = {3,5,7,6,3};
    printf("{3,5,7,6,3}\n");
    solution(2, A, 6);
//    int A[] = {4, 5, 8, 5, 1, 4, 6, 8, 7, 2, 2, 5}; // 44

    printf("[4, 5, 8, 5, 1, 4, 6, 8, 7, 2, 2, 5]\n");
    //solution(6, A, 12);
}
