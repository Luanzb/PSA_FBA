
function [info] = PEST_info(info)
% Best PEST PARAMETERS
grain = 200;
info.PEST_prior_alpha_range = linspace(0,1,grain);
info.PEST_PF = @PAL_Gumbel;
info.PEST_xmax = 1;
info.PEST_xmin = 0;
info.PEST_mean_mode = 'mean';
info.PEST_beta = 2;
info.PEST_gamma = 0.5;
info.PEST_lambda = 0.01;
info.PEST_stop_criterion = 'trials';   
info.PEST_stop_rule = 40; % mudar esse valor após definir numero de tnetativas por condição.
%info.PEST_startValue = 0.85;

end
