/*
 * Programa para medir el SpeedUp en la multiplicación de matrices.
 * Compara un enfoque iterativo tradicional contra un algoritmo por bloques (cache-friendly)
 * para analizar el impacto del uso eficiente de la memoria caché.
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 4
#define BLOCK_SIZE 2  // Tamaño del bloque (ajustado según la arquitectura y el tamaño de la caché)

void matrixMultiplicationNotCacheFriendly(int A[N][N], int B[N][N], int C[N][N]) ;
void matrixMultiplicationCacheFriendly(int A[N][N], int B[N][N], int C[N][N]) ;

int main() {
    int A[N][N] = {{1, 2, 3, 4},
                   {5, 6, 7, 8},
                   {9, 10, 11, 12},
                   {13, 14, 15, 16}};

    int B[N][N] = {{17, 18, 19, 20},
                   {21, 22, 23, 24},
                   {25, 26, 27, 28},
                   {29, 30, 31, 32}};

    int C[N][N] = {{0, 0, 0, 0},
                   {0, 0, 0, 0},
                   {0, 0, 0, 0},
                   {0, 0, 0, 0}};

    // Realizar la multiplicación usando un enfoque cache-friendly
    clock_t ti_friendly = clock();
    matrixMultiplicationCacheFriendly(A, B, C);
    clock_t tf_friendly  = clock();

    double elapsed_time_Friendly = ((double)(tf_friendly-ti_friendly))/CLOCKS_PER_SEC;


   int D[N][N] = {{0, 0, 0, 0},
                   {0, 0, 0, 0},
                   {0, 0, 0, 0},
                   {0, 0, 0, 0}};

    clock_t ti_Notfriendly = clock();
    matrixMultiplicationNotCacheFriendly(A, B, D);
    clock_t tf_Notfriendly  = clock();

    double elapsed_time_NoFriendly = ((double)(tf_Notfriendly-ti_Notfriendly))/CLOCKS_PER_SEC;

    double speedup = elapsed_time_Friendly/elapsed_time_NoFriendly;
    printf("El speedUp es:  %lf\n", speedup);

    return 0;
}

void matrixMultiplicationNotCacheFriendly(int A[N][N], int B[N][N], int C[N][N]) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            for (int k = 0; k < N; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}

void matrixMultiplicationCacheFriendly(int A[N][N], int B[N][N], int C[N][N]) {
    for (int i = 0; i < N; i += BLOCK_SIZE) {
        for (int j = 0; j < N; j += BLOCK_SIZE) {
            for (int k = 0; k < N; k += BLOCK_SIZE) {
                // Multiplicación de bloques cache-friendly
                for (int ii = i; ii < i + BLOCK_SIZE; ++ii) {
                    for (int jj = j; jj < j + BLOCK_SIZE; ++jj) {
                        for (int kk = k; kk < k + BLOCK_SIZE; ++kk) {
                            C[ii][jj] += A[ii][kk] * B[kk][jj];
                        }
                    }
                }
            }
        }
    }
}
