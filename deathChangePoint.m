function [mp,q] = deathChangePoint( mc, data )
            mp=mc;
            mp{1}=mc{1}-1;
            remove=datasample(2:length(mp{2})-1,1);
            
            Part=[mp{2}(remove-1) mp{2}(remove)];
            partData=data(data(:,end)>Part(1) & data(:,end)<Part(2),1:end-1);
            if(isempty(partData))
                mp=mc;
                q=Inf;
            else
                zMax=max(partData);
                zMin=min(partData);
                zMax(isnan(zMax))=1;
                zMin(isnan(zMin))=0;
                ind=(zMax-zMin)==0;
                zMax(ind)=1;
                zMin(ind)=0;
                zMax(isnan(zMax) | zMax==0)=1;
                zMin(isnan(zMin) | zMin==0)=0;
                meanPart=nanmean(partData);
                meanPart(isnan(meanPart))=0;
                sigmaPart=nanstd(partData);
                sigmaPart(isnan(sigmaPart))=unifrnd(0,1,1);
                sigmaPart(sigmaPart==0)=unifrnd(0,1,1);

                mp{2}=mp{2}([1:length(mp{2})]~=remove);
                keep=[1:remove-2 remove:size(mp{3},1)];
                try
                mp{3}=mp{3}(keep,:);
                catch
                    mp
                    remove
                    keep
                    rethrow
                end
                A=arrayfun(@(z,t) normrnd(z,t,1),meanPart,sigmaPart);
                q=prod((sigmaPart.^2.*(2*pi).^1/2).*exp((-1/2)*(A-meanPart)./sigmaPart.^2).^2)...
                    *prod(zMax-zMin);
            end

                
            
end
