function images = create_images(P)

    pos = 1; 
    images = zeros(29,29,1,length(P)/29);
    
    for i=0:+29:length(P)
        if(length(P) == i)
            break;
        end
        images(:,:,1,pos) = P(i+1:i+29,:);
        pos = pos + 1;
    end

end
