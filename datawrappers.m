%%vCreekDataWrapper
%clear all
close all
clear all
load('vCreekData.mat');

 data=[vCreekData(:,1)];
 load=[2:6];
 for k=load
     data=[vCreekData(:,k) data];
 end


 dataTypes=size(data,2)-1;
%  indexing=isnan(data);
%  indexing=sum(indexing')';
%  data=data(~indexing,:);
 for i=1:1:size(data,2)-1
 [data(:,i),zMean(i),zSigma(i)]=nanzscore(data(:,i));
 end

%%
load('testM.mat');
m{3}=m{3}';
data=changeMValueMulti(m,1:99);
data(:,3)=[1:99]';
data(:,1)=data(:,1)+normrnd(0,.2,99,1);
data(:,2)=data(:,2)+normrnd(0,.5,99,1);
 for i=1:1:size(data,2)-1
 [data(:,i),zMean(i),zSigma(i)]=zscore(data(:,i));
 end
%  data=data(datasample(1:99,66),:);
%  [~,sorter]=sort(data(:,3));
%  data=data(sorter,:)

 
 %%
 data=honakerData;
 data(:,end+1)=data(:,1);
 data=data(:,2:end);
   data=data(data(:,3)<160,:);
  for i=1:1:size(data,2)-1
 [data(:,i),zMean(i),zSigma(i)]=zscore(data(:,i));
  end
 



%%

compModel.mFit2=zSigma(1)*compModel.mFit(:,1)+zMean(1);
compModel.mFit2(:,2)=zSigma(2)*compModel.mFit(:,2)+zMean(2);
compModel.mFitLow2=zSigma(1)*compModel.mFitLow(:,1)+zMean(1);
compModel.mFitLow2(:,2)=zSigma(2)*compModel.mFitLow(:,2)+zMean(2);
compModel.mFitHigh2=zSigma(1)*compModel.mFitHigh(:,1)+zMean(1);
compModel.mFitHigh2(:,2)=zSigma(2)*compModel.mFitHigh(:,2)+zMean(2);

data2=zSigma(1)*data(:,1)+zMean(1);
data2(:,2)=zSigma(2)*data(:,2)+zMean(2);
data2(:,3)=data(:,3);

compModel.sigma2=sqrt(zSigma(1).^2*compModel.sigma(:,1).^2);
compModel.sigma2(:,2)=sqrt(zSigma(2).^2*compModel.sigma(:,2).^2);
