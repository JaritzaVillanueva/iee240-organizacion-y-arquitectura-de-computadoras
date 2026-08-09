/*
 * Programa para la multiplicación de una matriz por un vector usando datos de precisión doble (double).
 * Compara los resultados de una implementación estándar en C contra una función optimizada
 * en ensamblador con vectorización SIMD (matriz_vector_simd).
 */
#include <stdio.h>

void matriz_vector(double *A, double *x, double *b, int N);
extern void matriz_vector_simd(double *A, double *x, double *b, int N);

int main(){
    double a[16] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
    double b[4] = {10,20,30,40};
    double c[4] = {0, 0, 0, 0};
    double c_asm[4] = {0, 0, 0, 0};

    matriz_vector(a, b, c, 4);
    printf("%.2f %.2f %.2f %.2f\n", c[0], c[1], c[2], c[3]);

    matriz_vector_simd(a, b, c_asm, 4);
    printf("%.2f %.2f %.2f %.2f\n", c_asm[0], c_asm[1], c_asm[2], c_asm[3]);
    
}

void matriz_vector(double *A, double *x, double *b, int N){
    for(int i=0; i<N; i++){
        double temp = 0.0;
        for(int j = 0; j<N; j++){
            temp += A[i*N+j]*x[j];
        }
        b[i] = temp;
    }
}
