% choose indata file and discretization


%Made by Adnan Avdagic, Carl-Martin Johansson and Joel Runesson

fil='path16/path16.txt';
result='path16/result.txt';
scal=1;

disp(' *** Dynamic programming for PHEV *** ');
tic; % timing

% read data
fid=fopen(fil);
bb=textscan(fid,'%d',1); 
b=bb{1}; 
n=textscan(fid,'%d',1); 
nlinks=n{1}; % antalet vï¿½gavsnitt 
links = textscan(fid,'%f %f');
fclose(fid);
ltypes0 = links{1}; 
ldist0 = links{2};
fprintf('Path with %d links read from file %s.\n',nlinks,fil);

ldzero=sum(ldist0==0);
if (ldzero>0)
    fprintf('Omitting %d links with length zero.\n',ldzero);
    isnotzero=(find(ldist0~=0));
    ldist=ldist0(isnotzero); % lï¿½ngd pï¿½ vï¿½gavsnitt lj
    ltypes=ltypes0(isnotzero); % vï¿½gtyp t
    nlinks=length(ldist); % antalet vï¿½gavsnitt
else
    ldist=ldist0; % lï¿½ngd pï¿½ vï¿½gavsnitt lj
    ltypes=ltypes0; % vï¿½gtyp t
end

fprintf('Initial battery level %d.\n',b);

licost=dlmread('linkcost.txt');
libatt=dlmread('linkbatt.txt');

% setup data: c and a
c=zeros(nlinks,4);
a=zeros(nlinks,4);
for j=1:nlinks
    for k=1:4
        c(j,k)=round(ldist(j)*licost(ltypes(j),k)/scal);
        a(j,k)=round(ldist(j)*libatt(ltypes(j),k)/scal);
    end
end
b=round(b/scal);

% remove all zero parts
jix=find(sum(((a~=0)|(c~=0)),2)~=0);
a=a(jix,:);
c=c(jix,:);
ldist=ldist(jix);
[n,m]=size(a);
nlinks=n;
fprintf('%d links remains.\n',n);

% initiate zero solution
xopt = zeros(1,n);
z=0;
s=b;

% check if battery is enough for whole trip
dosolve=1;
cbig=sum(sum(c));
abig=sum(a(:,1));
abigscal=scal*abig;
fprintf('Driving electric all the way would need %d.\n',abigscal);
if (abig<=b)
    fprintf('Large battery. You can drive electric all the way!\n');
    xopt = ones(1,n);
    z=sum(c(:,1));
    s=b-abig;
    dosolve=0; % no need to solve
end

% stupid driver solution, all electric until battery empty
bel=0;
j0=0;
xstupid = zeros(1,n);
cstupid=0;
for j=1:nlinks
    bel=bel+a(j,1);
    if (bel<=b)
        xstupid(j)=1;
        cstupid=cstupid+c(j,1);
    else
        xstupid(j)=4;
        cstupid=cstupid+c(j,4);
    end
end

if (dosolve)
    %disp(' !!!!!!!!! Here you should find the optimal solution!!!!!!!');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % insert your code here!
    
    %Första "gammla" f-raden sätts till nollor
    f_old=zeros(1,b+1);
    
    %Vilket vägavsnitt ska funktionen starta på
    start=1;
    
    %Kallar på den rekursiva funktionen
    [xopt,z,s] = cost(start,j,b,k,c,a,f_old);
    
    %Räknar ut hur mycket laddning som finns kvar vid slutet av turen
    s = s - a(start,xopt(start));
    
     
    % no need to change below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

z=scal*z;
fid=fopen(result,'w');
disp('*************************');
fprintf(fid,'Path with %d links read from file %s.\n',nlinks,fil);
fprintf(fid,'Initial battery level %d.\n',b);
fprintf(fid,'Driving electric all the way would need %d.\n',abigscal);
fprintf(fid,'Stupid solution:');
fprintf(fid,'%d ',xstupid);
fprintf(fid,'Optimal solution:\n');
fprintf(fid,'%d ',xopt);

% statistics
use1=(xopt==1);use2=(xopt==2);use3=(xopt==3);use4=(xopt==4);
ant1=sum(use1);ant2=sum(use2);ant3=sum(use3);ant4=sum(use4);
len1=sum(use1.*ldist');len2=sum(use2.*ldist');len3=sum(use3.*ldist');len4=sum(use4.*ldist');

fprintf(fid,'\nNumber of segments per type: %d, %d, %d, %d\n',ant1,ant2,ant3,ant4);
fprintf(fid,'Total length per type: %.1f, %.1f, %.1f, %.1f\n',len1,len2,len3,len4);
fprintf(fid,'Cost for stupid driver: %d\n',cstupid);
fprintf(fid,'Optimal cost %d, final battery level: %d\n',z,s);

fclose(fid);
toc; % end timing