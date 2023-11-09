function [ FMoy , FMed , Mode_freq,Peak,PuisTotaleFreq] = Freq_param(Spectr, Freq_ax,Fs,FreqMinCalc,...
    FreqMaxCalc);
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% Inputs
%    f: frequencies (Hz)
%    p: power spectral density values
%    FreqMinCalc=4;  % la fr?quences miminale de calcul de la puissance
%    FreqMaxCalc=100; % fr?quence maximale%

% Outputs
%    FMoy: moyen frequency
%    FMed: median frequency
%    Mode_freq: modal frequency

%% PARAM?TRES DE BASE
% 
% FreqMinCalc=2;  % la fr?quences miminale de calcul de la puissance
% FreqMaxCalc=30; % fr?quence maximale
% Nfft=Fe;    % On veut avoir une r?solution de 1 Hz pour ?viter les probl?mes de calcul
% df=Fe/Nfft; % On doit retrouver 1 ici.

% df = Fs/length(Freq_ax);
% inti = round( FreqMinCalc/df); fin = round( FreqMaxCalc/df);


fin=max( find(Freq_ax<=FreqMaxCalc));
inti=1;

Spectr = Spectr(inti:fin); Freq_ax=Freq_ax(inti:fin);
PuisTotaleFreq=sum(Spectr);
%%
% Calcul de la puissance totale pour la plage de fr?quence d?sir?e

% NFreqMinCalc=ceil(FreqMinCalc/df);
% NFreqMaxCalc=floor(FreqMaxCalc/df);
% 
% PuisTotaleFreq=sum(Spectr(NFreqMinCalc:NFreqMaxCalc))*df;  % On divise 
    % par la r?solution fr?quentielle df pour avoir la bonne int?gration fr?quentielle

PuisTotaleFreq=abs(PuisTotaleFreq);

[m,id] = max(Spectr);
     Peak =m;
     Mode_freq =  Freq_ax ([id]);
     FMoy =  meanfreq ( Spectr,Freq_ax );
     FMed = medianfrequency(Freq_ax,Spectr );
end

