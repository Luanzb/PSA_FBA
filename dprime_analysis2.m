value = 400;

hits1 = resp(info.matrix(1:value,1)==1,1);
hits2 = resp(info.matrix(1:value,1)==2,1);
hits3 = resp(info.matrix(1:value,1)==3,1);
hits4 = resp(info.matrix(1:value,1)==4,1);

fa1 = resp(info.matrix(1:value,4) == 1,2);

miss1 = resp(info.matrix(1:value,1)==1,4);
miss2 = resp(info.matrix(1:value,1)==2,4);
miss3 = resp(info.matrix(1:value,1)==3,4);
miss4 = resp(info.matrix(1:value,1)==4,4);

cr1 = resp(info.matrix(1:value,4) == 1,3);

hits11 = [hits1;hits3];
hits22 = [hits2;hits4];

miss11 = [miss1;miss3];
miss22 = [miss2;miss4];


%%
hits111 = sum(hits11) / (sum(hits11) + sum(miss11));
hits222 = sum(hits22) / (sum(hits22) + sum(miss22));


fa2 = sum(fa1) / (sum(fa1) + sum(cr1));

%%

pHF = [hits111 fa2;hits222 fa2];
[dP C lnB pC]=PAL_SDT_1AFC_PHFtoDP(pHF);

pH=pHF(:,1);
pF=pHF(:,2);

SDM=[pH';pF';dP';pC';C';lnB'];
SDM=SDM';

fprintf('\n');
disp('     pHit      pFA      d-prime   p Corr    crit C    crit lnB');
disp(SDM);
