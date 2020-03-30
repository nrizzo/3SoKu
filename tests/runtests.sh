#!/bin/bash
# Script to generate a batch of tests to measure the performance of the solvers
# on instances of IcoSoKu.
# ~ Nicola Rizzo

# seed
RANDOM="snubdisphenoid"

echo -n "Generating batch of tests... "
echo -n > batch
for i in {1..100}
do
    # shuf is used to generate pseudo-random IcoSoKu instances
    TEMP="$RANDOM"
    shuf -i1-12 \
	    --random-source=<(openssl enc -aes-256-ctr \
	    -pass pass:"$TEMP" -nosalt </dev/zero 2>/dev/null) | \
    tr "\n" " " >> batch
    echo >> batch
done
echo "done."

# MiniZinc tests
echo -n "Testing MiniZinc model (gecode)... "
echo -n > times_minizinc_gecode
cd MiniZinc
while read line
do
    input="cap = [$(echo $line | tr " " ",")];"
    sed -i "1s/.*/$input/" input-ico.dzn

    minizinc -v --solver gecode IcoSoKu.mzn input-ico.dzn 2>&1 | \
    grep Done | \
    cut -d' ' -f7 >> ../times_minizinc_gecode
done < ../batch
cd ..
echo "done."

echo -n "Testing MiniZinc model (gecode - randomized + constant restart)... "
echo -n > times_minizinc_gecode_random_restart
cd MiniZinc
while read line
do
    input="cap = [$(echo $line | tr " " ",")];"
    sed -i "1s/.*/$input/" input-ico.dzn

    minizinc -v -r snubdisphenoid --solver gecode \
        IcoSoKu-random.mzn input-ico.dzn 2>&1 | \
    grep Done | \
    cut -d' ' -f7 >> ../times_minizinc_gecode_random_restart
done < ../batch
cd ..
echo "done."

echo -n "Testing MiniZinc model (chuffed)... "
echo -n > times_minizinc_chuffed
cd Minizinc
while read line
do
    input="cap = [$(echo $line | tr " " ",")];"
    sed -i "1s/.*/$input/" input-ico.dzn

    minizinc -v --solver chuffed IcoSoKu.mzn input-ico.dzn 2>&1 | \
    grep Done | \
    cut -d' ' -f7 >> ../times_minizinc_chuffed
done < ../batch
cd ..
echo "done."

# ASP tests
echo -n "Testing ASP model... "
echo -n > times_asp
cd ASP
while read line
do
    ./random-ico-instance.sh $line
    ./icosolve.sh 2>&1 | \
      grep "CPU Time" | cut -d ' ' -f8 | tr -d 's' >> ../times_asp
done < ../batch
cd ..
echo "done."

# JavaScript tests
echo -n "Testing Javascript model... "
echo -n > times_js
cd JavaScript
while read line
do
    # the naming of the vertices of the icosahedron is different!
    array=($line)
    input="${array[0]} ${array[2]} ${array[3]} ${array[4]} ${array[5]} ${array[1]} ${array[10]} ${array[9]} ${array[8]} ${array[7]} ${array[6]} ${array[11]}"
    ./random-ico-instance.sh $input
    ./solver.sh >> ../times_js
done < ../batch
cd ..
echo "done."
