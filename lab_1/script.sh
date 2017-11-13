#!/bin/sh

for d in */; do
	EX="$(basename $d)"
	if [ $EX == ex10 ]
		then
			echo "then"
			/usr/bin/glpsol -m standard.mod -d $EX/$EX.dat -o $EX/standard.txt --mipgap 0.01 > $EX/standard.o
			/usr/bin/glpsol -m inga_lager.mod -d $EX/$EX.dat -o $EX/inga_lager.txt --mipgap 0.01 > $EX/inga_lager.o
			/usr/bin/glpsol -m spill_noll.mod -d $EX/$EX.dat -o $EX/spill_noll.txt --mipgap 0.01 > $EX/spill_noll.o
			/usr/bin/glpsol -m spill_noll_100.mod -d $EX/$EX.dat -o $EX/spill_noll_100.txt --mipgap 0.01 > $EX/spill_noll_100.o
		else
			echo "else"
			/usr/bin/glpsol -m standard.mod -d $EX/$EX.dat -o $EX/standard.txt > $EX/standard.o
			/usr/bin/glpsol -m inga_lager.mod -d $EX/$EX.dat -o $EX/inga_lager.txt > $EX/inga_lager.o
			/usr/bin/glpsol -m spill_noll.mod -d $EX/$EX.dat -o $EX/spill_noll.txt > $EX/spill_noll.o
			/usr/bin/glpsol -m spill_noll_100.mod -d $EX/$EX.dat -o $EX/spill_noll_100.txt > $EX/spill_noll_100.o
	fi
done