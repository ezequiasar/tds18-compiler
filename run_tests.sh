#!/bin/bash
#
# Recorre todos los archivos del directorio actual y los muestra
#
echo "-----Test de Lexico------"
echo "  ---------------------- "
echo "       Deben Pasar       "

for i in $(ls tests/lexico/should_pass -C1)
do
echo "Archivo Actual: " $i
./parser.out ./tests/lexico/should_pass/$i
echo ""
done
echo "---------------------------"
echo "---------------------------"


echo "-----Test de Lexico------"
echo "  ---------------------- "
echo "       Deben Fallar      "

for i in $(ls tests/lexico/should_fail -C1)
do
echo "Archivo Actual: " $i
./parser.out ./tests/lexico/should_fail/$i
echo ""
done
echo "---------------------------"
echo "---------------------------"


echo "-----Test de Sintaxis------"
echo "  ----------------------   "
echo "       Deben Pasar         "

for i in $(ls tests/sintaxis/should_pass -C1)
do
echo "Archivo Actual: " $i
./parser.out ./tests/sintaxis/should_pass/$i
echo ""
done
echo "---------------------------"
echo "---------------------------"

echo "-----Test de Sintaxis------"
echo "  ----------------------   "
echo "       Deben Fallar        "

for i in $(ls tests/sintaxis/should_fail -C1)
do
echo "Archivo Actual: " $i
./parser.out ./tests/sintaxis/should_fail/$i
echo ""
done
echo "---------------------------"
echo "---------------------------"
