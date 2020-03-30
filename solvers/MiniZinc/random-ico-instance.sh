#!/bin/bash
# Script that generates a random instance of IcoSoKu, modifying the first
# line of input-ico.dzn
# ~ Nicola Rizzo

foo="cap = [$(shuf -i 1-12 | tr "\n" "," | cut -d',' -f1-12)];"
bar="$(tail -n +2 input-ico.dzn)"
echo -e "$foo\n$bar" > input-ico.dzn
