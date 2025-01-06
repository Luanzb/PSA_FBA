
function PEST_analysis(PEST,resp)



titulo = {'PEST - SOA for Saccade Condition'};
%

set(gca,'TickDir','out');
ylim([0 1]);hold on;
set(gca,'YTickLabel',0:0.2:1);
hold on;
title(titulo);

t = 1:length(PEST.x);
plot(t,PEST.x,'k');
hold on;
plot(t(PEST.response == 1),PEST.x(PEST.response == 1),'ko', 'MarkerFaceColor','k');
plot(t(PEST.response == 0),PEST.x(PEST.response == 0),'ko', 'MarkerFaceColor','w');

yline(0.5,'--');
xlabel('Trial',FontWeight='bold');
ylabel('Contrast','FontWeight','bold');

format long
txt = sprintf('Mean: %d',PEST.mean);
text(5, 0.7,txt);

ylim([0 1]);hold on;
set(gca,'YTickLabel',0:0.1:1);
hold on;

%% calculate d' prime
hits1 = resp(:,1);
fa1 = resp(:,2);
cr1 = resp(:,3);
miss1 = resp(:,4);

hits11 = sum(hits1) / (sum(hits1) + sum(miss1));

fa11 = sum(fa1) / (sum(fa1) + sum(cr1));

pHF = [hits11 fa11];
[dP, C, lnB, pC]=PAL_SDT_1AFC_PHFtoDP(pHF);

pH=pHF(:,1);
pF=pHF(:,2);

SDM=[pH';pF';dP';pC';C';lnB'];
SDM=SDM';

format short 

fprintf('\n');
disp('     pHit      pFA      d-prime   p Corr    crit C    crit lnB');
disp(SDM);

if (pH - pF) >= .3
    disp('Aceitar limiar. Baixo FA rate');
else
    disp('Rejeitar limiar. Alto FA rate');
end



end
