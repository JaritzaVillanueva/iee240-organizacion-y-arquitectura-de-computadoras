ejecutable="./SpeedUp.out"

# Número de veces que se va a ejecutar el programa
veces=15

# Bucle para ejecutar el programa 15 veces
for ((i=1; i<=$veces; i++))
do
  echo "Ejecutando el programa - Iteración $i"
  $ejecutable
done
