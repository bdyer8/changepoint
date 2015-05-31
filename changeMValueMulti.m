function [out] = changeMValueMulti( m, points )
if(size(points,2)>size(points,1))
    points=points';
end
index=(ones(1,length(points))'*m{2})>points*ones(1,length(m{2}))==0;
tempIndex=diff(index,1,2)*-1;
modDivide=size(tempIndex,2);
tempIndex=find(tempIndex(:,:)'==1);
tempIndex=mod(tempIndex,modDivide);
tempIndex(tempIndex==0)=modDivide;
out=m{3}(tempIndex,:);
end

