#include <stdio.h>
#include <stdlib.h>
#define N 4
#define MAX 50

void matriz_vector_C(double datos[], int indColum[], int ptrRow[], double vector[], int n, double resultado[]);
//extern void matriz_vector_SIMD(double datos[], int indColum[], int ptrRow[], double vector[], int n, double resultado[]);
void matriz_sparse_C(double matriz[],double datos[], int indColum[], int ptrRow[], int *cant);


int main(){
    double matriz[] = {2, 0, 0, 2, 0, 3, 4, 2, 5, 0, 5, 0, 0, 8, 17, 0};
    double datos[MAX], resultado[MAX];
    int colum[MAX], ptrRow[MAX];
    int cant;
    matriz_sparse_C(matriz, datos, colum, ptrRow, &cant);
    double vector[] = {1, 2, 3, 4};
    for(int i=0; i< N; i++){
        resultado[i] = 0;
    }
    matriz_vector_C(datos, colum, ptrRow, vector, N, resultado);
    for(int i=0; i<N; i++){
        printf("%.2lf ", resultado[i]);
    }
    return 0;
}

//Se sige la misma estructura que en pyhton.
void matriz_vector_C(double datos[], int indColum[], int ptrRow[], double vector[], int n, double resultado[]){
    for (int i=0; i<n; i++){
        int inicio = ptrRow[i];
        int fin = ptrRow[i+1];
        for(int j=inicio; j<fin; j++){
            int c = indColum[j];
            resultado[i] += datos[j] * vector[c];
        }
    }
}

//Se implemento a funcion para hallar el arreglo de datos, indColum, ptrRow y ademas la cantidad de elementos que hay en el arreglo de datos.
void matriz_sparse_C(double matriz[],double datos[], int indColum[], int ptrRow[], int *cant){
    int noNulo = 0;
    int cont = 0;
    ptrRow[0] = 0;
    for(int i=0; i<N; i++){
        for(int j=0; j<N; j++){
            if(matriz[i*N+j] != 0){
                indColum[cont] = j;
                datos[cont] = matriz[i*N+j];
                noNulo++;
                cont++;
            }
        }
        ptrRow[i+1] = ptrRow[i]+noNulo;
        noNulo = 0;
    }
    //paso por referencia
    *cant = cont;
}