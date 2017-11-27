function [x_opt,malfunk,sk,future_k] = cost(j,j_max,b,k,c,a,f_old)
    
    
    langd = b+1;
    
    %Görs innan loopen
    s_rad = zeros(1,langd);
    table = zeros(k,langd);
    f = zeros(1,langd);
    x_hatt = zeros(1,langd);
    for i=0:langd
        s_rad(1,i+1) = i;
    end
    if j == 1
        for x=1:k
            for y=1:length(table)
                if s_rad(1,y) / a(j,x) < 1
                    table(x,y) = inf;
                else
                    table(x,y) = c(j,x);
                end
            end
        end
    else
        for x=1:k
            flytt = a(j,x);
            for y=1:length(table)
                if s_rad(1,y) / a(j,x) < 1
                    table(x,y) = inf;
                else
                    if j ~= 1 && table(x,y) ~= inf
                        table(x,y) = c(j,x) + f_old(1,y-flytt);
                    end
                end
            end
        end
    end
    for i=1:langd
        f(1,i) = min(table(:,i));
        [rad,col] = find(table(:,i) == f(1,i));
        x_hatt(1,i) = rad(1,1);
    end
        
    f_old = f;
    
    
    if j ~= j_max
        [x_opt,malfunk,sk,future_k] = cost(j+1,j_max,b,k,c,a,f_old);
        sk = sk - a(j,future_k);
        x_opt(1,j) = x_hatt(1,find(s_rad==sk));
        future_k = x_opt(1,j);
    end
    
    if j == 1
        sk = sk - a(j,future_k);
    end
        
    if j == j_max
        x_opt(1,j) = x_hatt(1,langd);
        future_k = x_opt(1,j);
        malfunk = f(1,langd);
        sk = s_rad(1,langd);
    end
    
    %disp(table);
    %disp(c);
    %disp(a);
    %disp(f);
    %disp(x_hatt);
    %disp(x_opt);
end

