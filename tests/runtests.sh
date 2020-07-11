#!/bin/bash
# Script to generate a batch of tests to measure the performance of the solvers
# on instances of IcoSoKu.
# ~ Nicola Rizzo

mainseed="snubdisphenoid"
get_seeded_perm()
{ # $mainseed + input parameter $1 define the seed
  seed="$1$mainseed"
  openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt </dev/zero 2>/dev/null
}

echo -n "Generating batch of tests... "
echo -n > batch
for i in {1..100}
do
	# shuf is used to generate pseudo-random IcoSoKu instances
	shuf -i1-12 \
		--random-source=<(get_seeded_perm $i) | \
		tr "\n" " " >> batch
	echo >> batch
done
echo "done."

# MiniZinc tests
echo -n "Testing MiniZinc model - Gecode... "
echo -n > times_minizinc_gecode
cd MiniZinc_gecode
while read line
do
	./icosolve.sh $line >> ../times_minizinc_gecode
done < ../batch
cd ..
echo "done."

echo -n "Testing MiniZinc model - Gecode, randomized search + constant restart... "
echo -n > times_minizinc_gecode_random_restart
cd MiniZinc_gecode_randomized
while read line
do
	./icosolve.sh $line >> ../times_minizinc_gecode_random_restart
done < ../batch
cd ..
echo "done."

echo -n "Testing MiniZinc model - Chuffed... "
echo -n > times_minizinc_chuffed
cd MiniZinc_chuffed
while read line
do
    ./icosolve.sh $line >> ../times_minizinc_chuffed
done < ../batch
cd ..
echo "done."

# ASP tests
echo -n "Testing ASP model... "
echo -n > times_asp
cd ASP
while read line
do
	./icosolve.sh $line >> ../times_asp
done < ../batch
cd ..
echo "done."

# JavaScript tests
echo -n "Testing Javascript model... "
echo -n > times_js
cd JavaScript
while read line
do
    ./icosolve.sh $line >> ../times_js
done < ../batch
cd ..
echo "done."
