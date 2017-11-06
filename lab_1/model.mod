/*
Made by Adnan Avdagic, Carl-Martin Johansson and Joel Runesson
*/

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

#Antal som kan skickas från varje butik
param pant{i in BUTIK} := behov[i] - netto[i];
#Antal förpackningar som kommer fram till Returpack
param tot_pant := totalbehov - totalnetto;

#Kostnaden att skicka en enhet via en grossist
param cost_G{i in BUTIK, j in GROSS} :=
    tomkost * (distBuG[i,j] + distGR[j]);
#Kostnaden att skicka en enhet via ett bryggeri
param cost_B{i in BUTIK, k in BRYGG} :=
    tomkost * (distBuB[i,k] + distBR[k]);
#Kostnaden att skicka en enhet via ett mellanlager
param cost_L{i in BUTIK, l in LAGER} :=
    lagkost * (distBuL[i,l] + distLR[l]);

#Antal enhter som behöver köpas in per butik pga spill
param nytt_matr{i in BUTIK} :=
    behov[i] / (faktM * faktF) - pant[i] * faktR;

param tot_nytt_matr :=
    totalbehov / (faktM * faktF) - tot_pant * faktR;

#Kostnaden att skicka en enhet från Returpack till en butik via bryggerier & grossister
param cost_BGBu{i in BUTIK, m in MATR, n in FPACK, k in BRYGG, j in GROSS} :=
    fullkost * (distRM[m]/(faktM * faktF) + distMT[m,n] / faktF + distTB[n,k] + distGB[j,k] + distBuG[i,j]);

#Kostnaden att skicka en enhet från Returpack till en butik via bryggerier
param cost_BBu{i in BUTIK, m in MATR, n in FPACK, k in BRYGG} :=
    fullkost * (distRM[m]/(faktM * faktF) + distMT[m,n] / faktF + distTB[n,k] + distBuB[i,k]);

#Kostnaden att skicka ett material från materialtillverkaren till en butik via bryggerier & grossister
param cost_nytt_matr_BGBu{i in BUTIK, m in MATR, n in FPACK, k in BRYGG, j in GROSS} :=
    fullkost * (distMT[m,n] / faktF + distTB[n,k] + distGB[j,k] + distBuG[i,j]) + matrkop;

#Kostnaden att skicka ett material från materialtillverkaren till en butik via bryggerier
param cost_nytt_matr_BBu{i in BUTIK, m in MATR, n in FPACK, k in BRYGG} :=
    fullkost * (distMT[m,n] / faktF + distTB[n,k] + distBuB[i,k]) + matrkop;

param omv_RB := faktM * faktF;

var nburk_G{i in BUTIK,j in GROSS} >= 0;
var nburk_B{i in BUTIK,k in BRYGG} >= 0;
var nburk_L{i in BUTIK,l in LAGER} >= 0;

var nburk_BGBu{i in BUTIK, m in MATR, n in FPACK, k in BRYGG, j in GROSS} >= 0;
var nburk_BBu{i in BUTIK, m in MATR, n in FPACK, k in BRYGG} >= 0;
var nnytt_matr_BGBu{i in BUTIK, m in MATR, n in FPACK, k in BRYGG, j in GROSS} >= 0;
var nnytt_matr_BBu{i in BUTIK, m in MATR, n in FPACK, k in BRYGG} >= 0;



#Binära tal som anger om en grossist, ett bryggeri eller mellanlager används
var bin_G{j in GROSS} binary;
var bin_B{k in BRYGG} binary;
var bin_L{l in LAGER} binary;


minimize cost: sum{i in BUTIK, j in GROSS}
    (fkostG[j] * bin_G[j] + cost_G[i,j] * nburk_G[i,j]) +
sum{i in BUTIK, k in BRYGG}
    (fkostB[k] * bin_B[k] + cost_B[i,k] * nburk_B[i,k]) +
sum{i in BUTIK, l in LAGER}
    (fkostL[l] * 10 * bin_L[l] + cost_L[i,l] * nburk_L[i,l])
    +
sum{i in BUTIK, m in MATR, n in FPACK, k in BRYGG, j in GROSS}
    (cost_BGBu[i,m,n,k,j] * nburk_BGBu[i,m,n,k,j] + cost_nytt_matr_BGBu[i,m,n,k,j] * nnytt_matr_BGBu[i,m,n,k,j]) * omv_RB
    +
sum{i in BUTIK, m in MATR, n in FPACK, k in BRYGG}
    (cost_BBu[i,m,n,k] * nburk_BBu[i,m,n,k] + cost_nytt_matr_BBu[i,m,n,k] * nnytt_matr_BBu[i,m,n,k]) * omv_RB;
#    +
#sum{i in BUTIK, m in MATR, n in FPACK, k in BRYGG, j in GROSS}
#    (cost_nytt_matr_BGBu[i,m,n,k,j] * nnytt_matr_BGBu[i,m,n,k,j] * faktM * faktF)
#    +
#sum{i in BUTIK, m in MATR, n in FPACK, k in BRYGG}
#    (cost_nytt_matr_BBu[i,m,n,k] * nnytt_matr_BBu[i,m,n,k] * faktM * faktF);

s.t. pant_tot{i in BUTIK}:
    sum{j in GROSS} nburk_G[i,j] +
    sum{k in BRYGG} nburk_B[i,k] +
    sum{l in LAGER} nburk_L[i,l] = pant[i];
s.t. sent_G{j in GROSS}:
    bin_G[j] * gkaptom[j] - sum{i in BUTIK} nburk_G[i,j] >= 0;
s.t. sent_B{k in BRYGG}:
    bin_B[k] * bkaptom[k] - sum{i in BUTIK} nburk_B[i,k] >= 0;
s.t. sent_L{l in LAGER}:
    bin_L[l] * lkaptom[l] - sum{i in BUTIK} nburk_L[i,l] >= 0;
s.t. sent_R{i in BUTIK}:
    sum{/*i in BUTIK,*/m in MATR,n in FPACK, k in BRYGG, j in GROSS} nburk_BGBu[i,m,n,k,j] +
    sum{/*i in BUTIK,*/m in MATR,n in FPACK, k in BRYGG} nburk_BBu[i,m,n,k] = faktR * /*tot_pant;*/pant[i];
#s.t. tot_behov:
#    omv_RB * (sum{i in BUTIK,m in MATR,n in FPACK,k in BRYGG,j in GROSS} (nburk_BGBu[i,m,n,k,j] + nnytt_matr_BGBu[i,m,n,k,j]) + sum{i in BUTIK,m in MATR,n in FPACK,k in BRYGG} (nburk_BBu[i,m,n,k] + nnytt_matr_BBu[i,m,n,k])) <= totalbehov;
s.t. behov_Bu{i in BUTIK}:
     omv_RB * (sum{m in MATR,n in FPACK,k in BRYGG,j in GROSS} (nburk_BGBu[i,m,n,k,j] + nnytt_matr_BGBu[i,m,n,k,j]) + sum{m in MATR,n in FPACK,k in BRYGG} (nburk_BBu[i,m,n,k] + nnytt_matr_BBu[i,m,n,k])) <= behov[i];
s.t. tot_lager:
    sum{l in LAGER} bin_L[l] <= maxlager;
s.t. bought_matr{i in BUTIK}:
    sum{/*i in BUTIK,*/m in MATR,n in FPACK,k in BRYGG,j in GROSS} nnytt_matr_BGBu[i,m,n,k,j] + sum{/*i in BUTIK,*/m in MATR,n in FPACK,k in BRYGG} nnytt_matr_BBu[i,m,n,k] = /*tot_nytt_matr;*/nytt_matr[i];

#Fixa s.t. behov_Bu och s.t. bought_matr

printf "%d butiker, %d grossister, %d bryggerier, %d lager.\n",nbutik,ngross,nbrygg,nlager;
printf "%d matr, %d fpack.\n",nmatr,nfpack;
printf "Totalt behov %d, spill %d.\n",totalbehov,totalnetto;

end;
