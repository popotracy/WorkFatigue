%% Synchronization of EMG, Xsens, MIDI and sound
clear ; clc ; close all
addpath(genpath('\\10.89.24.15\e\Projet_ForceMusculaire\Fabien_ForceMusculaire\functions\btk'))

Conditions = {...
    'Ex1_poulie_BS_30','Ex1_poulie_OR_30','Ex1_poulie_BS_60','Ex1_poulie_OR_60',...
    'Ex2_tire_barre_BS_30','Ex2_tire_barre_OR_30','Ex2_tire_barre_BS_60','Ex2_tire_barre_OR_60',...
    'Ex3_dev_BS_30','Ex3_dev_OR_30','Ex3_dev_BS_60','Ex3_dev_OR_60',...
    'Ex4_flex_biceps_BS_30','Ex4_flex_biceps_OR_30','Ex4_flex_biceps_BS_60','Ex4_flex_biceps_OR_60'} ;

run \\10.89.24.15\e\Projet_OrbitalRotation\Subjects_OrbitalRotation
EMG_name = {'Upper trap','Middle trap','Anterior delt','Middle delt','Posterior delt','Biceps','Triceps','Brachialis','XX'} ;

for iS = 11%:length(Subjects)
    for iC =1%:length(Conditions)
        %% EMG
        if exist(['\\10.89.24.15\j\OrbitalRotation\Compiled_Data\' Subjects(iS).ID '_' Conditions{iC} '_Kin.mat'])
            load(['\\10.89.24.15\j\OrbitalRotation\Compiled_Data\' Subjects(iS).ID '_' Conditions{iC} '_Kin.mat'])
            
            
            figure ; plot(Data.Angles(:,25:27)) ; title(Conditions{iC},'interpreter','none')
            
            [x,y]=findpeaks(Data.Angles(:,26),'MinPeakDistance',75,'MinPeakHeight',35);
            
            coor = [x,y];
            %coor(6,:)=[]
            %coor(2,:)=[]
            %coor(1,:)=[]
            
            figure; findpeaks(Data.Angles(:,27),'MinPeakDistance',75,'MinPeakHeight',35)
            
            %save(['\\10.89.24.15\j\OrbitalRotation\Peaks\Elbow\' Subjects(iS).ID '_' Conditions{iC} '_Kin.mat'], 'coor')

            clear Data
        else
            d=0
       
      
        end
        
    end
end