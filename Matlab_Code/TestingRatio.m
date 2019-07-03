function [InputTraining,TargetTraining,InputTesting,TargetTesting] = TestingRatio(P,t,trainR)

    Ictal = find(t(:,3) == 1);
    pos = 1;
    start_ictal(pos) = Ictal(1);
    for i=1:length(Ictal)-1
       if(Ictal(i+1) - Ictal(i) ~= 1)
           end_ictal(pos) = Ictal(i);
           pos = pos +1 ;
           start_ictal(pos) = Ictal(i+1);
       end
    end
    end_ictal(pos) = Ictal(length(Ictal));

    numberIctalTrain = floor(length(end_ictal) * (trainR / 100));
    n_cur_ictal = end_ictal(numberIctalTrain) - start_ictal(numberIctalTrain) + 1;

    %Quick Fix for Post-Ictal inclusion.
    if( t(end_ictal(numberIctalTrain) + n_cur_ictal + 1 ,4) == 1)
        n_cur_ictal = 300;
    end


    InputTraining = P ( 1 : end_ictal(numberIctalTrain) + n_cur_ictal, : );
    TargetTraining = t (  1 : end_ictal(numberIctalTrain) + n_cur_ictal, :);

    InputTesting = P ( end_ictal(numberIctalTrain) +1 + n_cur_ictal: end , :);
    TargetTesting = t( end_ictal(numberIctalTrain) +1 + n_cur_ictal: end, :);
    
end
