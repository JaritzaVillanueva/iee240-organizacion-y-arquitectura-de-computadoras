#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

extern void asmCalcularDistancia (float *arrLong, float *arrLat, float *arrDist, int cant);
void calcularDistanciasC(float *arrLong, float *arrLat, float *arrDist, int cant);

int main (){
    float arrLong[5] = {45.78, 78.15, 48.13, 64.20, 36.46}, 
        arrLat[5] = {12.47, 73.98, 30.78, 69.06, 61.42}, *distAsm, *distC;
    int cant = 5;
    distAsm = malloc((cant)*sizeof(float));

    struct timespec ti, tf;
    double elapsedAsm, elapsedC;
    clock_gettime(CLOCK_REALTIME, &ti);
    asmCalcularDistancia(arrLong, arrLat, distAsm, cant);
    clock_gettime(CLOCK_REALTIME, &tf);
    elapsedAsm = (tf.tv_sec - ti.tv_sec) * 1e9 + (tf.tv_nsec - ti.tv_nsec);
    printf("El tiempo en nanosegundos que toma la funcion en ASM es %.2lf\n", elapsedAsm);

    distC= malloc((cant)*sizeof(float));

    clock_gettime(CLOCK_REALTIME, &ti);
    calcularDistanciasC(arrLong, arrLat, distC, cant);
    clock_gettime(CLOCK_REALTIME, &tf);
    elapsedC = (tf.tv_sec - ti.tv_sec) * 1e9 + (tf.tv_nsec - ti.tv_nsec);
    printf("El tiempo en nanosegundos que toma la funcion en C es %.2lf\n", elapsedC);

    printf("\nFUNCION EN ASM\n");
    for (int i=0;i<cant;i++){
        printf("%.4f\n",distAsm[i]);
    }
    printf("\nFUNCION EN C\n");
    for (int i=0;i<cant;i++){
        printf("%.4f\n",distC[i]);
    }
    printf("\n");
    double speedup = elapsedC/elapsedAsm;
    printf("SPEED UP: %.2f\n", speedup);
    //archRep = abrirArchivo ("reporte.txt","w");
    return 0;
}

/*
FILE *abrirArchivo (const char *nombArch, const char *modo){
    FILE *arch;
    arch = fopen(nombArch, modo);
    if (arch == NULL){
        printf("ERROR: No se pudo abrir el archivo %s\n",nombArch);
        exit(1);
    }
    return arch;
}
*/

void calcularDistanciasC(float *arrLong, float *arrLat, float *arrDist, int cant){
    for (int i=0;i<cant;i++){
        double dif1, dif2;
        dif1 = (double)(arrLong[0] - arrLong[i]);
        dif2 = (double)(arrLat[0] - arrLat[i]);
        arrDist[i] = (float) sqrt(pow(dif1,2)+ pow(dif2, 2));
        arrDist[i] *= 110;
    }
}
