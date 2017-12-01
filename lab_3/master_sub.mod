param n_nod;
set nod := 1..n_nod;

#Hur fan sätter man bågar??!!

#param n_path;
#set path := 1..n_path;

param cf_c{nod,nod};

param beta{i in nod,j in nod} := max(0,-cf_c[i,j]);

param a{i in nod};

param f{i in nod,j in nod};

param cap{i in nod,j in nod};

var bin{i in nod,j in nod} binary;

var q >= 0;

#printf{i in nod,j in nod} "b[%g,%g] = %g\n", i, j, beta[i,j];
#printf{i in nod} "a[%g] = %g\n",i,a[i];
#printf{i in nod,j in nod} "f[%g,%g] = %g \n",i ,j, f[i,j];

#Masterproblemet

minimize master: q + sum{i in nod,j in nod} bin[i,j] * f[i,j];

s.t. nasty{l in P}:
		q >= sum{i in nod} b[i]a[i] - sum{i in nod,j in nod} cap[i,j]bin[i,j]beta[i,j];

s.t. dirty{l in R}:
		0 >= sum{i in nod} b[i]a_t[i] - sum{i in nod,j in nod} cap[i,j]bin[i,j]beta_t[i,j];

solve;



end;
