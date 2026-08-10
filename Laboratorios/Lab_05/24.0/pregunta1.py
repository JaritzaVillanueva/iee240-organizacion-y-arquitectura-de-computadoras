#Pregunta 1
import time
import math
from multiprocessing import Pool

# funcion serial
def polinomio(x):
    suma = 0
    for i in range (1, 10001):
        suma += i * (x ** i)
    return suma

#funcion de una parte del calculo del polinomio
def polinomio_parte(x, inicio, fin):
    suma = 0
    for i in range (inicio+1, fin+1):
        suma = suma + i * (x ** i)
    return suma

#funcion paralelizable
def polinomio_paralelo(x, num_processes):
    p = Pool(num_processes)
    #Dividir trabajo
    part_work =  10000 // num_processes
    args = [(x, i * part_work, (i + 1) * part_work if i < num_processes - 1 else 10000) 
    for i in range(num_processes)]
    #Se calcula la partes de trabajo
    aux = p.starmap(polinomio_parte, args)
    # Se realiza la suma de ellas
    result = sum(aux)
    return result

if __name__ == "__main__":
    # Ejecución Serial
    ti1 = time.perf_counter()
    resultado_serial = polinomio(2023)
    tf1 = time.perf_counter()
    time_serial = tf1-ti1

    # Ejecución en Paralelo
    ti2 = time.perf_counter()
    resultado_paralelo = polinomio_paralelo(2023, 4)
    tf2 = time.perf_counter()
    time_paralelo = tf2 - ti2

    #Calculo del SUP
    print(f"El speed Up es de {time_serial/time_paralelo }")
    #verificacion del programa
    assert resultado_serial == resultado_paralelo
    print("¡Verificación exitosa! Los resultados serial y paralelo coinciden.")

