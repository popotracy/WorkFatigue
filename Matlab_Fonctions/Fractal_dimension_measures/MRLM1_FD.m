function [BXCFD]=MRLM1_FD(serie)
serie = Data.EMG.DeltM(1:20000);
N=length(serie);
%R=max(size(serie)); % where R/fs is the maximum coarse time resolution at which the curve is looked at

R=N;
% N=100000;
% R=N*10;
fs=2000;
t = (0:N-1)*1/fs;
j=1;
for x=1:N
    rinc(x)=j/fs;
    j=j*2;
    if j>= R
        break
    end
end
r = {'r1','r2','r3','r4','r5','r6','r7','r8','r9','r10'};
% L = NaN(1,N-1); %Predifinition variable for computational efficiency.
%L is the total length of the time serie
for j=1:10
    for i = 1:N-1  
        l.(r{j})(i,:) = sqrt(((t(i) - t(i+1))^2) + ((serie(i) - serie(i+1))^2));
    end
    L(j) = sum(l.(r{j}));
    serie = serie(1:2:length(serie));
    N=length(serie);
    t = (0:N-1)*(j*2/fs);
end

for i = 1:10
    alpha(i) = log(1/rinc(i))/log(L(i)/rinc(i));
end
plot(alpha(1:9),'-o')


