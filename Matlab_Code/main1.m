balance = 1;
filename = '54802.mat';
trainRatio = 90;
testRatio = 10;
valRatio = 0;
network = 1;

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

if(trainRatio ~= 100)
    [InputTrainingSet,TargetTrainingSet,InputTestingSet,TargetTestingSet] = TestingRatio(P,target,trainRatio); 
    P= InputTrainingSet ;
    target = TargetTrainingSet ;
    closest2 = find_closestVal(length(InputTestingSet));
    TargetTestingSet = TargetTestingSet(1:closest2,:);
    InputTestingSet = InputTestingSet(1:closest2,:);
end

closest = find_closestVal(length(P));
target = target(1:closest,:);
P = P(1:closest,:);


if(balance == 1)
    if(network == 1)
        [images,target] = class_balancingIm(target,P);
    else
        [P,target] = class_balancing(P,target);
    end
else
    if(network == 1)
        target = associate_class(target);
        images = create_images(P);
    end
end

testingTarget = associate_class(TargetTestingSet);



if(network == 1)
    target = lables(target);
    testingTarget = lables(testingTarget);
    testingImages = create_images(InputTestingSet);
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

    options = trainingOptions('sgdm','MaxEpochs', 100);

    target = categorical(target);
    testingTarget = categorical(testingTarget);

    net = trainNetwork(images,target,layers,options);

    [YPred,scores] = classify(net,testingImages);

    accuracy = sum(YPred == testingTarget)/numel(testingTarget);
    YPred = grp2idx(YPred);
    testingTarget = grp2idx(testingTarget);
    [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = PerformanceCNN(YPred,testingTarget);
else
    InputTestingSet = InputTestingSet.';
    TargetTestingSet = TargetTestingSet.';
    P = P.';
    target = target.';
    net = feedforwardnet(140);
    net.trainParam.epochs = 100;
    net.divideParam.trainRatio=trainRatio/100;
    net.divideParam.testRatio=testRatio/100;   
    net.divideParam.valRatio=valRatio/100;
    net.trainFcn = 'traincgp';
    net = train(net,P,target);
    if(trainRatio ~= 100)
        outSim = sim(net,InputTestingSet);
        [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = Performance(outSim,TargetTestingSet);
    else
        outSim = sim(net,P);
        [Sensivity,Specificity,Preictal_accuracy,Ictal_accuracy,Accuracy] = Performance(outSim,target);
    end
end



function  start = find_closestVal(t)
    a = 29;
    aux = rem(t,a);
    start = t - aux;
end