#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int sumDig_c(int arr[],int num1,int num2,int inicio, int fin);
int busquedaBinaria (int arr[],int x,int inicio, int fin);
extern int sumDig_asm(int arr[],int num1,int num2,int inicio, int fin);

int main()
{   
    int n = 10;
    int arr[]={2, 4, 6, 8, 10 , 12, 14, 16, 18, 20};
    int num1, num2;
    printf("Ingresa dos numeros: ");
    scanf("%d %d", &num1, &num2);
    int result_c, result_asm;

    result_c = sumDig_c(arr, num1, num2, 0, n-1);
    result_asm = sumDig_asm(arr, num1, num2, 0, n-1);

    printf("%d", result_c);
    printf("%d", result_asm);

    return 0;
}

int sumDig_c(int arr[],int num1,int num2,int inicio, int fin)
{
    int pos1, pos2, mayor, menor, prod = 1, suma =0;
    pos1 = busquedaBinaria(arr, num1, inicio, fin);
    pos2 = busquedaBinaria(arr, num2, inicio, fin);
    
    if(pos1<pos2){
        mayor = pos2;
        menor = pos1;
    }
    else
    {
        mayor = pos1;
        menor = pos2;
    }

    for(int i=menor; i<=mayor; i++)
    {
        prod *= arr[i];
    }
    
    while(prod != 0){
        suma += prod % 10;
        prod /= 10;
    }
    return suma;
}

int busquedaBinaria (int arr[],int x,int inicio, int fin)
{
    while(inicio <= fin)
    {
        int medio = (fin+inicio)/2;

        if(arr[medio] == x)
        {
            return medio;
        }

        if(arr[medio] > x)
        {
            fin = medio - 1;
        }
        else
        {
            inicio = medio + 1;
        }
    }
    return -1;
}
