function [mp] = changeMeanValues( mc, data )
        mp=mc;
        partition=datasample(2:length(mp{2}),1); 
        Part=[mp{2}(partition-1) mp{2}(partition)];
        partData=data(data(:,end)>Part(1) & data(:,end)<Part(2),1:end-1);
        meanPart=nanmean(partData);
        meanPart(isnan(meanPart))=0;
        sigmaPart=nanstd(partData);
        sigmaPart(isnan(sigmaPart))=0;
        mp{3}(partition,:)=arrayfun(@(z,t) normrnd(z,t,1),meanPart,sigmaPart);         
end
