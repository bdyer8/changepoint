function plotChangePoint( mc, data, ll, sigma, iterations, i, dimensions, ns )
    rng(95)
    colors=(rand(size(data,2)-1,3));
    rng('shuffle')
    subplot(4,1,1);
    modelData=changeMValueMulti(mc,dimensions);
    dimensions=linspace(min(mc{5}),max(mc{5}),10000);
    hold off
    for k=1:size(data,2)-1
    plot(data(:,end),data(:,k),'.','Color',colors(k,:))
    hold on
    plot(dimensions,modelData(:,k),'Color',colors(k,:))
    end
    
    subplot(4,1,2);
    hold off
    plot(1:1:iterations,(ll));

    subplot(4,1,3);
    hold off
    for k=1:size(data,2)-1
        plot(1:iterations,sigma(:,k),'Color',colors(k,:));
    hold on
    end
    
    formatPlot(gca,'iteration','\sigma',strcat('timestep:',num2str(i)));   
    axis([1 iterations 0 1])
    
    subplot(4,1,4);
    hold off
    plot(1:iterations,ns,'b');
    formatPlot(gca,'iteration','N',strcat('timestep:',num2str(i)));   
    axis([1 iterations 0 round(size(data,1)/2)])
end



