#Subproblemet

set orig;
set dest;

param 

param use {orig,dest} binary; #1 då en ny båge används

var flow{orig,dest} >= 0; #Flödet mellan två noder

minimize cost:
	sum{i in orig, j in dest} cost[i,j] * flow[i,j] + sum{i in orig, j in dest} use[i,j] * ;

s.t. tillgodose_demand{i in orig, j in dest}:
	

#Masterproblemet