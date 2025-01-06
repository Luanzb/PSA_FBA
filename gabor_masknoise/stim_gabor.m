function   [gabortex, propertiesMat] = stim_gabor(win,gabor)

%--------------------
% Gabor information
%--------------------

% gaborDimPix = info.scr_rect(4)/2 % commented pq joguei no script de infos
% gabor.freq = gabor.numCycles/gaborDimPix; %freq_pix;

% Sigma of Gaussian
sigma = gabor.DimPix / 6;%1000%  1000 p mostrar sem gaussiana e contar cycles

% Build a procedural gabor texture (Note: to get a "standard" Gabor patch
% we set a grey background offset, disable normalisation, and set a
% pre-contrast multiplier of 0.5).
backgroundOffset = [0.5 0.5 0.5 0.0];
disableNorm = 1;
preContrastMultiplier = 0.5;
gabortex = CreateProceduralGabor(win, gabor.DimPix, gabor.DimPix, [],...
    backgroundOffset, disableNorm, preContrastMultiplier);


% Randomise the phase of the Gabors and make a properties matrix.
propertiesMat = [gabor.phase, gabor.freq, sigma, gabor.contrast, gabor.aspectRatio, 0, 0, 0];


end

