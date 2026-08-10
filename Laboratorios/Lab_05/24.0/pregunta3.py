import time
from werkzeug.security import check_password_hash #INSTALE ESTA LIBERIA, tipee en su terminal: pip install Werkzeug
from multiprocessing import Pool, Process

"""
Esta es la contraseña que usted tiene que adivinar. Está encriptada para que no pueda saber cuál es la respuesta correcta a priori.
Lo que tiene que hacer es generar combinaciones de 3 letras y llamar a la función comparar_con_password_correcto(línea 20 de la plantilla)
"""
contrasena_correcta = 'pbkdf2:sha256:260000$rTY0haIFRzP8wDDk$57d9f180198cecb45120b772c1317b561f390d677f3f76e36e0d02ac269ad224'


# Arreglo con las letras del abecedario
abecedario = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
vocales = ['a', 'e', 'i', 'o', 'u']
"""
Función que sirve para comparar su palabra(cadena de 3 caracteres) con la contraseña correcta.
Entrada: Su cadena de 3 caracteres
Salida: True(verdadero) si es que coincide con la contraseña correcta, caso contrario retorna False(falso)
"""
def comparar_con_password_correcto(palabra):
	return check_password_hash(contrasena_correcta, palabra)

# Función de búsqueda atribuida a cada proceso
def buscar_contrasena(vocal_inicial):
    # La 1ra letra es vocal_inicial
    # La 2da letra siempre es vocal
    for v2 in vocales:
        # La 3ra letra puede ser vocal o consonante
        for l3 in abecedario:
            palabra = vocal_inicial + v2 + l3
            if comparar_con_password_correcto(palabra):
                return palabra
    return None


if __name__ == "__main__":
	# Crear 5 procesos (uno para cada vocal inicial)
    p = Pool(5)

	# Asignar a cada proceso una de las 5 vocales
    resultados = p.map(buscar_contrasena, vocales)

	# Extraer e imprimir la contraseña encontrada
    for res in resultados:
        if res is not None:
            print(f"\nLa contraseña correcta del WiFi es: {res}")
            break
