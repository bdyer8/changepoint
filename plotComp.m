
compModel=vModel;
%load('vCreekData.mat');

%  data=[vCreekData(:,1)];
%  load=[15:25];
%  for k=load
%      data=[vCreekData(:,k) data];
%  end
% 
% 
%  dataTypes=size(data,2)-1;
%  indexing=isnan(data);
%  indexing=sum(indexing')';
%  data=data(~indexing,:);
%  for i=1:1:size(data,2)-1
%  [data(:,i),zMean(i),zSigma(i)]=zscore(data(:,i));
%  end
%  range=0:max(data(:,end))+1;
%  dimensions=linspace(range(1),range(end)-.01,10000);
 %unZ

 rng(95)
 
 colors=(rand(size(data,2)-1,3));
 
 resolution=1000;
dimensions=linspace(0,data(end,end),resolution);

figure
hold on
legendStr={''};

% for i=1:length(pTop)
%    line([-10 10],[pTop(i) pTop(i)],'Color',[.8 .8 .8],'LineWidth',.5)
% end

for i=1:size(data,2)-1        
h=herrorbar(data(:,i),data(:,end),mean(compModel.sigma(i,:))*ones(size(data(:,i))),'.');
set(h,'Color',[colors(i,:)]+([1 1 1]-colors(i,:))/2,'MarkerEdgeColor','none',...
    'MarkerSize',1,'MarkerFaceColor',colors(i,:));
end
for i=1:size(data,2)-1        
plot(data(:,i),data(:,end),'o','MarkerEdgeColor',[.3 .3 .3],...
    'MarkerSize',4,'MarkerFaceColor',colors(i,:));
end
for i=1:size(data,2)-1
legendObj(i)=plot(compModel.mFit(:,i),dimensions,'Color',[colors(i,:)],'LineWidth',2);
plot(compModel.mFitLow(:,i),dimensions,'-','Color',colors(i,:)+([1 1 1]-colors(i,:))/3);
plot(compModel.mFitHigh(:,i),dimensions,'-','Color',colors(i,:)+([1 1 1]-colors(i,:))/3);
legendStr(i)={num2str(i)};
end
    miniX=min(min(data(:,1:end-1)))-max(max(compModel.sigma));
    maxiX=max(max(data(:,1:end-1)))+max(max(compModel.sigma));
    [f,xi] = ksdensity(compModel.locations,data(1,end):.01:data(end,end),'width',0.25);
    plot(maxiX-f*.2*(maxiX-miniX)/max(f),xi,'Color',[.2 .2 .2],'LineWidth',1);
    axis([ miniX maxiX data(1,end) data(end,end)]);
    %vStr={'d13c','d15n','d34s','hr to t Fe'};
    formatPlot(gca,'Data (zScored)','Meters','');
    %legend(legendObj,vStr,'Location','eastoutside');
    legend(legendObj,legendStr,'Location','eastoutside');


