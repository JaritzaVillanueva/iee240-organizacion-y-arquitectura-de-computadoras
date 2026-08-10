import cmath
import math
import multiprocessing
from multiprocessing import Pool

def calculate_dft_partial(arr, start, end):
    """
    Calcula un rango [start, end) de la DFT usando exponenciales complejas.
    """
    N = len(arr)
    partial_result = []
    
    for k in range(start, end):
        s = 0.0 + 0.0j
        for n in range(N):
            # Fórmula de la DFT: X[k] = sum( x[n] * exp(-j * 2 * pi * k * n / N) )
            angle = -2 * math.pi * k * n / N
            s += arr[n] * cmath.exp(1j * angle)
        partial_result.append(s)
        
    return partial_result

def DFT(arr, num_processes=None):
    """
    Calcula la DFT paralelizando por rangos
    """
    if num_processes is None:
        num_processes = multiprocessing.cpu_count()

    N = len(arr)
    # Evitar crear más procesos que elementos en la señal
    num_processes = min(num_processes, N)
    
    chunk_size = N // num_processes
    
    # Prepara los argumentos como tuplas para starmap
    args_list = [
        (arr, i * chunk_size, (i + 1) * chunk_size if i < num_processes - 1 else N)
        for i in range(num_processes)
    ]

    with Pool(processes=num_processes) as pool:
        # starmap desempaqueta automáticamente los elementos de la tupla
        results = pool.starmap(calculate_dft_partial, args_list)

    # Aplanar la lista de resultados parciales
    final_result = [val for sublist in results for val in sublist]
    return final_result

if __name__ == "__main__":
    # El usuario ingresa datos como: 1 0.5 0 -0.5
    entrada = input("Ingresa los valores (separados por espacios): ")
    signal = [float(x) for x in entrada.split()]

    if not signal:
        print("Error: No ingresaste ningún valor.")
    else:
        result = DFT(signal)
        
        print("\n--- Resultado de la DFT ---")
        for k, val in enumerate(result):
            # val.real obtiene la parte real y val.imag la imaginaria
            print(f"X[{k}] = {val.real:.4f} + ({val.imag:.4f})j")
