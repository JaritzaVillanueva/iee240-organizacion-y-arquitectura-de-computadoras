# IEE240 - Organización y Arquitectura de Computadoras

Repositorio con los laboratorios, ejercicios, exámenes y tareas del curso **IEE240 - Organización y Arquitectura de Computadoras**. Aquí se consolidan implementaciones relacionadas con rendimiento, optimización y análisis de algoritmos.

## Tecnologías y Entorno

- **OS:** Ubuntu / WSL2
- **Lenguajes:** C, Assembly x86-64 y Python
- **Herramientas:** GCC, Python 3 y entorno de línea de comandos

## Estructura de Contenidos

- **Clase/**: Material de clase y ejemplos de optimización y rendimiento.
- **Laboratorios/**: Prácticas organizadas por laboratorio y tema.
  - **Lab_01/**: Introducción a ensamblador: operaciones aritméticas, comparación, condiciones, arreglos y funciones básicas.
  - **Lab_02/**: Programación en C y ensamblador para medición de tiempos de ejecución.
  - **Lab_03/**: Procesamiento de datos y comparación de rendimiento entre implementaciones en C.
  - **Lab_04/**: Convolución y optimización de código mediante integración entre C y ensamblador.
  - **Lab_05/**: Paralelización de cómputo y análisis de speedup.
- **Examenes/**: Ejercicios y soluciones de evaluaciones del curso.
- **Tarea/**: Ejercicios adicionales de práctica

## Método de Ejecución

### C
```bash
gcc archivo.c -o salida.o
./salida
```

### Python
```bash
python3 archivo.py
```

### Ensamblador (.asm)
#### Syscalls puras / etiqueta _start (LD)
```bash
nasm -f elf64 archivo.asm -o archivo.o
ld archivo.o -o salida.out
./salida.out
```
#### C + Ensamblador Híbrido (.c + .asm)
```bash
nasm -f elf64 rutina.asm -o rutina.o
gcc main.c rutina.o -o salida.out
./salida.out
```

## Honestidad Académica

El contenido de este repositorio se publica únicamente con fines educativos y de portafolio personal. Si eres estudiante del curso, se recomienda utilizar este material únicamente como referencia conceptual y no como sustituto del trabajo propio.
