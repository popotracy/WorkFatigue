addpath H:\Bureau\Etienne\MATLAB\Functions
addpath(genpath('H:\Bureau\Etienne\MATLAB\Functions\FFT'))

Ts = 0.001;
t= (1:500)*Ts;
f1=130; f2=150; 
Omega1 = 2*pi*f1; Omega2 = 2*pi*f2;
xT = 5*sin(Omega1*t)+ 9*cos(Omega2*t)+ 10*randn(1,length(t));

figure, plot(t,xT);

%% To Etienne De Brugier 2019
Fs = 1/Ts;
 FreqMinCalc=0.1;  % la fr?quences miminale de calcul de la puissance
    FreqMaxCalc=500; % fr?quence maximale
 NFFT = length(xT);
%             [PxT,FxT] = pwelch(xT,hanning(NFFT/1),[],NFFT,Fs,'power');
               [PxT,FxT] = pwelch(xT,hanning(400),100,500,Fs,'power');
               Fx = FxT;
            [ Fmean_T , FMed_T  , Mode_T,PuisTotaleFreq_T ]...
                = Freq_param(PxT, FxT,Fs,FreqMinCalc,FreqMaxCalc);
            figure(210);
            clf;
            subplot(211),plot(FxT,PxT,'r'); xlim([0  FreqMaxCalc])
            grid on; xlabel('(Hz)') ;ylabel('Power with Pwelch')
            
            
            
          X_fft =   abs(fft(xT,NFFT))/NFFT/.2;
          freq = (0:NFFT-1)*Fs/NFFT;
          
           subplot(212),plot( freq(1:NFFT/2),X_fft(1:NFFT/2)); xlabel('(Hz)');ylabel('X_fft')