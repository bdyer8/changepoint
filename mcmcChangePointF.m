
function compModel = mcmcChangePointF(data,iterations,burnin,frameskip,supressVideo,videoName)
close all;
clc;
warning('off','all')
dataTypes=size(data,2)-1;
% supressVideo=true;
% load('vCreekData.mat');
% 
%     iterations=1000000;
%     frameskip=50000;
%     burnin=500000;

    if ~supressVideo
        writerObj = VideoWriter(videoName);
        writerObj.FrameRate = round(iterations/frameskip/5);  %calculate for 5 s video
        open(writerObj);
    end
    
    
 range=0:max(data(:,end))+1;
 dimensions=linspace(range(1),range(end)-.01,10000);
 

check=-Inf;
while(check==-Inf)
    mc{1}=(datasample(4:size(data,1)/3,1));
    mc{2}=[0 unifrnd(min(range),max(range),1,mc{1}-2)];
    mc{2}=[mc{2} max(range)];
    mc{2}=sort(mc{2});
    mc{3}=unifrnd(min(data(:,1)),max(data(:,1)),1,mc{1}-1)';
    for i=2:1:dataTypes
        mc{3}=[mc{3} unifrnd(min(data(:,i)),max(data(:,i)),1,mc{1}-1)'];
    end
    mc{4}(1)=unifrnd(0,1,1);
    for i=2:1:dataTypes
        mc{4}(i)=unifrnd(0,1,1);
    end
    mc{5}=range;
    check=changeLMulti(data,mc);
end

disp('Starting changepoint model..');
    
    
    ll(1)=changeLMulti(data,mc);
    ll(2:iterations)=NaN;
    ns(1)=mc{1};
    ns(2:iterations)=NaN;
    sigma(1,:)=mc{4};
    sigma(2:iterations,:)=NaN;
    if ~supressVideo
        figure('units','pixels','position',[0 0 1200 1200]);
        plotChangePoint( mc, data, ll, sigma, iterations, 1, dimensions, ns )
        frame = getframe(gcf);
    end
    

    for(i=1:1:iterations)
            mA{i}.count=NaN;
            mA{i}.locations=NaN;
            mA{i}.means=NaN;
            mA{i}.noise=NaN;
    end
    
    
tic
for i=2:1:iterations
    test=datasample(1:5,1,'Weights',[.25 .15 .15 .25 .25]);
    %4 birth, 5 death, 1 new location, 2 new A, 3 change noise
    if test==1;
        mp=moveChangePoint(mc,data);
        currentL=changeLMulti(data,mc);
        proposedL=changeLMulti(data,mp);
        acceptance=exp(proposedL-currentL);

    end
    
    if test==2;
        mp=changeMeanValues(mc,data);
        currentL=changeLMulti(data,mc);
        proposedL=changeLMulti(data,mp);
        acceptance=exp(proposedL-currentL);

    end
    
    if test==3;
        mp=mc;
        dataField=datasample(1:dataTypes,1);
        mp{4}(dataField)=unifrnd(0,1,1);
        currentL=changeLMulti(data,mc);
        proposedL=changeLMulti(data,mp);
        %acceptance=prod((mp{4}(:)./mc{4}(:)).^length(data))*exp(proposedL-currentL);
        acceptance=exp(proposedL-currentL);

    end
    
    if test==4;    
        if mc{1}<length(data)-1
            [mp,q]=birthChangePoint(mc,data);
            currentL=changeLMulti(data,mc);
            proposedL=changeLMulti(data,mp);
            acceptance=q*exp(proposedL-currentL);
        
        else
            [mp,q]=deathChangePoint(mc,data);  
            currentL=changeLMulti(data,mc);
            proposedL=changeLMulti(data,mp);
            acceptance=1/q*exp(proposedL-currentL);
        
        end
    end
    
    if test==5
        if mc{1}<=3;
            [mp,q]=birthChangePoint(mc,data);
            currentL=changeLMulti(data,mc);
            proposedL=changeLMulti(data,mp);
            acceptance=q*exp(proposedL-currentL);
        else
            [mp,q]=deathChangePoint(mc,data);
            currentL=changeLMulti(data,mc);
            proposedL=changeLMulti(data,mp);
            acceptance=1/q*exp(proposedL-currentL);
        end
    end

    
    if (1<(acceptance))
        mc=mp;
        currentL=proposedL;
        if(i>burnin)
            mA{i}.count=mc{1};
            mA{i}.locations=mc{2};
            mA{i}.means=mc{3};
            mA{i}.noise=mc{4};
        end
    else
        if unifrnd(0,1,1)<(acceptance)
                 mc=mp;  
                 currentL=proposedL;
            if(i>burnin)
                mA{i}.count=mc{1};
                mA{i}.locations=mc{2};
                mA{i}.means=mc{3};
                mA{i}.noise=mc{4};
            end
        end
        
    end
    


    ll(i)=currentL;
    ns(i)=mc{1};
    sigma(i,:)=mc{4};

    if (mod(i,frameskip)==0)     
        if ~supressVideo
            plotChangePoint(mc, data, ll, sigma, iterations, i, dimensions, ns)      
            frame = getframe(gcf);
            writeVideo(writerObj, frame);
        end
        timestep=toc;
        timeToFinish=timestep*(iterations-i)/frameskip;
        disp(strcat('Iteration',{' '},num2str(i),'. Last',{' '},num2str(frameskip),{' '},'iterations completed in',{' '},num2str(round(timestep))...
            ,{' '},'seconds.',{' '}, ...
        'Estimated time remaining:',{' '},num2str(round(timeToFinish/60)),{' '},'minutes.'));
    tic
    end
end
if ~supressVideo
    close(writerObj);
end

disp('Starting post processing...')
clear index

resolution=1000;
dimensions=linspace(0,data(end,end),resolution);
index=arrayfun(@(x) (~isnan(mA{x}.locations(1))),burnin:iterations,'UniformOutput',false); %accepted index
index=cell2mat(index); %accepted index %post burnin index
tester=[burnin:iterations]; %post burnin index
indexing=tester(index);

number=length(indexing);
clear compModel

compModel.mData=zeros(resolution,size(data,2)-1,length(indexing));
for i=1:number;
    mTemp{1}=mA{indexing(i)}.count;
    mTemp{2}=mA{indexing(i)}.locations;
    mTemp{3}=mA{indexing(i)}.means;
    mTemp{4}=mA{indexing(i)}.noise;
    mTemp{5}=dimensions;
    compModel.mData(:,:,i)=changeMValueMulti(mTemp,dimensions);
    compModel.LL(i)=ll(indexing(i));
    compModel.n(i)=mTemp{1};
    compModel.sigma(:,i)=mTemp{4};
end


compModel.locations=[];
compModel.locations=[compModel.locations cell2mat(arrayfun(@(x) mA{x}.locations(1:length(mA{x}.locations)),indexing,'UniformOutput',false))'];


compModel.mData=sort(compModel.mData,3);

temp=arrayfun(@(x) compModel.mData(:,:,x)*compModel.LL(x),1:number,'UniformOutput',false);
temp2=zeros(resolution,size(data,2)-1,number);
for i=1:number
    temp2(:,:,i)=cell2mat(temp(i));  
end
compModel.mFit=sum(temp2,3)/sum(compModel.LL);

bounds=[.02 .03];
compModel.mFitLow=sum(compModel.mData(:,:,round(bounds(1)*number):round(bounds(2)*number)),3)/(round(bounds(2)*number)-round(bounds(1)*number));
compModel.mFitHigh=sum(compModel.mData(:,:,end-round(bounds(2)*number):end-round(bounds(1)*number)),3)/(round(bounds(2)*number)-round(bounds(1)*number));
compModel.data=data;
disp('Done!')
end

