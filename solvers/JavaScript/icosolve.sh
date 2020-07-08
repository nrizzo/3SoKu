#!/bin/bash

if [ "$#" -eq 12 ] # if called with 12 arguments
then # use them as capacities
	for i in {1..12}
	do
		input+="${!i},"
	done

	sed -i "s/icosolve(\[.*/icosolve([$input]);/" solver.js
fi

node solver.js
