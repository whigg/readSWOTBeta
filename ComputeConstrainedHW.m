%compute constrained width and height data for one reach or node

function [Wcon,Hcon,igood,dAhat] = ComputeConstrainedHW(Hobs,Wobs,nReg,stdH,stdW,MakePlot)

igood=(~isnan(Wobs) & ~isnan(Hobs));
nObs=sum(igood);

Hobs=Hobs(igood); Wobs=Wobs(igood);

[p,xbreak,iout,hval,wval]=CalcWHFitsEIV(Hobs,Wobs,nReg,stdH,stdW);        

if MakePlot
    figure
    errorbar(Hobs,Wobs,stdW*ones(nObs,1),stdW*ones(nObs,1),stdH*ones(nObs,1),stdH*ones(nObs,1),'LineStyle','none','LineWidth',2,'Marker','o'); hold on
    plot(hval,wval,'LineWidth',2)
    a=axis;
    for i=1:length(xbreak)
        plot(xbreak(i)*ones(2,1),a(3:4),'g-')
    end
    plot(Hobs(iout),Wobs(iout),'kx','MarkerSize',12,'LineWidth',2)
    hold off;
    set(gca,'FontSize',14)
    xlabel('Water surface elevation, m')
    ylabel('River width, m')
    title('Height-width fits & obs.')
    grid on
end

Hbar=median(Hobs); 
Wbar=median(Wobs);

m_zz=cov(Wobs,Hobs);

dAHbar=CalculatedAEIV(Hbar,Wbar,xbreak,p,nReg,0,stdW^2,stdH^2,m_zz,nObs); %sample calculation

for i=1:nObs
    [dAhat(i),Wcon(i),Hcon(i),dAunc(i)] = CalculatedAEIV(Hobs(i),Wobs(i),xbreak,p,nReg,dAHbar,stdW^2,stdH^2,m_zz,nObs);
end

end