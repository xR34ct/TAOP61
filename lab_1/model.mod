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

param omv_RB := faktM * faktF;

var nburk_GR{i in BUTIK,j in GROSS} >= 0;
var nburk_BR{i in BUTIK,k in BRYGG} >= 0;
var nburk_LR{i in BUTIK,l in LAGER} >= 0;

var nburk_RM{m in MATR} >= 0;
var nburk_MT{m in MATR, n in FPACK} >= 0;
var nburk_TB{n in FPACK, k in BRYGG} >= 0;
var nburk_BG{k in BRYGG, j in GROSS} >= 0;
var nburk_GBu{j in GROSS, i in BUTIK} >= 0;
var nburk_BBu{k in BRYGG, i in BUTIK} >= 0;

var nnytt_matr{m in MATR} >= 0;


#Binära tal som anger om en grossist, ett bryggeri eller mellanlager används
var bin_G{j in GROSS} binary;
var bin_B{k in BRYGG} binary;
var bin_L{l in LAGER} binary;


minimize cost: 
#Rörliga kostnader till Returpack
sum{i in BUTIK, j in GROSS}
    (cost_G[i,j] * nburk_GR[i,j]) +
sum{i in BUTIK, k in BRYGG}
    (cost_B[i,k] * nburk_BR[i,k]) + 
sum{i in BUTIK, l in LAGER}
    (cost_L[i,l] * nburk_LR[i,l]) +

#Rörliga kostnader efter Returpack
    fullkost * (
sum{m in MATR} (distRM[m] * nburk_RM[m]) +
sum{m in MATR, n in FPACK} (distMT[m,n] * nburk_MT[m,n]) +
sum{n in FPACK, k in BRYGG} (distTB[n,k] * nburk_TB[n,k]) +
sum{j in GROSS, k in BRYGG} (distGB[j,k] * nburk_BG[k,j]) +
sum{i in BUTIK, j in GROSS} (distBuG[i,j] * nburk_GBu[j,i]) +
sum{i in BUTIK, k in BRYGG} (distBuB[i,k] * nburk_BBu[k,i])) +


#Fasta kostnader till Raturpack
sum{i in BUTIK, j in GROSS}
    (fkostG[j] * bin_G[j]) +
sum{i in BUTIK, k in BRYGG}
    (fkostB[k] * bin_B[k]) + 
sum{i in BUTIK, l in LAGER}
    (fkostL[l] * 10 * bin_L[l]) +

#Fasta kostnader efter Returpack
    tot_nytt_matr * matrkop;

s.t. pant_tot{i in BUTIK}:
    sum{j in GROSS} nburk_GR[i,j] +
    sum{k in BRYGG} nburk_BR[i,k] +
    sum{l in LAGER} nburk_LR[i,l] = pant[i];

s.t. sent_GR{j in GROSS}:
    bin_G[j] * gkaptom[j] - sum{i in BUTIK} nburk_GR[i,j] >= 0;
s.t. sent_BR{k in BRYGG}:
    bin_B[k] * bkaptom[k] - sum{i in BUTIK} nburk_BR[i,k] >= 0;
s.t. sent_LR{l in LAGER}:
    bin_L[l] * lkaptom[l] - sum{i in BUTIK} nburk_LR[i,l] >= 0;


s.t. tot_lager:
    0 <=sum{l in LAGER} bin_L[l] <= maxlager;
s.t. bought_matr:
    /*0 <=*/ sum{m in MATR} nnytt_matr[m]  = tot_nytt_matr;


s.t. sent_RM:
    sum{m in MATR} nburk_RM[m] - faktR * tot_pant = 0;

s.t. sent_MT{m in MATR}:
    sum{n in FPACK} nburk_MT[m,n] - (nburk_RM[m] + nnytt_matr[m]) * faktM = 0;

s.t. sent_TB{n in FPACK}:
    sum{k in BRYGG} nburk_TB[n,k] - (sum{m in MATR} nburk_MT[m,n] * faktF) = 0;

s.t. sent_BG{k in BRYGG}:
    sum{n in FPACK} nburk_TB[n,k] - sum{j in GROSS} nburk_BG[k,j] >= 0;

s.t. sent_GBu{j in GROSS}:
    sum{k in BRYGG} (nburk_BG[k,j] - sum{i in BUTIK} nburk_GBu[j,i]) >= 0;

s.t. sent_BBu{k in BRYGG}:
    sum{n in FPACK} nburk_TB[n,k] - sum{i in BUTIK} nburk_BBu[k,i] >= 0;

s.t. sent_to_BUTIK{i in BUTIK}:
    sum{j in GROSS} nburk_GBu[j,i] + sum{k in BRYGG} nburk_BBu[k,i] = behov[i];

solve;

display nburk_RM;
display nburk_MT;
display nburk_TB;
display nburk_BG;
display nburk_GBu;
display nburk_BBu;
display nnytt_matr;
#display 

display cost;

#Fixa cost


printf "%d butiker, %d grossister, %d bryggerier, %d lager.\n",nbutik,ngross,nbrygg,nlager;
printf "%d matr, %d fpack.\n",nmatr,nfpack;
printf "Totalt behov %d, spill %d.\n",totalbehov,totalnetto;

end;
