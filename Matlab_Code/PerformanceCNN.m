function [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,accuracy]=PerformanceCNN(out,T)


True_Positives = 0;
False_Negatives = 0;
True_Negatives = 0;
False_Positives = 0;

true_Preictal = 0;
total_Preictal = 0;
true_Ictal = 0;
total_Ictal = 0;
accuracy = 0; 

for i=1:length(out)
    if(out(i) == 1 && T(i) == 1)
        accuracy = accuracy + 1;
    end
    if(out(i) == 4 && T(i) == 4)
        accuracy = accuracy + 1;
    end
    if (out(i) == 3 && T(i) == 3)
        True_Positives = True_Positives + 1;
    elseif (out(i) == 2 && T(i) == 2)
        True_Positives = True_Positives + 1;
    elseif (out(i) ~=3 && T(i) ~= 3)
        True_Negatives = True_Negatives + 1;
    elseif (out(i) ~= 2 && T(i) ~= 2)
        True_Negatives = True_Negatives + 1;
    end
    if (out(i) == 3 && T(i) ~= 3)
        False_Positives = False_Positives + 1;
    elseif (out(i) == 2 && T(i) ~= 2)
        False_Positives = False_Positives + 1;
    elseif (out(i) ~= 3 && T(i) == 3) 
        False_Negatives = False_Negatives + 1;
    elseif (out(i) ~=2 && T(i) ==2)
        False_Negatives = False_Negatives + 1;
    end
    if T(i) == 1
        if out(i) == 2
            true_Preictal = true_Preictal + 1;
        end
        total_Preictal = total_Preictal + 1;
    end
    if T(i) == 3
        if out(i) == 3
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
accuracy = accuracy / length(out);
accuracy = accuracy * 100;
end