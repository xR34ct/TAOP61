function f_old = cost(j,b,k,c,a)
    langd = b+1;
    
    %G�rs innan loopen
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
        f_old = cost(j-1,b,k,c,a);
        for x=1:k
            for y=1:length(table)
                if s_rad(1,y) / a(j,x) < 1
                    table(x,y) = inf;
                else
                    if j ~= 1 && table(x,y) ~= inf
                    %if table(x,y) ~= inf
                        %y >= a(j,x)
                        table(x,y) = c(j,x) + f_old(1,y);
                    %end
                    %table(x,y) = c(j,x);
                    %f_old = zeros(1,langd);
                %else
                   % m�lfunktionsv�rde + f_j-1(y - bivilkorsv�rde)
                    %if y < a(j,x) % + om fram�t, - om bak�t
                        %table(x,y) = inf;
                        %table(x,y) = c(j,x) + f_old(1,1);
                    %else
                        
                    %end
                    end
                end
            end
        end
    end
    for i=1:length(f)
        f(1,i) = min(table(:,i));
        [rad,col] = find(table(:,i) == f(1,i));
        x_hatt(1,i) = rad;
    end
        
        %r�kna ut w
    %disp(table);
    %disp(c);
    %disp(a);
    f_old = f;
    disp(x_hatt);
end

