import math
import multiprocessing

def calculate_dft_partial(args):
    """
    Calcula parte de la DFT dividida en componentes Real e Imaginaria mediante seno/coseno.
    """
    arr, start, end = args
    N = len(arr)
    real_part = []
    imag_part = []
    
    for k in range(start, end):
        sum_real = 0.0
        sum_imag = 0.0
        for n in range(N):
            angle = 2 * math.pi * k * n / N
            sum_real += arr[n] * math.cos(angle)
            sum_imag -= arr[n] * math.sin(angle)
        real_part.append(sum_real)
        imag_part.append(sum_imag)
        
    return real_part, imag_part

def DFT(arr, num_processes=None):
    """
    Calcula la DFT usando componentes trigonométricas separadas y multiprocessing.Pool.map.
    """
    if num_processes is None:
        num_processes = multiprocessing.cpu_count()

    N = len(arr)
    num_processes = min(num_processes, N)
    chunk_size = N // num_processes
    
    # Prepara la lista de argumentos para pool.map
    args_list = [
        (arr, i * chunk_size, (i + 1) * chunk_size if i < num_processes - 1 else N)
        for i in range(num_processes)
    ]

    with multiprocessing.Pool(processes=num_processes) as pool:
        # pool.map pasa cada tupla de args_list como un único argumento
        results = pool.map(calculate_dft_partial, args_list)

    final_real = []
    final_imag = []
    
    # Reconstruir la respuesta consolidando las partes
    for r_part, i_part in results:
        final_real.extend(r_part)
        final_imag.extend(i_part)

    return final_real, final_imag

if __name__ == "__main__":
    # El usuario ingresa datos como: 1 0.5 0 -0.5
    entrada = input("Ingresa los valores (separados por espacios): ")
    signal = [float(x) for x in entrada.split()]

    if not signal:
        print("Error: No ingresaste ningún valor.")
    else:
        real, imag = DFT(signal)
        
        print("\nResultado de la DFT trigonometrica:")
        for k in range(len(signal)):
            print(f"X[{k}] = {real[k]:.4f} + ({imag[k]:.4f})j")