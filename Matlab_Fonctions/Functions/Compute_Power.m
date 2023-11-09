function [PowerLF, PowerHF, PowerTot, PeakPower, PeakPower_Freq] = Compute_Power(norm2_s1, Wave_FreqS)

PowerLF = nan(size(norm2_s1,2),1) ;
PowerHF = nan(size(norm2_s1,2),1) ;
PowerTot = nan(size(norm2_s1,2),1) ;
PeakPower = nan(size(norm2_s1,2),1) ;

for iTime = 1:size(norm2_s1,2)
    PowerLF(iTime,1) = trapz(norm2_s1(1:find(Wave_FreqS==4),iTime)) ;
    PowerHF(iTime,1) = trapz(norm2_s1(find(Wave_FreqS==4):end,iTime)) ;
    PowerTot(iTime,1) = trapz(norm2_s1(:,iTime)) ;
    PeakPower(iTime,1) = max(norm2_s1(:,iTime)) ;
    PeakPower_Freq(iTime,1) = Wave_FreqS(find(norm2_s1(:,iTime)==PeakPower(iTime,1))) ;
end

