#include <stdio.h>
#include <math.h>

// Función para calcular el área del polígono utilizando la fórmula de Gauss
double calcularAreaGauss(double x[], double y[], int vertices) {
    double area = 0.0;

    // Calcular el área utilizando la fórmula de Gauss
    for (int i = 0; i < vertices - 1; i++) {
        area += (x[i] * y[i + 1]) - (x[i + 1] * y[i]);
    }

    area += (x[vertices - 1] * y[0]) - (x[0] * y[vertices - 1]);

    // Tomar el valor absoluto del área
    area = 0.5 * fabs(area);

    return area;
}

int main() {
    // Ejemplo de uso
    int vertices = 4;
    double coordenadasX[] = {0.0, 1.0, 1.0, 0.0};
    double coordenadasY[] = {0.0, 0.0, 1.0, 1.0};

    // Calcular el área del polígono
    double areaPoligono = calcularAreaGauss(coordenadasX, coordenadasY, vertices);

    // Imprimir el resultado
    printf("El área del polígono es: %.2lf\n", areaPoligono);

    return 0;
}
