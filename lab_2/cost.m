function [x_opt,malfunk,sk,future_k] = cost(j,j_max,b,k,c,a,f_old)
    %Made by Adnan Avdagic, Carl-Martin Johansson and Joel Runesson
    
    %S�tter l�ngde
    langd = b+1;
    
    %Skapar matriser
    s_rad = zeros(1,langd);
    table = zeros(k,langd);
    f = zeros(1,langd);
    x_hatt = zeros(1,langd);
    
    %Skapar s_rad
    for i=1:langd
        s_rad(1,i) = i-1;
    end
    
    %R�knar ut tabellv�rden
    for x=1:k
        flytt = a(j,x);
        for y=1:langd
            if s_rad(1,y) / a(j,x) < 1
                table(x,y) = inf;
            else
                table(x,y) = c(j,x) + f_old(1,y-flytt);
            end
        end
    end
    
    %R�knar ut f-raden samt circumflex(x)-raden
    for i=1:langd
        f(1,i) = min(table(:,i));
        [rad,col] = find(table(:,i) == f(1,i));
        x_hatt(1,i) = rad(1,1);
    end
    
    %S�tter gammla f-raden till den nuvarande f-rad
    f_old = f;
    
    %V�ljer x-optimum, m.h.a sk
    if j ~= j_max
        [x_opt,malfunk,sk,future_k] = cost(j+1,j_max,b,k,c,a,f_old);
        q = future_k;
        while sk - a(j,q) < 0
           q = q + 1;
        end
        future_k = q;
        sk = sk - a(j,future_k);
        choose = find(s_rad==sk);
        x_opt(1,j+1) = q;
        x_opt(1,j) = x_hatt(1,choose(1,1));
        future_k = x_opt(1,j);
    end
    
    %Sista tabl�n v�ljer alltid det h�graste v�rdet
    if j == j_max
        x_opt(1,j) = x_hatt(1,langd);
        future_k = x_opt(1,j);
        malfunk = f(1,langd);
        sk = s_rad(1,langd);
    end
    
    %fprintf('Avsnitt %d \n batteri kvar %d \n Kostnad %d \n Valt framf�rings�tt %d \n \n',j,sk,a(j,future_k),x_opt(1,j));
    %disp(table);
    %disp(c);
    %disp(a);
    %disp(f);
    %disp(x_hatt);
    %disp(x_opt);
end

