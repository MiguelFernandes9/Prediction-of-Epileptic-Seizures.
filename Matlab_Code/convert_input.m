function Target = convert_input(Trg)

ictal_class = find(Trg == 1);

pos = 1;
beginning_ictal(pos) = ictal_class(1);

for i=1:length(ictal_class)
    if(i == length(ictal_class))
        final_ictal(pos) = ictal_class(i);
        break;
    end
    if(ictal_class(i+1) - ictal_class(i) > 1)
        final_ictal(pos) = ictal_class(i);
        pos = pos + 1;
        beginning_ictal(pos) = ictal_class(i + 1);
    end
end

Target = zeros(length(Trg),4);
%Set up interictal
Target(:,1) = 1;

for i=1:length(beginning_ictal)
    %Pre Ictal
    Target(beginning_ictal(i)-601:beginning_ictal(i) - 1,2) = 1;
    Target(beginning_ictal(i)-601:beginning_ictal(i) - 1,1) = 0;
end

for i=1:length(final_ictal)
    %Pos Ictal
    Target(final_ictal(i) + 1:final_ictal(i) + 301,4) = 1;
    Target(final_ictal(i) + 1:final_ictal(i) + 301,1) = 0;
end

for i=1:length(beginning_ictal)
    %Ictal Class
    Target(beginning_ictal(i):final_ictal(i),3) = 1;
    Target(beginning_ictal(i):final_ictal(i),1) = 0;
end

end