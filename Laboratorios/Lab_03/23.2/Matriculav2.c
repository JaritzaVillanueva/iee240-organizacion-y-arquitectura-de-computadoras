#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define MAX_ALU 100
#define MAX_CUR 50

int buscarAlumno(int codA, int arrCodAlumno[], int nAlumnos);
int buscarCurso(int codC, int arrCodCurso[], int nCursos);

int main(){
    //datos del alumno
    int arrCodAlumno[MAX_ALU], nAlumnos = 0;
    double arrEscAlumno[MAX_ALU];

    //datos de curso
    int arrCodCurso[MAX_CUR], nCursos = 0;
    double arrCredCurso[MAX_CUR];

    //Totales a acumular
    double arrTotalCreditos[MAX_ALU], arrTotalApagar[MAX_ALU];

    //Inicializacion en arreglos de totales
    for(int i=0; i<MAX_ALU; i++){
        arrTotalCreditos[i]=0.0;
    }
    for(int i=0; i<MAX_ALU; i++){
        arrTotalApagar[i]=0.0;
    }

    
    //intenta abrir el archivo (r)
    FILE *arch = fopen("matriculas.txt", "r");
    FILE *report = fopen("reporte2.txt", "w");
    if(arch == NULL){
        printf("No se pudo abrir el archivo\n");
        exit(1);
    }
    if(report == NULL){
        printf("No se pudo abrir el archivo\n");
        exit(1);
    }

    //Leer y guardar alumnos
    int codAlu;
    double escAlum;
    while(1){
        fscanf(arch, "%d", &codAlu);
        if(feof(arch)) break;
        if(codAlu == 0){
            break;
        }
        fscanf(arch, "%lf", &escAlum);



        arrCodAlumno[nAlumnos] = codAlu;
        arrEscAlumno[nAlumnos] = escAlum;
        nAlumnos++;
    }

    //Leer y guardar cursos
    int codCur;
    double cred;
    while(1){
        fscanf(arch, "%d", &codCur);
        if(codCur == 0){
            break;
        }
        fscanf(arch, "%lf", &cred);



        arrCodCurso[nCursos] = codCur;
        arrCredCurso[nCursos] = cred;
        nCursos++;
    }

    //Leer matriculas y actualizar arreglos
    int codA, codC, posA, posC;
    while(1){
        fscanf(arch, "%d", &codA);
        if(codA == 0){
            break;
        }
        fscanf(arch, "%d", &codC);

        posA = buscarAlumno(codA, arrCodAlumno, nAlumnos);
        posC = buscarCurso(codC, arrCodCurso, nCursos);
        arrTotalCreditos[posA] += arrCredCurso[posC];
        arrTotalApagar[posA] += (arrEscAlumno[posA]*arrCredCurso[posC]);
    }
    fclose(arch);

    double elapsed_time2 = 0.0;
    //Imprimir reporte
    fprintf(report, "Alumno    Costo/Credito  Total Creditos  Total a Pagar\n");
    for(int i=0;i<nAlumnos;i++){
        fprintf(report, "%d    s/%.2lf         %.2lf         ", arrCodAlumno[i], arrEscAlumno[i], arrTotalCreditos[i]);
        clock_t ti_2 = clock();
        fprintf(report, "s/%.2lf\n", arrTotalApagar[i]);
        clock_t tf_2 = clock();
        elapsed_time2 += ((double)(tf_2-ti_2))/CLOCKS_PER_SEC;
    }
    printf("Tiempo de ejecucion: %.2lf microsegundos", elapsed_time2 * 1e6);
    fclose(report);
    return 0;
}

int buscarAlumno(int codA, int arrCodAlumno[], int nAlumnos){
    for(int i=0; i<nAlumnos; i++){
        if(arrCodAlumno[i] == codA){
            return i;
        }
    }
    return -1;
}

int buscarCurso(int codC, int arrCodCurso[], int nCursos){
    for(int i=0; i<nCursos; i++){
        if(arrCodCurso[i] == codC){
            return i;
        }
    }
    return -1;
}
