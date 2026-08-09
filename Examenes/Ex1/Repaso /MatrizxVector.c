#include <stdio.h>
#include <stdlib.h>

extern void matriz_vector_asm(double *A, double *x, double *b, int N);
void matriz_vector(double *A, double *x, double *b, int N);

int main()
{
    double A[] = {1,2,3,4};
    double x[] = {1,2};
    double b[] = {0,0};
    double b_asm[] = {0,0};
    
    int N = 2;
    matriz_vector(A,x,b,N);
    printf("%f ", b[0]);
    printf("%f \n", b[1]);

    matriz_vector_asm(A,x,b_asm,N);
    printf("%f ", b_asm[0]);
    printf("%f \n", b_asm[1]);

    
    return 0;
}

void matriz_vector(double *A, double *x, double *b, int N)
{
    for (int j = 0; j<N; j++)
    {
        double temp = 0.0;
        for (int i = 0; i<N; i++)
        {
            temp+=A[i+N*j]*x[i];
        }
        b[j] = temp;
    }
}
