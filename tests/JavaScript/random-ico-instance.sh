#!/bin/bash

if [ "$#" -ne 12 ]; then
    input=$(shuf -i 1-12 | tr "\n" ",")
else
    for i in {1..12}
    do
        input+="${!i},"
    done
fi

sed -i "s/icosolve(\[.*/icosolve([$input]);/" solver.js
