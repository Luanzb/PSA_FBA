orientation(trl.targ_ori(:,1)==315,1) = 1;
orientation(trl.targ_ori(:,1)==45,1) = 2;

response = resp(:,5) & orientation(:,1);


%%
matrix = [info.matrix(61:420,:); info.matrix(481:end,:)];
resp2 =  [resp(61:420,:); resp(481:end,:)];

value = size(matrix,1);


% prehits val high prob.
hits1 = resp2(matrix(1:value,4) == 0 & matrix(1:value,1)==1 & response(1:value,1) == 1,1);
% prehits val low prob
hits2 = resp2(matrix(1:value,4) == 0 & matrix(1:value,1)==2 & response(1:value,1) == 1,1);
% prehits inval high prob
hits3 = resp2(matrix(1:value,4) == 0 & matrix(1:value,1)==3 & response(1:value,1) == 1,1);
% prehits inval low prob
hits4 = resp2(matrix(1:value,4) == 0 & matrix(1:value,1)==4 & response(1:value,1) == 1,1);
%--------------------------------------------------------------------------
%pre FA val high prob
fa1 = resp2(matrix(1:value,4) == 1 & matrix(1:value,1) == 1,2); 
% pre FA val low prob
fa2 = resp2(matrix(1:value,4) == 1 & matrix(1:value,1) == 2,2); 
fa_val = [fa1;fa2];

%pre FA inval high prob
fa3 = resp2(matrix(1:value,4) == 1 & matrix(1:value,1) == 3,2); 
% pre FA inval low prob
fa4 = resp2(matrix(1:value,4) == 1 & matrix(1:value,1) == 4,2); 
fa_inval = [fa3;fa4];
%--------------------------------------------------------------------------
%pre correct rejection saccade
cr1 = resp2(matrix(1:value,4) == 1 & matrix(1:value,1) == 1,3); 
cr2 = resp2(matrix(1:value,4) == 1 & matrix(1:value,1) == 2,3); 
cr_val = [cr1;cr2];

%pre correct rejection fixation
cr3 = resp2(matrix(1:value,4) == 1 & matrix(1:value,1) == 3,3); 
cr4 = resp2(matrix(1:value,4) == 1 & matrix(1:value,1) == 4,3); 
cr_inval = [cr3;cr4];
%--------------------------------------------------------------------------


miss1 = resp2(matrix(1:value,4) == 0 & matrix(1:value,1)==1,4);
miss2 = resp2(matrix(1:value,4) == 0 & matrix(1:value,1)==2,4);
miss3 = resp2(matrix(1:value,4) == 0 & matrix(1:value,1)==3,4);
miss4 = resp2(matrix(1:value,4) == 0 & matrix(1:value,1)==4,4);


%%
hits11 = sum(hits1) / (sum(hits1) + sum(miss1));
hits22 = sum(hits2) / (sum(hits2) + sum(miss2));
hits33 = sum(hits3) / (sum(hits3) + sum(miss3));
hits44 = sum(hits4) / (sum(hits4) + sum(miss4));

fa_sac2 = sum(fa_val) / (sum(fa_val) + sum(cr_val));
fa_fix2 = sum(fa_inval) / (sum(fa_inval) + sum(cr_inval));


%%
pal_path = '/home/kaneda/Documents/Palamedes1_11_11/Palamedes';
addpath(genpath(pal_path));

pHF = [hits11 fa_sac2;hits22 fa_sac2; hits33 fa_fix2; hits44 fa_fix2];

% pHF = [mean([hits11 hits111]) mean([fa_sac2 fa_sac22])
%        mean([hits22 hits222]) mean([fa_sac2 fa_sac22])
%        mean([hits33 hits333]) mean([fa_fix2 fa_fix22])
%        mean([hits44 hits444]) mean([fa_fix2 fa_fix22])];


[dP C lnB pC]=PAL_SDT_1AFC_PHFtoDP(pHF);

pH=pHF(:,1);
pF=pHF(:,2);

SDM=[pH';pF';dP';pC';C';lnB'];
SDM=SDM';

fprintf('\n');
disp('     pHit      pFA      d-prime   p Corr    crit C    crit lnB');
disp(SDM);
