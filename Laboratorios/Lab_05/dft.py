import math
from multiprocessing import Pool

def calculate_dft_partial(args):
    """
    Función auxiliar para calcular una parte de la DFT.
    
    Args:
        args: Tupla que contiene la siguiente información:
              - arr: La señal de entrada.
              - start: Índice de inicio para el cálculo de la parte de la DFT.
              - end: Índice de finalización para el cálculo de la parte de la DFT.
              - pi: El valor de pi para cálculos trigonométricos.
    
    Returns:
        Una lista que contiene la parte calculada de la DFT.
    """
    arr, start, end, pi = args
    result = [0.0] * len(arr)
    for k in range(start, end):
        for i in range(len(arr)):
            exp = -2 * pi * k * i / len(arr)
            result[k] += arr[i] * math.exp(exp)
    return result

def DFT(arr, pi, num_processes=None):
    """
    Calcula la Transformada Discreta de Fourier (DFT) utilizando multiprocessing.Pool.
    
    Args:
        arr: La señal de entrada para la cual se calculará la DFT.
        pi: El valor de pi para cálculos trigonométricos.
        num_processes: El número de procesos que se utilizarán para la paralelización. Si es None,
                       se utiliza el número de núcleos de la CPU.
                       
    Returns:
        Una lista que contiene el resultado de la DFT.
    """
    if num_processes is None:
        num_processes = multiprocessing.cpu_count()  # Obtener el número de núcleos de la CPU

    # Dividir el trabajo entre los procesos
    chunk_size = len(arr) // num_processes
    args_list = [(arr, i * chunk_size, (i + 1) * chunk_size if i < num_processes - 1 else len(arr), pi) for i in range(num_processes)]

    # Utilizar un Pool para paralelizar el cálculo de la DFT
    with Pool(processes=num_processes) as pool:
        results = pool.starmap(calculate_dft_partial, args_list)

    # Combinar resultados parciales
    final_result = [0.0] * len(arr)
    for result in results:
        for i in range(len(arr)):
            final_result[i] += result[i]

    return final_result

# Ejemplo de uso
arr = [0, 1, 0, 1]
pi = math.pi
dft_result = DFT(arr, pi)

# Imprimir el resultado de la DFT
print("Transformada Discreta de Fourier (DFT):", dft_result)D
