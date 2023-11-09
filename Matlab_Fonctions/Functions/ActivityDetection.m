function [Seg] = ActivityDetection(num, WhichMuscle, MinActivation, PLOT, Freq, Muscles)
% Dection of activity in EMG signal
% num is the raw signal (vector)
% WhichMuscle is the reference muscle as char : 'biceps'
% StdBorne1 & StdBorne1 define the bornes of signal without activation on
% which is computed the threshold : 1 & 3000
% MinActivation is the minimal number of frame during which muscle should
% be activated : 4000 pour 2sec
% PLOT = 1 to have a plot

% num = Normalization;
% num = EMGBL;
% WhichMuscle = 'deltant';
% MinActivation = 1500;
% PLOT = 1;
% Freq = 2000;
% Muscles = Muscles;

        % Filtre Raw Signal
        [b,a] = butter(2,2*2/Freq) ; % Parametre du filtre Low pass 2 Hz
        Signal = filtfilt(b,a,abs(num)) ; %On ne garde que les valeurs absolues de EMGBL donc signal redressé au-dessus de 0
        SignalFilter = Signal(:,find(ismember(Muscles(:,1),WhichMuscle)));
        figure
        plot(num(:,find(ismember(Muscles(:,1),WhichMuscle))))
        hold on
        plot(SignalFilter)

        % Find peaks on signal
        [pks,locs,w] = findpeaks(SignalFilter,'MinPeakHeight',2) ;
%         hold on
%         plot(locs,pks,'g*')

        % Détermine début et fin de chaque peak
        Binfsup = [locs-w locs+w];
        varInc = 1;
        for iBinfsup = 1:length(Binfsup)-1
            if (Binfsup(iBinfsup,2) > Binfsup(iBinfsup+1,1))
                Binfsup(iBinfsup,2) = Binfsup(iBinfsup+1,2);
                Binfsup(iBinfsup+1,1) = 0;
            end
        end
        Binfsup(Binfsup(:,1) <= 0,:) = [];
        Binfsup(Binfsup(:,2) > length(SignalFilter),2) = length(SignalFilter);

        %  Met les peak à 0
        segSignalFilter = []; SignalFilter2 = SignalFilter;
        for iBinfsup = 1:length(Binfsup)
            segSignalFilter{iBinfsup} = SignalFilter(Binfsup(iBinfsup,1):Binfsup(iBinfsup,2));
            SignalFilter2(Binfsup(iBinfsup,1):Binfsup(iBinfsup,2)) = 0;
        end
        hold on
        plot(SignalFilter2)

        % Ne garde que le signal différent de 0 (enlève les peaks)
        SignalFilter3 = SignalFilter2(SignalFilter2 ~= 0);
        
        % Ne garde que le signal inférieur à la moyenne (enlève les dernière composantes de peaks)
        SignalFilter4 = SignalFilter3(SignalFilter3 < mean(SignalFilter3));
        plot(SignalFilter3)
        hold on
        plot(SignalFilter4)

        % Compute activation threshold
        StandardDeviation = std(SignalFilter4);
        ThreshActivity = mean(SignalFilter4) + 3*StandardDeviation;

        % Detect When signal is above the threshold
        Seg = [];
        varInc = 1;
        for iSignalFilter = 2:length(SignalFilter)
            if SignalFilter(iSignalFilter-1) < ThreshActivity & SignalFilter(iSignalFilter) > ThreshActivity
               Seg(varInc,1) = iSignalFilter;
            end
            if SignalFilter(iSignalFilter-1) > ThreshActivity & SignalFilter(iSignalFilter) < ThreshActivity
                Seg(varInc,2) = iSignalFilter;
                varInc = varInc+1;
            end
        end

        % Delete false activation
        Seg(Seg(:,2)-Seg(:,1) < MinActivation,:)=[];

        for iSeg = 1:length(Seg)-1
            varInc = 1;
            while Seg(iSeg+varInc,1) - Seg(iSeg,2) < 3000
                Seg(iSeg,2) = Seg(iSeg+varInc,2);
                Seg(iSeg+varInc,1) = 0;
                varInc = varInc + 1;
                if iSeg+varInc > length(Seg)
                    break
                end
            end
        end
        Seg(Seg(:,1)==0,:) = [];

        if PLOT == 1
            figure;

            plot(SignalFilter)
            hold on
            plot([0 length(num)], [ThreshActivity ThreshActivity])
            hold on
            
            for iSeg = 1:length(Seg)
                hold on
                plot([Seg(iSeg,1) Seg(iSeg,1)], [0 50],'Color','Green')
                plot([Seg(iSeg,2) Seg(iSeg,2)], [0 50],'Color','yellow')
            end
        end
end
