param n_nod;
set nod := 1..n_nod;

#Hur fan sätter man bågar??!!

#param n_path;
#set path := 1..n_path;

param cf_c{nod,nod};

param b{i in nod,j in nod} := max(0,-cf_c[i,j]);

printf{i in nod,j in nod} "b[%2s] = %g, %g\n", i, j, b[i,j];


#Masterproblemet

#minimize master: q + sum{} bin[k] * 300;

#s.t. my_ass{k in snitt}:
#		q >=

solve;



end;
