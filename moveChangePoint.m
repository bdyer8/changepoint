function [mp] = moveChangePoint( mc, data )
        mp=mc;
        movePoint=datasample(2:length(mp{2})-1,1);
        mp{2}(movePoint)=unifrnd(min(data(:,end)),max(data(:,end)),1);
        while(length(unique(mp{2}))<length(mp{2}))
            mp{2}(movePoint)=unifrnd(min(data(:,end)),max(data(:,end)),1);
        end
        mp{2}=sort(mp{2});              
end
