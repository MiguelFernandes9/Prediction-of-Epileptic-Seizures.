function target = lables(t)
    classe = [[1 0 0 0] [0 1 0 0] [0 0 1 0] [0 0 0 1]];
    pos = 1;
    target = zeros(length(t),1);
    for i=1:length(t)
        if(classe(1:4) == t(i,:))
            target(pos,1) = 1;
        end
        if(classe(5:8) == t(i,:))
            target(pos,1) = 2;
        end
        if(classe(9:12) == t(i,:))
            target(pos,1) = 3;
        end
        if(classe(13:16) == t(i,:))
            target(pos,1) = 4;
        end
        pos = pos + 1; 
    end

end