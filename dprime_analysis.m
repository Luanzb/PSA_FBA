hits1 = resp(info.matrix(:,1)==1,1);
hits2 = resp(info.matrix(:,1)==2,1);
hits3 = resp(info.matrix(:,1)==3,1);
hits4 = resp(info.matrix(:,1)==4,1);

fa1 = resp(info.matrix(:,1)==1,2);
fa2 = resp(info.matrix(:,1)==2,2);
fa3 = resp(info.matrix(:,1)==3,2);
fa4 = resp(info.matrix(:,1)==4,2);

miss1 = resp(info.matrix(:,1)==1,4);
miss2 = resp(info.matrix(:,1)==2,4);
miss3 = resp(info.matrix(:,1)==3,4);
miss4 = resp(info.matrix(:,1)==4,4);

cr1 = resp(info.matrix(:,1)==1,3);
cr2 = resp(info.matrix(:,1)==2,3);
cr3 = resp(info.matrix(:,1)==3,3);
cr4 = resp(info.matrix(:,1)==4,3);

%%
hits11 = sum(hits1) / (sum(hits1) + sum(miss1));
hits22 = sum(hits2) / (sum(hits2) + sum(miss2));
hits33 = sum(hits3) / (sum(hits3) + sum(miss3));
hits44 = sum(hits4) / (sum(hits4) + sum(miss4));

fa11 = sum(fa1) / (sum(fa1) + sum(cr1));
fa22 = sum(fa2) / (sum(fa2) + sum(cr2));
fa33 = sum(fa3) / (sum(fa3) + sum(cr3));
fa44 = sum(fa4) / (sum(fa4) + sum(cr4));

%%

pHF = [hits11 fa11;hits22 fa22;hits33 fa33;hits44 fa44];
[dP C lnB pC]=PAL_SDT_1AFC_PHFtoDP(pHF);

pH=pHF(:,1);
pF=pHF(:,2);

SDM=[pH';pF';dP';pC';C';lnB'];
SDM=SDM';

fprintf('\n');
disp('     pHit      pFA      d-prime   p Corr    crit C    crit lnB');
disp(SDM);

