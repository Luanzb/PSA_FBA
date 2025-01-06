function [info,PEST] = PEST_update(info,PEST,outcome)

  PEST = PAL_AMRF_updateRF(PEST, PEST.xCurrent, outcome);

end