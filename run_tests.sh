#!/bin/bash
#
# Recorre todos los archivos del directorio actual y los muestra
#
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "-----Test de Lexico------"
echo "  ---------------------- "
echo "       Deben Pasar       "

for i in $(ls tests/lexico/should_pass -C1)
do
echo -e "${RED}Archivo Actual: " $i "${NC}"
printf "I ${RED}love${NC} Stack Overflow\n"
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
echo -e "${RED}Archivo Actual: " $i "${NC}"
./parser.out ./tests/lexico/should_fail/$i
echo ""
done
echo "---------------------------"
echo "---------------------------"


echo "-----Test de Sintaxis------"
echo "  ----------------------   "
echo "       Deben Pasar         "

for i in $(ls tests/sintax-semanth/should_pass -C1)
do
echo -e "${RED}Archivo Actual: " $i "${NC}"
./parser.out ./tests/sintax-semanth/should_pass/$i
echo ""
read -n 1 key
done
echo "---------------------------"
echo "---------------------------"

echo "-----Test de Sintaxis------"
echo "  ----------------------   "
echo "       Deben Fallar        "

for i in $(ls tests/sintax-semanth/should_fail -C1)
do
echo -e "${RED}Archivo Actual: " $i "${NC}"
./parser.out ./tests/sintax-semanth/should_fail/$i
echo ""
read -n 1 key
done
echo "---------------------------"
echo "---------------------------"
