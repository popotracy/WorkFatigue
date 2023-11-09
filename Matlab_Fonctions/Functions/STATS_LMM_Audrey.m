clear
%% Analyse stats EMG
load('C:\Users\p1038617\Desktop\LMM_Audrey\EMG.mat')
EMG(EMG==0) = nan ;

Label_EMG = {'RRF' 'RVL' 'RTA' 'RGM' 'RST' 'RGAL'} ;

i=1 ;
for p=1:6:36
   emg.(Label_EMG{i}) = EMG(:,p:p+5) ;
   i=i+1 ;
end

for var = 1:length(Label_EMG)
    line=1 ;   subnum = [] ; block = [] ; orga = [] ;cov = [] ;
    data = emg.(Label_EMG{var}) ;
    for iS=1:size(data,1)
        for iC = 1:size(data,2)
            subnum(line,1) = iS ;... participant (vecteur)
            block(line,1) = iC-1 ;... var indépendante
            orga(line,1) = data(iS,iC) ;... var dépendante (vecteur)
            line=line+1 ;
        end
    end
    Out.(['Var' num2str(var)]) = [subnum block cov orga] ;
end

save('C:\Users\p1038617\Desktop\LMM_Audrey\tmpMatrix.mat','Out')

% Appelle le code R Ancova_EEG
cd('C:\Program Files\R\R-3.4.4\bin\x64\')
system('Rscript.exe C:\Users\p1038617\Desktop\LMM_Audrey\LMM_Audrey.R') ;
% cd('C:\Users\p1038617\Desktop\RESULTS_EXERCISE_RestingState\scripts')

info = hdf5info('C:\Users\p1038617\Desktop\LMM_Audrey\tmpStats.h5') ;
for iVar=1:length(info.GroupHierarchy.Groups.Datasets)
    toto = strfind(info.GroupHierarchy.Groups.Datasets(1,iVar).Name,'/') ;
    Variable(iVar,1) = str2double(info.GroupHierarchy.Groups.Datasets(1,iVar).Name(1,toto(2)+1:end)) ;
end
for iVar = 1:length(Variable)
    line = Variable(iVar) ;
    dset = h5read(...
        info.GroupHierarchy.Groups.Datasets(iVar).Filename,...
        info.GroupHierarchy.Groups.Datasets(iVar).Name) ;
    
    P_values(iVar,1) = dset.Pr0x280x3EChisq0x29(2) ;
    %         clear dset
end
delete('C:\Users\p1038617\Desktop\LMM_Audrey\tmpStats.h5')... penser  supprimer la variable avant ré-exécution
delete('C:\Users\p1038617\Desktop\LMM_Audrey\tmpMatrix.mat')

