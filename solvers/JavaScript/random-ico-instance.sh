#!/bin/bash
# Script that generates a random instance of IcoSoKu by modifying line
# containing "icosolve[...];" of file solver.js
# ~ Nicola Rizzo

input=$(shuf -i 1-12 | tr "\n" ",")

sed -i "s/icosolve(\[.*/icosolve([$input]);/" solver.js
