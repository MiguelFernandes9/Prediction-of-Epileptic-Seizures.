function [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,accuracy]=Performance(outSim,T)

True_Positives = 0;
False_Negatives = 0;
True_Negatives = 0;
False_Positives = 0;

true_Preictal = 0;
total_Preictal = 0;
true_Ictal = 0;
total_Ictal = 0;
accuracy = 0; 

for i=1:length(outSim)
    if outSim(1,i) > outSim(2,i) && outSim(1,i) > outSim(3,i) && outSim(1,i) > outSim(4,i) && T(1,i) == 1
        accuracy = accuracy + 1;
    end
    if outSim(4,i) > outSim(1,i) && outSim(4,i) > outSim(3,i) && outSim(4,i) > outSim(2,i) && T(4,i) == 1
        accuracy = accuracy + 1;
    end
    if outSim(3,i) > outSim(1,i) && outSim(3,i) > outSim(2,i) && outSim(3,i) > outSim(4,i) && T(3,i) == 1
        True_Positives = True_Positives + 1;
    elseif outSim(2,i) > outSim(1,i) && outSim(2,i) > outSim(3,i) && outSim(2,i) > outSim(4,i) && T(2,i) == 1
        True_Positives = True_Positives + 1;
    elseif (outSim(3,i) < outSim(1,i) || outSim(3,i) < outSim(2, i) || outSim(3,i) < outSim(4,i)) && T(3,i) ~= 1
        True_Negatives = True_Negatives + 1;
    elseif (outSim(2,i) < outSim(1,i) || outSim(2,i) < outSim(3, i) || outSim(2,i) < outSim(4,i)) && T(2,i) ~= 1
        True_Negatives = True_Negatives + 1;
    end
    if outSim(3,i) > outSim(1,i) && outSim(3,i) > outSim(2,i) && outSim(3,i) > outSim(4,i) && T(3,i) ~= 1
        False_Positives = False_Positives + 1;
    elseif outSim(2,i) > outSim(1,i) && outSim(2,i) > outSim(3,i) && outSim(2,i) > outSim(4,i) && T(2,i) ~= 1
        False_Positives = False_Positives + 1;
    elseif (outSim(3,i) < outSim(1,i) && outSim(3,i) < outSim(2,i) && outSim(3,i) < outSim(4,i)) && T(3,i) ==1
        False_Negatives = False_Negatives + 1;
    elseif (outSim(2,i) < outSim(1,i) && outSim(2,i) < outSim(3,i) && outSim(2,i) < outSim(4,i)) && T(2,i) ==1
        False_Negatives = False_Negatives + 1;
    end
    if T(2, i) == 1
        if outSim(2,i) > outSim(1,i) && outSim(2,i) > outSim(3, i) && outSim(2,i) > outSim(4, i)
            true_Preictal = true_Preictal + 1;
        end
        total_Preictal = total_Preictal + 1;
    end
    if T(3, i) == 1
        if outSim(3,i) > outSim(1,i) && outSim(3,i) > outSim(2, i) && outSim(3,i) > outSim(4, i)
            true_Ictal = true_Ictal + 1;
        end
        total_Ictal = total_Ictal + 1;
    end
end

Preictal_accuracy = (true_Preictal / total_Preictal) * 100;
Ictal_accuracy = (true_Ictal / total_Ictal) * 100;
Sensivity = True_Positives / ( True_Positives + False_Negatives );
Specificity = True_Negatives / (True_Negatives + False_Positives );
accuracy = accuracy + True_Positives;
accuracy = accuracy / length(outSim);
accuracy = accuracy * 100;