function [target,NewP] = associate_class(t,P)

    count = 0;
    
    for i=0:+29:length(t)
        if(length(t) == i)
            break;
        end
        if(t(i+1) == t(i+29))
            count = count + 1;
        end
    end
    
    pos = 1;
    NewP = P;
    target = zeros(count,4);
    aux = 0;
    
    for i=0:+29:length(P)
        if(length(P) == i)
            break;
        end
        if(t(i+1) == t(i+29))
            target(pos,:) = t(i+1,:);
            pos = pos + 1;
        else
            if(aux == 0)
                NewP(i+1:i+29,:) = [];
                aux = aux + 1;
            else
                n = i - (29*aux);
                NewP(n+1:n+29,:) = [];
                aux = aux + 1;
            end
        end      
    end
    
        

end

function b_one = average(t)
    aux = zeros(4);
    for i=1:length(t)
        if(t(i,1) == 1)
            aux(1) = aux(1) + 1;
        end
        if(t(i,2) == 1)
            aux(2) = aux(2) + 1;
        end
        if(t(i,3) == 1)
            aux(3) = aux(3) + 1;
        end
        if(t(i,4) == 1)
            aux(4) = aux(4) + 1;
        end
    end
    aux2 = aux(1);
    index = 1;
    for i=2:length(aux)
        if(aux2 < aux(i))
            aux2 = aux(i);
            index = i;
        end
    end
    if(index == 1)
        b_one = [1 0 0 0];
    end
    if(index == 2)
        b_one = [0 1 0 0];
    end
    if(index == 3)
        b_one = [0 0 1 0];
    end
    if(index == 4)
        b_one = [0 0 0 1];
    end
end