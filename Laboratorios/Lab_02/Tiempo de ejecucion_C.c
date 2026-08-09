#include <stdio.h>
#include <time.h>

double calcularAreaGauss(double x[], double y[], int vertices);

int main() {
    // Inicializar datos de prueba (reemplázalos con tus propios datos)
    double x[] = {1.0, 2.0, 3.0, 4.0, 5.0};
    double y[] = {2.0, 3.0, 4.0, 5.0, 6.0};
    int vertices = 5;

    // Medir el tiempo de ejecución
    clock_t start_time = clock();

    // Llamar a la función
    double area = calcularAreaGauss(x, y, vertices);

    // Calcular y mostrar el tiempo de ejecución
    clock_t end_time = clock();
    double elapsed_time = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;
    
    printf("Área calculada: %lf\n", area);
    printf("Tiempo de ejecución: %lf segundos\n", elapsed_time);

    return 0;
}
