function [input,target] = class_balancingLSTM(P,T)

    ictal_class = find(T(:,3) == 1);
    pos = 1;
    beginning_ictal(pos) = ictal_class(1);
    
    for i=1:length(ictal_class)
        if(i == length(ictal_class))
            end_ictal(pos) = ictal_class(i);
            break;
        end
        if(ictal_class(i+1) - ictal_class(i) > 1)
            end_ictal(pos) = ictal_class(i);
            pos= pos +1; 
            beginning_ictal(pos) = ictal_class(i+1);
        end
    end
    
    for i=1:length(beginning_ictal)
        n_ictal = end_ictal(i) - beginning_ictal(i) + 1;% +1 because we if end = 20 and start = 11, 20 -11 = 9, we need 10
        aux = floor(n_ictal/29);
        aux_list(i) = aux;
    end
    
    
    size = length(aux_list);
    size2 = length(aux_list);
    pos = 1;
    
    for i=1:size2
        r = randi([1 size]);
        n_fig = aux_list(r);  
        aux_fig_n = n_fig * 3;
        %inter_ictal
        target(pos:pos + aux_fig_n -1,1) = 1;
        images{pos} =  makeIm(P,images,pos,pos + aux_fig_n -1,beginning_ictal(r) - 601 - aux_fig_n *29);
        %pre_ictal
        pos = pos + aux_fig_n;
        target(pos:pos + n_fig - 1,2) = 1;
        images{pos} = makeIm(P,images,pos,pos + n_fig -1,beginning_ictal(r) -  n_fig*29);
        %ictal
        pos = pos + n_fig;
        target(pos:pos + n_fig - 1,3) = 1;
        images{pos} = makeIm(P,images,pos,pos + n_fig -1,beginning_ictal(r));
        %pos_ictal
        pos = pos + n_fig;
        target(pos:pos + n_fig - 1,4) = 1;
        images{pos} = makeIm(P,images,pos,pos + n_fig -1,end_ictal(r) + 1);
        pos = pos + n_fig;
        size = size - 1;
        beginning_ictal(r) = [];
        end_ictal(r) = [];
        aux_list(r) = [];
    end
    
    
    
end


function images = makeIm(P,images,start,last,p)
    a = p;
    for i= start:last
        images(:,:,1,i) = P(a:a+29-1,:);
        a = a + 29;
    end
    
end