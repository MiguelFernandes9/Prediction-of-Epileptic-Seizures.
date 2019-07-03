function [input,target_input] = class_balancing(P,Trg)
% a number of interictal points at most equal to the sum of the points of the other classes

ictal_class = find(Trg(:,3) == 1);
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

n_ictal = 0;
for i=1:length(beginning_ictal)
    n_ictal = n_ictal + end_ictal(i) - beginning_ictal(i) + 1; % +1 because we if end = 20 and start = 11, 20 -11 = 9, we need 10
end

n_elements = n_ictal*4;
target_input = zeros(n_elements,4);
input = zeros(n_elements,29);
pos = 1;

size = length(beginning_ictal);

for i=1:length(beginning_ictal)
    r = randi([1 size]);
    n_ele = end_ictal(r) - beginning_ictal(r) + 1;
    aux_ele = n_ele*3;
    %inter_ictal
    target_input(pos:pos + aux_ele -1,1) = 1;
    input(pos:pos + aux_ele -1,:) = P(beginning_ictal(r) - 601 - aux_ele :beginning_ictal(r) - 601 -1,:);
    %pre_ictal
    pos = pos + aux_ele;
    target_input(pos:pos + n_ele - 1,2) = 1;
    input(pos:pos + n_ele - 1,:) = P(beginning_ictal(r) -  n_ele:beginning_ictal(r) - 1,:);
    %ictal
    pos = pos + n_ele;
    target_input(pos:pos + n_ele - 1,3) = 1;
    input(pos:pos + n_ele - 1,:) = P(beginning_ictal(r):end_ictal(r),:);
    %pos_ictal
    pos = pos + n_ele;
    target_input(pos:pos + n_ele - 1,4) = 1;
    input(pos:pos + n_ele - 1,:) = P(end_ictal(r) + 1:end_ictal(r) + 1 + n_ele - 1,:);
    pos = pos + n_ele;
    size = size - 1;
    beginning_ictal(r) = [];
    end_ictal(r) = [];
end
end