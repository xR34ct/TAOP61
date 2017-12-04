#!/bin/sh

for d in */; do
	EX="$(basename $d)"
	if [ $EX == ex10 ]
		then
			echo $EX
			echo "Standard"
			/usr/bin/glpsol -m standard.mod -d $EX/$EX.dat -o $EX/standard.txt --mipgap 0.01 > $EX/standard.o
			echo "Standard 100"
			/usr/bin/glpsol -m standard_100.mod -d $EX/$EX.dat -o $EX/standard_100.txt --mipgap 0.01 > $EX/standard_100.o
			echo "Inga Lager"
			/usr/bin/glpsol -m inga_lager.mod -d $EX/$EX.dat -o $EX/inga_lager.txt --mipgap 0.01 > $EX/inga_lager.o
			echo "Spill noll"
			/usr/bin/glpsol -m spill_noll.mod -d $EX/$EX.dat -o $EX/spill_noll.txt --mipgap 0.01 > $EX/spill_noll.o
			echo "Spill noll 100"
			/usr/bin/glpsol -m spill_noll_100.mod -d $EX/$EX.dat -o $EX/spill_noll_100.txt --mipgap 0.01 > $EX/spill_noll_100.o
		else
			echo $EX
			echo "Standard"
			/usr/bin/glpsol -m standard.mod -d $EX/$EX.dat -o $EX/standard.txt > $EX/standard.o
			echo "Standard 100"
			/usr/bin/glpsol -m standard_100.mod -d $EX/$EX.dat -o $EX/standard_100.txt > $EX/standard_100.o
			echo "Inga Lager"
			/usr/bin/glpsol -m inga_lager.mod -d $EX/$EX.dat -o $EX/inga_lager.txt > $EX/inga_lager.o
			echo "Spill noll"
			/usr/bin/glpsol -m spill_noll.mod -d $EX/$EX.dat -o $EX/spill_noll.txt > $EX/spill_noll.o
			echo "Spill noll 100"
			/usr/bin/glpsol -m spill_noll_100.mod -d $EX/$EX.dat -o $EX/spill_noll_100.txt > $EX/spill_noll_100.o
	fi
	echo " "
done
