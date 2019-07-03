function input = createLSMT(P)

    pos = 1; 
    input = {};
    
    for i=0:+29:length(P)
        if(length(P) == i)
            break;
        end
        input{pos} = P(i+1:i+29,:);
        pos = pos + 1;
    end
end