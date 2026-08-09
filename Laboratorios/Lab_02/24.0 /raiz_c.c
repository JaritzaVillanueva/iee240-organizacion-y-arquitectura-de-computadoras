#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

double calcularRaiz_C(int x, double precision);
extern double calcularRaiz_Asm(int x, double precision);

int main()
{
    double precision;
    int x;
    printf("Ingresa el numero: ");
    scanf("%d", &x);
    printf("Ingresa la precision: ");
    scanf("%lf", &precision);

    double raiz_C, raiz_asm;

    clock_t ti_asm = clock();
    raiz_asm = calcularRaiz_Asm(x, precision);
    clock_t tf_asm = clock();
    double elapsed_time_asm = ((double)(tf_asm-ti_asm))/CLOCKS_PER_SEC;
    
    clock_t ti_c = clock();
    raiz_C = calcularRaiz_C(x, precision);
    clock_t tf_c = clock();
    double elapsed_time_c = ((double)(tf_c-ti_c))/CLOCKS_PER_SEC;

    printf("Raiz cuadrada en asm es: %.3lf\n", raiz_asm);
    printf("Raiz cuadrada en C es: %.3lf\n", raiz_C);
    printf("---------------------------------------------\n");
    printf("Tiempo de ejcucion en asm es:  %.8lf s\n", elapsed_time_asm);
    printf("Tiempo de ejcucion en C es:  %.8lf s\n", elapsed_time_c);

    double speedup = elapsed_time_c/elapsed_time_asm;
    printf("El speedUp es:  %lf\n", speedup);


    
    return 0;
}

double calcularRaiz_C(int x, double precision)
{
    double guessN = 1.0, guessNi;
    double resta = 9999;
    while (resta > precision)
    {
        guessNi = 0.5 * (guessN + (double)(x/guessN));
        resta = fabs(guessN - guessNi);
        guessN = guessNi;
    }
    return guessNi;
}
