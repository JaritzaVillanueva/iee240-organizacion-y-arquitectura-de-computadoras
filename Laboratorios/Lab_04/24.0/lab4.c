#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define k_size 8
#define length 2048

extern void applyConv_asm(float *x, float *h, float *y, int y_length, int k_length);
void fillArray(float *arr, int arr_length);
void printArray(float *arr, int arr_length);
void applyConv(float *x, float *h, float *y, int y_length, int k_length);

int main(){
	
	float x[length]; float y[length-k_size+1]; float y2[length-k_size+1];
	float k[k_size] = {1.0/8.0, 3/8.0, 6/8.0, 4/8.0, 4.0/8.0, 6/8.0, 3/8.0, 1/8.0};
	
	fillArray((float *)x, length);
	
	//printf("Arreglo x: \n");
	//printArray((float *)x, length); //imprime el arreglo x el cual tiene valores tipo float y su tamaño depende del valor de la constante length
	//printf("Kernel k: \n");
	//printArray((float *)k, k_size); //imprime el arreglo k el cual tiene valores tipo float y su tamaño depende del valor de la constante k_size

	// En C
	clock_t ti_c = clock();
	applyConv((float *)x, (float *)k, (float *)y, length-k_size+1, k_size);	
	clock_t tf_c = clock();
	double elapsed_time_c = ((double)(tf_c-ti_c))/CLOCKS_PER_SEC;
	//printf("Arreglo generado por función en C: \n");
	//printArray((float *)y, length-k_size+1); //imprime el arreglo y el cual tiene valores tipo float y su tamaño es el resultado de la operacion length-k_size+1

	//En Asm
	clock_t ti_asm = clock();
	applyConv_asm((float *)x, (float *)k, (float *)y2, length-k_size+1, k_size);	
	clock_t tf_asm = clock();
	double elapsed_time_asm = ((double)(tf_asm-ti_asm))/CLOCKS_PER_SEC;
	//printf("Arreglo generado por función en ASM: \n");
	//printArray((float *)y2, length-k_size+1);

	//Tiempo de Ejecucion:
	printf("Tiempo de ejecucion en C es:  %.8lf s\n", elapsed_time_c);
	printf("Tiempo de ejecucion en ASM es:  %.8lf s\n", elapsed_time_asm);

	//Speed Up : tiempo de referencia - C / tiempo de mejora - ASM
	double speedup = elapsed_time_c/elapsed_time_asm;
    printf("El speedUp es:  %lf\n", speedup);
	
	return 0;
}

void fillArray(float *arr, int size) {
    for (int i = 0; i < size; i++) {
        arr[i] = ((float)rand() / ((float)RAND_MAX / 100.0f + 1)); // max value inclusive of 100
    }
}

void printArray(float *arr, int size) {
    for (int i = 0; i < size; i++) {
		printf("%.2f ", arr[i]);
    }
	printf("\n");
}

void applyConv(float *x, float *k, float *y, int y_size, int k_length){
	
	for (int i=0; i < y_size ;i++){		
		float sum=0.0;		
		for (int j=0; j< k_length; j++){
			sum += x[i + j] * k[j];
		}
		y[i] = sum;
	}
}
