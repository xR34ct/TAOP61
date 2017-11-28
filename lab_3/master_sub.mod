#Subproblemet

param n_nod;
set nod := 1..n_nod;

#Hur fan sätter man bågar??!!

param n_path;
set path := 1..n_path;

param dist{nod,nod};

param {}

param bin {nod,nod} binary; #1 då en ny båge används


var flow{nod,nod} >= 0; #Flödet mellan två noder, ska detta vara från i till j eller per båge k??



minimize sub:
	sum{i in nod, j in nod} (dist[i,j] * flow[i,j]) + sum{i in nod, j in nod} (bin[i,j] * 300);

s.t. tillgodose{i in nod}:
	sum{j in nod} (flow[j,i] - flow[i,j]) = demand[i];

s.t. capacity{k in path}:
	0 <= flow[k] <= 50 * bin[i,j];

#Masterproblemet



minimize master: q;

