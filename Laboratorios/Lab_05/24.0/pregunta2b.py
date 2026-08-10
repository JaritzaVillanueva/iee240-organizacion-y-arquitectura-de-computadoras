#Pregunta 2b
import random
from multiprocessing import Pool

#funcion particion para 4 partes
def calcular_parte(n_muestras, x_min, x_max, y_min, y_max):
    cant_muestras_dentro = 0

    for _ in range(n_muestras):
        x = random.uniform(x_min, x_max)
        y = random.uniform(y_min, y_max)

        # Condición de distancia al centro (x^2 + y^2 <= 1)
        if (x ** 2) + (y ** 2) <= 1.0:
            cant_muestras_dentro += 1

    return cant_muestras_dentro

def Pi_paralelo(n, num_processes):
    p = Pool(num_processes)
    
    # Repartir el número de muestras entre los procesos
    muestras_por_proceso = n // num_processes

    # Delimitar exactamente las 4 áreas/cuadrantes del cuadrado
    args = [
        (muestras_por_proceso,  0.0,  1.0,  0.0,  1.0),  # Cuadrante I
        (muestras_por_proceso, -1.0,  0.0,  0.0,  1.0),  # Cuadrante II
        (muestras_por_proceso, -1.0,  0.0, -1.0,  0.0),  # Cuadrante III
        (muestras_por_proceso,  0.0,  1.0, -1.0,  0.0)   # Cuadrante IV
    ]
    
    #Se calcula la partes de trabajo
    aux = p.starmap(calcular_parte, args)
    # Se realiza la suma de ellas
    total_dentro = sum(aux)
    # Pi = (Muestras totales dentro del círculo / Muestras totales) * 4
    result = (total_dentro / n) * 4.0
    return result

if __name__ == "__main__":
    Pi_aprox = Pi_paralelo(10000000,4)
    print(f"El valor calculado de Pi (en paralelo) es: {Pi_aprox}")