function p = changePrior( data, m )
n=m{1};

pN=1/(length(data)-0);
K=length(data)*2;
%pCgN=(factorial((K)))/(factorial((n))*factorial((K-n)))^-1;  %normalize data zscore so variance 0-1 on all data
pCgN=nchoosek(K,n)^-1;
pAgN=prod(1./(max(data(:,end-1))-min(data(:,end-1))));  %need this multi dim
pSgN=1/(1-0);  %only if data is zscored

p=pN*pCgN*pAgN*pSgN;
p=1;

end
