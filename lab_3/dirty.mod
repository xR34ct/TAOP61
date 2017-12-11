param n_bows;
set bows := 1..n_bows;

param n_cut;
set cuts := 1..n_cut; #Antal snitt gjorda

param cf_c{bows,cuts}; #Alla reducerade kostnader, från Vineopt
#param beta{bows,cuts};
param beta{i in bows,j in cuts} := max(0,-cf_c[i,j]); #Beta värden

param dc{cuts}; #Dual konstanten, tagen från Vineopt

param u{bows,cuts};

var bin{i in bows} binary;

var q >= 0;

minimize master:
    q + sum{i in bows} bin[i]*300;

s.t. nasty{j in cuts}:
    q >= dc[j] + sum{i in bows} (50 * u[i,j] * beta[i,j] ) - sum{i in bows} (50 * beta[i,j] * bin[i]);

s.t. dirty{j in cuts}:
	sum{i in bows} bin[i] <= 2;
solve;

display q;
display nasty;
display dirty;
display bin;
#display dc;
display master;


end;
