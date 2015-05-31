function LL = changeLMulti( data, m )
            sigma=m{4};
            mData=changeMValueMulti(m,data(:,end));
            LL=(1./((2*pi*(sigma(:)*ones(1,length(data)))'.^2).^(1/2))).*exp((-1/2)*((data(:,1:end-1)-mData)./(sigma(:)*ones(1,length(data)))').^2);           
            LL=LL(~isnan(LL));
            LL=sum(sum(log(LL)));
end

