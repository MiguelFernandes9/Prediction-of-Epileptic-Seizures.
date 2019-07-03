

function main(balance,filename,trainRatio,testRatio,network,BnetworkType,trainFuntion)

        
     if(trainFuntion == 1)
         trainFuntion = "traincgp";
     elseif(trainFuntion == 2)
         trainFuntion = "trainscg";
     elseif(trainFuntion == 3)
         trainFuntion = "traincgb";
     end
    
    if( (trainRatio + testRatio) ~= 100 )
        disp('Training values are not valid. Exiting...');
        return
    end

    file = open(strcat('dataset/',filename));
    if (strcmp(filename,'54802.mat'))
        a = open('dataset/54802_corrected_Trg.mat');
        target = convert_input(a.Trg);
    else
        target = convert_input(file.Trg);
    end

    P = file.FeatVectSel;

    if(network < 5)
       if(trainRatio ~= 100)
        [InputTrainingSet,TargetTrainingSet,InputTestingSet,TargetTestingSet] = TestingRatio(P,target,trainRatio); 
        P= InputTrainingSet ;
        target = TargetTrainingSet ;
        closest2 = find_closestVal(length(InputTestingSet));
        TargetTestingSet = TargetTestingSet(1:closest2,:);
        InputTestingSet = InputTestingSet(1:closest2,:);
        end 
    end
    
    

    closest = find_closestVal(length(P));
    target = target(1:closest,:);
    P = P(1:closest,:);


    if(balance == 2)
        if(network == 3)
            [images,target] = class_balancingIm(P,target,1);
        elseif(network == 4)
            [images,target] = class_balancingIm(P,target,0);
        else
            [P,target] = class_balancing(P,target);
        end
    else
        if(network == 3 || network == 4)
            [target,P] = associate_class(target,P);
            size(target);
            if(network == 4)
                images = createLSMT(P);
            else
                images = create_images(P);
            end
        end
    end

    if(network < 5)
        if(trainRatio ~= 100)
        [testingTarget,InputTestingSet] = associate_class(TargetTestingSet,InputTestingSet);
        end
    end

    if(network == 1)
        InputTestingSet = InputTestingSet.';
        TargetTestingSet = TargetTestingSet.';
        P = P.';
        target = target.';
        net = feedforwardnet(29);
        net.trainParam.epochs = 1000;
        net.divideParam.trainRatio=trainRatio/100;
        net.divideParam.testRatio=testRatio/100;   
        net.trainFcn = trainFuntion;
        net = train(net,P,target);
        if(trainRatio ~= 100)
            outSim = sim(net,InputTestingSet);
            [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = Performance(outSim,TargetTestingSet);
        else
            outSim = sim(net,P);
            [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = Performance(outSim,target);
        end
        SaveName = "NN_" + Sensivity + '_' + Specificity;
    elseif(network == 2)
        %For the recurrent NN
        InputTestingSet = InputTestingSet.';
        TargetTestingSet = TargetTestingSet.';
        P = P.';
        target = target.';
        net = layrecnet(1:2, 29);
        net.trainParam.epochs = 10;
        net.divideParam.trainRatio=trainRatio/100;
        net.divideParam.testRatio=testRatio/100;   
        net.trainFcn = trainFuntion;
        net = train(net,P,target);
        if(trainRatio ~= 100)
            outSim = sim(net,InputTestingSet);
            [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = Performance(outSim,TargetTestingSet);
        else
            outSim = sim(net,P);
            [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = Performance(outSim,target);
        end
        SaveName = "Recurrent_NN" + Sensivity + '_' + Specificity;
    elseif(network == 3)
        target = lables(target);
        target = categorical(target);
        
        if(trainRatio ~= 100)
             testingTarget = lables(testingTarget);
             testingImages = create_images(InputTestingSet);
        end

        net = runCNN(images,target);

       
        if(trainRatio ~= 100)
            [YPred] = classify(net,testingImages);
            YPred = grp2idx(YPred);
            [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = PerformanceCNN(YPred,testingTarget);
        else
            [YPred] = classify(net,images);
            YPred = grp2idx(YPred);
            target = grp2idx(target);
            [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = PerformanceCNN(YPred,target);
        end
        SaveName = "CNN_" + Sensivity + '_' + Specificity;
    elseif(network == 4)
        %For the LSTM
        target = lables(target);
        target = categorical(target);
        
         if(trainRatio ~= 100)
             testingTarget = lables(testingTarget);
             testingLSMT = createLSMT(InputTestingSet);
         end

        
        net = runLSTM(images,target);
        
        miniBatchSize = 27;

        
        if(trainRatio ~= 100)
            YPred = classify(net,testingLSMT,'MiniBatchSize',miniBatchSize,'SequenceLength','longest');
            YPred = grp2idx(YPred);
            [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = PerformanceCNN(YPred,testingTarget);
        else
            [YPred] = classify(net,images);
            YPred = grp2idx(YPred);
            target = grp2idx(target);
            [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = PerformanceCNN(YPred,target);
        end
        SaveName = "LSTM_" + Sensivity + '_' + Specificity;
    else
        %run a Network with a testing Set
        if(BnetworkType == 1)%Best Pre-Ictal 
            testingImages = create_images(P);
            testingTarget = lables(target);
            net = open('BestNetworks/CNN_0.75962_0.60297.mat');
            net = net.net;
            [YPred] = classify(net,testingImages);
            YPred = grp2idx(YPred);
            [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = PerformanceCNN(YPred,testingTarget);
            SaveName = "Best_Pre_ictal_" + Sensivity + '_' + Specificity;
        elseif(BnetworkType == 2)%Best Ictal 
            miniBatchSize = 27;
            testingLSMT = createLSMT(P);
            testingTarget = lables(target);
            net = open('BestNetworks/LSTM_0.74834_0.62217.mat');
            net = net.net;
            [YPred] = classify(net,testingLSMT,'MiniBatchSize',miniBatchSize,'SequenceLength','longest');
            YPred = grp2idx(YPred);
            [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = PerformanceCNN(YPred,testingTarget);
            SaveName = "Best_Ictal_" + Sensivity + '_' + Specificity;
        else
            testingImages = create_images(P);
            testingTarget = lables(target);
            net = open('BestNetworks/CNN_0.75962_0.60297.mat');
            net = net.net;
            [YPred] = classify(net,testingImages);
            YPred = grp2idx(YPred);
            [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = PerformanceCNN(YPred,testingTarget);
            SaveName = "Best_" + Sensivity + '_' + Specificity;
        end
    end

    sens = floor(Sensivity * 100);
    spec = floor(Specificity * 100);
    Preictal = floor(Preictal_accuracy);
    Ictal = floor(Ictal_accuracy);
    Acc = floor(Accuracy);
    
    fileID = fopen(SaveName + "_Stats.txt",'w');
    fprintf(fileID,"Sensitivity: %d%%\nSpecificity: %d%%\nPre-Ictals Accuracy: %d%%\nIctals Accuracy: %d%%\nAccuracy: %d%%",sens,spec,Preictal,Ictal,Acc);
    fclose(fileID);
    if(network < 5)
        save(SaveName+".mat",'net');
    end
end

function  start = find_closestVal(t)
    a = 29;
    aux = rem(t,a);
    start = t - aux;
end


function net = runLSTM(input,target)
    


    numFeatures = 29;
    numHiddenUnits1 = 290;
    numHiddenUnits2 = 174;
    numClasses = 4;
    
    layers = [
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits1,'OutputMode','sequence')
    lstmLayer(numHiddenUnits2,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];


    maxEpochs = 150;
    miniBatchSize = 27;

    options = trainingOptions('adam', ...
        'ExecutionEnvironment','cpu', ...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',miniBatchSize, ...
        'GradientThreshold',1, ...
        'Verbose',false, ...
        'Plots','training-progress');
    
    net = trainNetwork(input,target,layers,options);
end


function net = runCNN(images,imagesTarget)
    varSize = 29;
    conv1 = convolution2dLayer(5,varSize,'Padding',2,'BiasLearnRateFactor',2);
    conv1.Weights = single(randn([5 5 1 varSize])*0.0001);
    conv1.Bias = single(randn([1 1 varSize])*0.00001 + 1);
    conv2 = convolution2dLayer(5,varSize,'Padding',2,'BiasLearnRateFactor',2);
    conv3 = convolution2dLayer(5,58,'Padding',2,'BiasLearnRateFactor',2);
    fc1 = fullyConnectedLayer(58,'BiasLearnRateFactor',2);
    fc1.Weights = single(randn([58 522])*0.1);
    fc2 = fullyConnectedLayer(4,'BiasLearnRateFactor',2);
    fc2.Weights = single(randn([4 58])*0.1);

    layers = [
        imageInputLayer([varSize varSize 1]);
        conv1;
        maxPooling2dLayer(3,'Stride',2);
        reluLayer();
        conv2;
        reluLayer();
        averagePooling2dLayer(3,'Stride',2);
        conv3;
        reluLayer();
        averagePooling2dLayer(2,'Stride',2);
        fc1;
        reluLayer();
        fc2;
        softmaxLayer();
        classificationLayer();
        ];

    options = trainingOptions('sgdm','MaxEpochs', 1000,'Plots','training-progress');


    net = trainNetwork(images,imagesTarget,layers,options);

end

