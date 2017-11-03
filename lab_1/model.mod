param nbutik;
param ngross;
param nbrygg;
param nmatr;
param nfpack;
param nlager;

set BUTIK := 1..nbutik;
set GROSS := 1..ngross;
set BRYGG := 1..nbrygg;
set MATR := 1..nmatr;
set FPACK := 1..nfpack;
set LAGER := 1..nlager;

param behov{BUTIK};
param netto{BUTIK};
param gkaptom{GROSS};
param gkapfull{GROSS};
param bkaptom{BRYGG};
param bkapfull{BRYGG};
param lkaptom{LAGER};

param totalbehov := sum{i in BUTIK} behov[i];
param totalnetto := sum{i in BUTIK} netto[i];

param distBuG{BUTIK,GROSS};
param distBuB{BUTIK,BRYGG};
param distGB{GROSS,BRYGG};
param distGR{GROSS};
param distBR{BRYGG};
param distTB{FPACK,BRYGG};
param distRM{MATR};
param distMT{MATR,FPACK};

param distBuL{BUTIK,LAGER};
param distLR{LAGER};

param tomkost;
param fullkost;
param lagkost;
param bristkost;
param matrkop;
param maxlager;

param fkostG{GROSS};
param fkostB{BRYGG};
param fkostL{LAGER};

param faktR;
param faktM;
param faktF;

var nburk_G{i in BUTIK,j in GROSS} >= 0;
var nburk_B{i in BUTIK,k in BRYGG} >= 0;
var nburk_L{i in BUTIK,l in LAGER} >= 0;

param pant{i in BUTIK} := behov[i] - netto[i];

param cost_G{i in BUTIK, j in GROSS} :=
tomkost * (distBuG[i,j] + distGR[j]);
param cost_B{i in BUTIK, k in BRYGG} :=
tomkost * (distBuB[i,k] + distBR[k]);
param cost_L{i in BUTIK, l in LAGER} :=
lagkost * (distBuL[i,l] + distLR[l]);


#param send_BGBu{i in BUTIK, m in MATR, n in FPACK, k in BRYGG, j in GROSS} :=
#distRM[m] pant[i] +

#param send_BBu

var bin_G{j in GROSS} binary;
var bin_B{k in BRYGG} binary;
var bin_L{l in LAGER} binary;

minimize cost: sum{i in BUTIK, j in GROSS}
   (fkostG[j] * bin_G[j] + cost_G[i,j] * nburk_G[i,j]) +
sum{i in BUTIK, k in BRYGG}
   (fkostB[k] * bin_B[k] + cost_B[i,k] * nburk_B[i,k]) +
sum{i in BUTIK, l in LAGER}
   (fkostL[l] * 10 * bin_L[l] + cost_L[i,l] * nburk_L[i,l]);

s.t. pant_tot{i in BUTIK}:
sum{j in GROSS} nburk_G[i,j] +
sum{k in BRYGG} nburk_B[i,k] +
sum{l in LAGER} nburk_L[i,l] = pant[i];
s.t. sent_G{j in GROSS}:
sum{i in BUTIK} nburk_G[i,j] <= gkaptom[j] * bin_G[j];
s.t. sent_B{k in BRYGG}:
sum{i in BUTIK} nburk_B[i,k] <= bkaptom[k] * bin_B[k];
s.t. sent_L{l in LAGER}:
sum{i in BUTIK} nburk_L[i,l] <= lkaptom[l] * bin_L[l];
#s.t behov_Bu{i in BUTIK}:



printf "%d butiker, %d grossister, %d bryggerier, %d lager.\n",nbutik,ngross,nbrygg,nlager;
printf "%d matr, %d fpack.\n",nmatr,nfpack;
printf "Totalt behov %d, spill %d.\n",totalbehov,totalnetto;

end;
