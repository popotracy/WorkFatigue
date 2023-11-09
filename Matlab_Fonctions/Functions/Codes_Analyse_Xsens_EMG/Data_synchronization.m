%% Synchronization of EMG, Xsens, MIDI and sound
 clear; clc ; close all
addpath(genpath('\\10.89.24.15\e\Projet_ForceMusculaire\Fabien_ForceMusculaire\functions\btk'))

Conditions = {...
    'Ex1_poulie_BS_30','Ex1_poulie_OR_30','Ex1_poulie_BS_60','Ex1_poulie_OR_60',...
    'Ex2_tire_barre_BS_30','Ex2_tire_barre_OR_30','Ex2_tire_barre_BS_60','Ex2_tire_barre_OR_60',...
    'Ex3_dev_BS_30','Ex3_dev_OR_30','Ex3_dev_BS_60','Ex3_dev_OR_60',...
    'Ex4_flex_biceps_BS_30','Ex4_flex_biceps_OR_30','Ex4_flex_biceps_BS_60','Ex4_flex_biceps_OR_60'} ;

run \\10.89.24.15\e\Projet_OrbitalRotation\Xsens\Subjects_OrbitalRotation

EMG_channels = {...
        % 'Sensor_1_EMG1','Sensor_2_EMG2','Sensor_3_EMG3','Sensor_4_EMG4','Sensor_5_EMG5','Sensor_6_EMG6','Sensor_7_EMG7','Sensor_8_EMG8','Sensor_9_EMG9'}
    'TrapSup_IM_EMG1','TrapMoy_IM_EMG2','DeltAnt_IM_EMG3','DeltMoy_IM_EMG4','DeltPost_IM_EMG5','Biceps_IM_EMG6','Triceps_IM_EMG7','BrachRad_IM_EMG8','PronTer_IM_EMG9'};
    %'Sensor_1_IM_EMG1','Sensor_2_IM_EMG2','Sensor_3_IM_EMG3','Sensor_4_IM_EMG4','Sensor_5_IM_EMG5','Sensor_6_IM_EMG6','Sensor_7_IM_EMG7','Sensor_8_IM_EMG8','Sensor_9_IM_EMG9'} ;

EMG_name = {'Upper trap','Middle trap','Anterior delt','Middle delt','Posterior delt','Biceps','Triceps','Brachiodarialis','Pronator Teres'} ;

for iS =17%:length(Subjects)
    if Subjects(iS).keep==1        
        for iC =1:length(Conditions)
            %% EMG
            if exist(['\\10.89.24.15\j\OrbitalRotation\RawData\Vicon\' Subjects(iS).date  '\' Subjects(iS).ID  '\Fmax\' Conditions{iC} '.c3d'])
                acq = btkReadAcquisition(['\\10.89.24.15\j\OrbitalRotation\RawData\Vicon\' Subjects(iS).date  '\' Subjects(iS).ID  '\Fmax\' Conditions{iC} '.c3d']) ;
                
                EMG = btkGetAnalogs(acq) ;
             
                Data.EMG_FreqSamp = btkGetAnalogFrequency(acq) ;
                
                for iM = 1:length(EMG_channels)
                    Data.EMG(:,iM) = EMG.(EMG_channels{iM}) ;
                end
                
                Data.Trigger = EMG.Voltage_1 ;                  
                trigger_frames = find(Data.Trigger>0.01);
                start_trigger = trigger_frames(1) ;
              
                stop_trigger = trigger_frames(find(diff(trigger_frames)>1)+1); 
                stop_trigger = stop_trigger(length(stop_trigger));

                Verif_time_trial(iC,1) = (stop_trigger - start_trigger)/Data.EMG_FreqSamp  ;
                 Data.EMG = Data.EMG(start_trigger:stop_trigger,:) ;
                
                figure ; plot(Data.Trigger) ; hold on ;  plot(start_trigger,1.2,'*'); title(Conditions{iC});plot(stop_trigger,1.2,'*')
                
                %% Xsens                
                if strcmp(Subjects(iS).ID,'P01') || strcmp(Subjects(iS).ID,'P02') || strcmp(Subjects(iS).ID,'P03') || strcmp(Subjects(iS).ID,'P04') || strcmp(Subjects(iS).ID,'P05') || strcmp(Subjects(iS).ID,'P06') || strcmp(Subjects(iS).ID,'P07') || ...
                        strcmp(Subjects(iS).ID,'P08') || strcmp(Subjects(iS).ID,'P09') || strcmp(Subjects(iS).ID,'P10')
                    Xsens = load_mvnx(['\\10.89.24.15\j\OrbitalRotation\RawData\Xsens\' Subjects(iS).ID  '\' Conditions{iC} '-001.mvnx']) ;
                else
                    Xsens = load_mvnx(['\\10.89.24.15\j\OrbitalRotation\RawData\Xsens\' Subjects(iS).ID  '\' Conditions{iC} '.mvnx']) ;
                end
                
                for FirstFrame=1:20
                    type =  Xsens.subject.frames.frame(FirstFrame).type ;
                    if strcmp(type,'normal')
                        break
                    end
                end                
                
                Data.Angles = nan(length(Xsens.subject.frames.frame)-FirstFrame+1,length(Xsens.subject.frames.frame(FirstFrame).jointAngle)) ;
                for p=FirstFrame:length(Xsens.subject.frames.frame)
                    Data.Angles(p-FirstFrame+1,:) = Xsens.subject.frames.frame(p).jointAngle ;
                end
                
                i=1 ;
                for p=1:22
                    for q=1:3
                        DOF = {'x','y','z'} ;
                        Data.Angles_dof{i,1} = [Xsens.subject.joints.joint(p).label ' ' DOF{q}] ;
                        i=i+1 ;
                    end
                end
               
                Data.Kin_FreqSamp = Xsens.subject.frameRate ;
                Verif_time_trial(iC,2) = length(Data.Angles)/Data.Kin_FreqSamp ;
                
                save(['\\10.89.24.15\j\OrbitalRotation\Xsens\Compiled_Data\' Subjects(iS).ID '_' Conditions{iC} '_Kin.mat'], 'Data')
                save(['\\10.89.24.15\j\OrbitalRotation\VerifTime' Subjects(iS).ID '.mat'], 'Verif_time_trial')
                clear Data
              
            end
        end
    end
 end