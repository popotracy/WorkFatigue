clear ;
close all ;
clc ;

addpath C:\Users\p1098713\Documents\3.MATLAB\Fonctions
addpath(genpath('C:\Users\p1098713\Documents\3.MATLAB\Fonctions\Codes_Analyse_Xsens_EMG'))

CD = cd(['C:\Users\p1098713\Documents\2.Post-Doc\TestXSens\mvnx']);
FolderContent = dir([CD]);
FileNames = {...
    FolderContent(3:length(FolderContent)).name...
} ;

for iFiles = 1%:length(FileNames)
    Xsens = load_mvnx([FileNames{iFiles}]) ;
    Data = Xsens.subject.frames.frame;

    for FirstFrame=1:20
        type =  Xsens.subject.frames.frame(FirstFrame).type ;
        if strcmp(type,'normal')
            break
        end
    end

    tempAcc = nan(length(Xsens.subject.frames.frame)-FirstFrame+1,length(Xsens.subject.frames.frame(FirstFrame).sensorFreeAcceleration)) ;
    tempQuat = nan(length(Xsens.subject.frames.frame)-FirstFrame+1,length(Xsens.subject.frames.frame(FirstFrame).sensorOrientation)) ;
    tempMag = nan(length(Xsens.subject.frames.frame)-FirstFrame+1,length(Xsens.subject.frames.frame(FirstFrame).sensorMagneticField)) ;
    tempGyr = nan(length(Xsens.subject.frames.frame)-FirstFrame+1,length(Xsens.subject.frames.frame(FirstFrame).angularVelocity)) ;
    for p=FirstFrame:length(Xsens.subject.frames.frame)
        tempAcc(p-FirstFrame+1,:) = Xsens.subject.frames.frame(p).sensorFreeAcceleration ;
        tempQuat(p-FirstFrame+1,:) = Xsens.subject.frames.frame(p).sensorOrientation ;
        tempMag(p-FirstFrame+1,:) = Xsens.subject.frames.frame(p).sensorMagneticField ;
        tempGyr(p-FirstFrame+1,:) = Xsens.subject.frames.frame(p).angularVelocity ;
    end
    
    Acc = nan(length(Xsens.subject.frames.frame)-FirstFrame+1,3,17) ;
    Quat = nan(length(Xsens.subject.frames.frame)-FirstFrame+1,4,17) ;
    Mag = nan(length(Xsens.subject.frames.frame)-FirstFrame+1,3,17) ;
    Gyr = nan(length(Xsens.subject.frames.frame)-FirstFrame+1,3,23) ;
    inc = 1:3:51 ;
    for iSensors = 1:7
        Acc(:,:,iSensors) = tempAcc(:,inc(iSensors):inc(iSensors)+2) ;
        Mag(:,:,iSensors) = tempMag(:,inc(iSensors):inc(iSensors)+2) ;
    end
    inc = 1:4:68 ;
    for iSensors = 1:7
        Quat(:,:,iSensors) = tempQuat(:,inc(iSensors):inc(iSensors)+3) ;
    end
    inc = 1:3:69 ;
    for isegments = 1:23
        Gyr(:,:,isegments) = tempGyr(:,inc(isegments):inc(isegments)+2) ;
    end
end

for i = 1:17
    plot(Acc(:,:,2))
    title(i)
    pause()
end

%Biais Acc
plot(-Acc(:,:,2))

figure;plot(Gyr(:,:,16))
ttt = LocalRef(Gyr(:,:,16),Quat(:,:,2));
plot(ttt)
