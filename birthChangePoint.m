function [mp,q] = birthChangePoint( mc, data )
            mp=mc;
            mp{1}=mc{1}+1; %add changepoint
            
            mp{2}(mc{1}+1)=unifrnd(min(data(:,end)),max(data(:,end))-.1,1); %select location uniformly
            while(length(unique(mp{2}))<length(mp{2})) %make sure no overlap
                mp{2}(mc{1}+1)=unifrnd(min(data(:,end)),max(data(:,end)),1);
            end
            [mp{2},sorter]=sort(mp{2}); %sort new changepoint locations
            
            Part=[mp{2}(find(sorter==mp{1})-1) mp{2}(sorter==mp{1})];
            partData=data(data(:,end)>Part(1) & data(:,end)<Part(2),1:end-1);
            if(isempty(partData))
                mp=mc;
                q=0;
            else
            zMax=max(partData);
            zMin=min(partData);
            zMax(isnan(zMax))=1;
            zMin(isnan(zMin))=0;
            ind=(zMax-zMin)==0;
            zMax(ind)=1;
            zMin(ind)=0;
            meanPart=nanmean(partData);
            meanPart(isnan(meanPart))=0;
            sigmaPart=nanstd(partData);
            sigmaPart(isnan(sigmaPart))=unifrnd(0,1,1);
            sigmaPart(sigmaPart==0)=unifrnd(0,1,1);
            
            mp{3}(mp{1}-1,:)=arrayfun(@(z,t) normrnd(z,t,1),meanPart,sigmaPart);
            A=mp{3}(mp{1}-1,:);

            sorter(sorter==max(sorter))=max(sorter)-1;
            mp{3}=mp{3}(sorter(1:end-1),:);
           
            q=prod(1./(sigmaPart.^2.*(2*pi).^1/2).*exp((-1/2)*((A-meanPart)./sigmaPart.^2).^2))...
            *prod((1./(zMax-zMin)));
        if (isnan(q))
            zMax-zMin
        end
            end
end

