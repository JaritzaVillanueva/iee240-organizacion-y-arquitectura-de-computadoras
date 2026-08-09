def calculate_dft_partial(args):
    """
    Función auxiliar para calcular una parte de la DFT.
    """
    arr, start, end, pi = args
    result_real = [0.0] * len(arr)
    result_imag = [0.0] * len(arr)
    for k in range(start, end):
        for n in range(len(arr)):
            angle = 2 * math.pi * k * n / len(arr)
            result_real[k] += arr[n] * math.cos(angle)
            result_imag[k] -= arr[n] * math.sin(angle)
    return result_real, result_imag

def DFT(arr):
    """
    Calcula la Transformada Discreta de Fourier (DFT) utilizando multiprocessing.
    """
    num_processes = multiprocessing.cpu_count()

    # Dividir el trabajo entre los procesos
    chunk_size = len(arr) // num_processes
    args_list = [(arr, i * chunk_size, (i + 1) * chunk_size if i < num_processes - 1 else len(arr), math.pi) for i in range(num_processes)]

    # Utilizar un Pool para paralelizar el cálculo de la DFT
    with multiprocessing.Pool(processes=num_processes) as pool:
        results = pool.map(calculate_dft_partial, args_list)

    # Combinar resultados parciales
    final_result_real = [0.0] * len(arr)
    final_result_imag = [0.0] * len(arr)
    for result_real, result_imag in results:
        for i in range(len(arr)):
            final_result_real[i] += result_real[i]
            final_result_imag[i] += result_imag[i]

    return final_result_real, final_result_imag
