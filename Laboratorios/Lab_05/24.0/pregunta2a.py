#Pregunta 2a
import time
import random
from multiprocessing import Pool

#Funcion secuencial
def calcular_pi(n):
    cant_muestras_dentro = 0
    for i in range (n):
        x = random.uniform(-1, 1)
        y = random.uniform(-1, 1)

        # El punto está dentro del círculo de radio 1 si x^2 + y^2 <= 1
        if x**2 + y**2 <= 1.0:
            cant_muestras_dentro += 1
    Pi = (cant_muestras_dentro / n) * 4.0
    return Pi

if __name__ == "__main__":
    Pi_aprox = calcular_pi(10000000)
    print(f"El valor calculado de Pi es: {Pi_aprox}")