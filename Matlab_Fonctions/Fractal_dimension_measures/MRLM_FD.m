function [BXCFD]=MRLM_FD(serie,fs)

% Génère un signal théorique de type Weierstrass cosine Function
% de Dimension Fractale = 2-H
% serie = Generate_WCF(5, 2.2, 1025000);
% fs=1000;
% plot(serie)

N=length(serie);
R=N;

t = (0:N-1)*1/fs;
j = 1;
r = {};
rinc = [];
for x = 1:R
    rinc(x) = j/fs;
    r{x} = ['r' num2str(x)];
    j=j*2;
    if j>= R
        break
    end
end

L = [];
for j=1:length(r)
    for i = 1:N-1
        l.(r{j})(i,:) = sqrt(((t(i) - t(i+1))^2) + ((serie(i) - serie(i+1))^2));
    end
    L(j) = sum(l.(r{j}));
    serie = serie(1:2:length(serie));
    N=length(serie);
    t = (0:N-1)*(j*2/fs);
end

loglog(1./rinc,L./rinc,'-o');
mdl = fitlm(log(1./rinc),log(L./rinc));
plot(mdl);

coef = polyfit(log(1./rinc),log(L./rinc), 1);
BXCFD = coef(1);
end