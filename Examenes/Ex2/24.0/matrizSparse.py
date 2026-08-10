import time
import numpy as np
import ctypes
from multiprocessing import Pool, cpu_count

#Valor de n para la matriz nxn
N = 2 ** 12

# item a) :
def matriz_sparse (matriz, datos, indColum, ptrRow):
    noNulo = 0 #contador para los elementos que no son cero
    ptrRow.append(0) #siempre se inicia con un cero
    #Desplazamiento secuencial
    for i in range(N):
        for j in range(N):
            if matriz[i*N+j] !=0 : #si el elemento es diferente a cero...
                indColum.append(j) #se guarda el valor de j en el arreglo de indice de columnas
                datos.append(matriz[i * N + j]) #se guarda el valor no nulo en el arreglo datos
                noNulo += 1 #incrementa el contador
        #Segun el algoritmo, se aumenta al valor anterior con la cantidad de valores no nulos que se encuentran en el siguiente grupo(fila)
        ptrRow.append(ptrRow[-1]+noNulo) 
        noNulo = 0 #Se reinicia el contador para el siguiente grupo (fila)

# item b) :
def reconstruir_sparse (datos, indColum, ptrRow):
    matriz = [0.0] * (N ** 2) #inicializar el arreglo con ceros
    for i in range (len(ptrRow)-1): 
        inicio = ptrRow[i] #valor inicial de la parte para analizar
        fin = ptrRow[i+1] #valor tope de la parte para analizar
        for j in range (inicio,fin):
            c = indColum[j] #se extrae la indice del arreglo de indices de la columna
            matriz[i*N + c] = datos[j] # se guarda de manera secuencial los valores no nulos
    return matriz #retorna matriz resultante

# item c) :
def matriz_vector (datos, indColum, ptrRow, v):
    resultado = [0.0] * N #inicializar el arreglo resultante
    for i in range(len(ptrRow)-1): #se coloca menos 1 para que no sobrepase el arreglo
        #Se sigue los mismo pasos para reconstruir la matriz sparce
        inicio = ptrRow[i]
        fin = ptrRow[i+1]
        for j in range(inicio, fin):
            c = indColum[j]
            #Aqui, seleccionamos el dato no nulo y lo multiplicamos por un valor del vector
            # el valor del vector depende de la posicion de la columna
            resultado[i] += datos[j] * v[c]
    return resultado #retorno del resultado en un arreglo

# item d) :

#funcion auxiliar para calcular el resultado de la suma de los productos de la multiplicacion de un grupo (fila) y un dato del vector
def calculo_parcial(datos, indColum, ptrRow, v, indFila):
    result = 0.0 #inicializar la suma
    inicio = ptrRow[indFila] #valor inicial para el rango de la fila
    fin = ptrRow[indFila + 1] if indFila + 1 < len(ptrRow) else len(indColum) #valor final para el rango de la fila
    for i in range(inicio, fin):
        c = indColum[i] # indice de columna del valor no nulo
        result += datos[i] * v[c] #multiplicacion del valor no nulo y un dato del vector que le corresponde
    return result #retorno de la suma

#FUNCION MULTIPROCESSING :
def matriz_vector_Multiprocessing(datos, indColum, ptrRow, v):
    p = Pool(processes=2) #creacion de un pool e indicar el numero de procesadores a utilizar
    #calculo de las tuplas (argumentos)
    args = [(datos, indColum, ptrRow, v, i) for i in range(len(ptrRow) - 1)]
    #se aplica la funcion auxiliar de forma paralela para cada tupla 
    resultado = p.starmap(calculo_parcial, args)
    return resultado #retorna resultado

# item e) :
def ctypes_matriz_vector_C():
    #ruta de la shared library
    lib = ctypes.CDLL('./matriz_vector.so')
    # tipo de los argumentos
    lib.matriz_vector_C.argtypes = [np.ctypeslib.ndpointer(dtype=np.float64), #puntero de valores double : datos[]
                                    np.ctypeslib.ndpointer(dtype=np.int32),   #puntero de valores int : intColumna[]
                                    np.ctypeslib.ndpointer(dtype=np.int32),   #puntero de valores int : ptrRow[]
                                    np.ctypeslib.ndpointer(dtype=np.float64), #puntero de de valores double : vector[]
                                    ctypes.c_int,                             #valor int : N
                                    np.ctypeslib.ndpointer(dtype=np.float64)] #puntero de valores double : resultado[]
    return lib.matriz_vector_C #retorno funcion configurada

#instancia de la funcion
matriz_vector_C = ctypes_matriz_vector_C()

#Funcion para crear matrices sparse
def matriz_random(n, cant_NoNulos):
    # Tamaño de la matriz
    total = n * n
    # indices aleatorios para elementos no nulos
    ind_NoNulos = np.random.choice(total, cant_NoNulos, replace=False)
    # inicializacion con ceros
    matriz = np.zeros(total)
    # valores randoms no nulos
    for i in ind_NoNulos:
        valor = np.random.randint(1, 10)  # Valor aleatorio entre 1 y 10 (double)
        matriz[i] = valor
    return matriz


#main
if __name__ == '__main__':
    #invocamos la matriz a traves de un arreglo ya que de esa manera se guarda en la memoria
    #matriz = [0, 0, 0, 1, 4, 8, 0, 0, 0, 10, 0, 5, 0, 0, 15, 0]

    #para f)
    matriz = matriz_random(N, 9)
    #invocamos arreglos
    datos = []
    colum = []
    ptrRow = []

    #obtener valores de datos, indice de columnas y punteros de filas
    matriz_sparse(matriz, datos, colum, ptrRow)
    #print("Datos: ")
    #print(datos)
    #print("Ind_Columnas: ")
    #print(colum)
    #print("Ptr_Fila: ")
    #print(ptrRow)

    #reconstruir la matriz
    #A = reconstruir_sparse(datos, colum, ptrRow)
    #print("Matriz sparse: ")
    #print(A)

    #Multiplicacion matriz_sparse x vector
    vector = [1,2,3,4]
    #B = matriz_vector(datos, colum, ptrRow, vector)
    #print("Resultado en Pyhton: ")
    #print(B)

    #Multiprocessing
    #ti_m = time.perf_counter()
    #D = matriz_vector_Multiprocessing(datos, colum, ptrRow, vector)
    #tf_m = time.perf_counter()
    #print("Resultado: ")
    #print(D)
    #print(f"Tiempo de ejecucion es {tf_m - ti_m} segundos")

    #Pasar los valores Numpy
    out_c = np.zeros(N, dtype=np.float64)
    data = np.array(datos, dtype=np.float64)
    col = np.array(colum, dtype=np.int32)
    row = np.array(ptrRow, dtype=np.int32)
    #v = np.array(vector, dtype=np.float64)
    #matriz_vector_C(data, col, row, v, N, out_c)
    #print("Resultado en C: ")
    #print(out_c)

    #para f):
    while len(vector) < N:
        vector += vector[:N - len(vector)]

    v = np.array(vector, dtype=np.float64)
    print("Resultado en Pyhton: ")
    for i in range(15):
        ti_py = time.perf_counter()
        B = matriz_vector(datos, colum, ptrRow, vector)
        tf_py = time.perf_counter()
        diferencia_py = (tf_py - ti_py) / 10**-6
        print(f" {diferencia_py: .2f}")
    
    print("\n")
    print("Resultado en Multiprocessing: ")
    for i in range(15):
        ti_mul = time.perf_counter()
        B = matriz_vector_Multiprocessing(datos, colum, ptrRow, vector)
        tf_mul = time.perf_counter()
        diferencia_mul = (tf_mul - ti_mul) / 10**-6
        print(f"{diferencia_mul: .2f}")

    print("\n")
    print("Resultado en C: ")
    for i in range(15):
        ti_c = time.perf_counter()
        B = matriz_vector_C(data, col, row, v, N, out_c)
        tf_c = time.perf_counter()
        diferencia_c = (tf_c - ti_c) / 10**-6
        print(f"{diferencia_c: .2f}")
    
