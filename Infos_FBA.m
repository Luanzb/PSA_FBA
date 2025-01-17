
git_path = '/home/kaneda/Documents/GitHub/PSA_FBA';
addpath(genpath(git_path));

pc_path = '/home/kaneda/Documents/GitHub/Subjects';
addpath(genpath(pc_path));

% Ask subject number
answer = inputdlg({'Numero voluntario'}, '', [1 25]);
sub.id = answer{1}; sub.id_num = str2double(answer{1});


%% INFORMAÇÕES SOBRE O TECLADO
KbName('UnifyKeyNames');
info.escapeKey = KbName('ESCAPE');
info.s         = KbName('S');
info.n         = KbName('N');
info.space     = KbName('space');
%% Screen setup
Screen('Preference', 'SyncTestSettings', 0.01, 50, 0.25);
Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference', 'Verbosity', 0);
Screen('Preference', 'SkipSyncTests', 1);

% Seed the random number generator. Here we use an older way to be
% compatible with older systems.
rng('shuffle')

screens = Screen('Screens');% Get the screen numbers.
info.scr_num = min(screens);% draw to the externalscreen.

% Define black and white (white== 1 and black, 0).
info.white_idx = WhiteIndex(info.scr_num);
info.black_idx = BlackIndex(info.scr_num);
info.gray_idx = info.white_idx/2;

% Open an screen window
[win, info.scr_rect] = PsychImaging('OpenWindow', info.scr_num, info.gray_idx, [], 32, 2, [], []); % RODA EM TELA TODA

% Inter-flip interval
info.scr_ifi = Screen('GetFlipInterval', win);

sca; clc;

info.ntrials = 400;

%% Get the size of the screen window in pixels

[scr_xsize_mm, scr_ysize_mm] = Screen('DisplaySize', info.scr_num);
info.scr_xsize_cm = scr_xsize_mm/10;
info.scr_ysize_cm = scr_ysize_mm/10;
% Screen size in pixels
%or, by:[scrX,scrY] = Screen('WindowSize',info.scr_num); % in  pixels
info.scr_xsize = info.scr_rect(3);
info.scr_ysize = info.scr_rect(4);

% Centre coordinate of the window
[info.scr_xcenter, info.scr_ycenter] = RectCenter(info.scr_rect); % in pixels
info.scr_rrate = round(1/info.scr_ifi);     % Refresh rate
info.scr_dist_cm = 57;          % Viewing distance from screen (cm)

%% Gabor INFOS

gabor.rad = 1; %0.8;%1.4; %(radius in dva)
gabor.radPix = round(dva2pix(info.scr_dist_cm, info.scr_xsize_cm, info.scr_xsize, gabor.rad));

gabor.orientation = [0 90]; % all possibilities: 1:cw; 2:ccw

gabor.contrast = .1; %0.8;
gabor.aspectRatio = 1.0;
gabor.phase = 0;

% Spatial Frequency (Cycles Per Pixel)
% One Cycle = Grey-Black-Grey-White-Grey i.e. One Black and One White Lobe
gabor.numCycles = 5;%6;%3 % para computar 'cycles/pixels'
gabor.DimPix = info.scr_rect(4)/2;
gabor.freq = gabor.numCycles/gabor.DimPix;%freq_pix;

%% infos Mask (white noise mask) do script da nina hanning

mask.rad       = gabor.radPix;%30;               % item radius
mask.pixpc     = 7.6;%10;               % gabor frequency (in pixels per cycle; e.g. 10 for 1 cicle per 10 pixel)
mask.sigma_period      = 0.9;
mask.sigma             = mask.pixpc*mask.sigma_period;
mask.noisePixSize      = mask.rad/5; %%%% GOOD PROXY? %%% was 5 before

%% Posicoes dos Gabors
info.EccDVA = 8; % target eccentricity
info.Ecc = round(dva2pix(info.scr_dist_cm,info.scr_xsize_cm,info.scr_xsize,info.EccDVA));

info.stimDim = gabor.radPix*2;

rectt = [0 0 info.stimDim info.stimDim];
coordL_gabor = info.scr_xcenter - info.Ecc;
coordR_gabor = info.scr_xcenter + info.Ecc;

info.coordL = CenterRectOnPoint(rectt,coordL_gabor,info.scr_ycenter)';   % posição gabor esquerda
info.coordR = CenterRectOnPoint(rectt,coordR_gabor,info.scr_ycenter)';   % posição gabor direita


%% Infos Fixation Dot
info.dot_size_dva = 0.3;        % fixation Dot diameter
info.dot_size_pix = round(dva2pix(info.scr_dist_cm, info.scr_xsize_cm, info.scr_xsize, info.dot_size_dva));

%% Infos Saccade_Cue
info.cue_width_dva = 0.15; % saccade cue width in dva
info.cue_length_dva = 0.7; % saccade cue length in dva

info.cue_width_px = round(dva2pix(info.scr_dist_cm, info.scr_xsize_cm, info.scr_xsize, info.cue_width_dva));% saccade cue width converted to pixels
info.cue_length_px = round(dva2pix(info.scr_dist_cm, info.scr_xsize_cm, info.scr_xsize, info.cue_length_dva)); % saccade cue length converted to pixels

%% PLACEHOLDERS INFOS

info.pholder_size_dva = 0.3;       % tamanho placeholders
info.dist_pholder_y_perto_dva     = 1.415; %2;       % excent. dos pholders em relação ao centro do eixo y.
info.dist_pholder_x_perto_dva     = 8-1.415; %6;        % excent. placeholder mais perto em relação ao eixo x
info.dist_pholder_x_longe_dva     = 8+1.415; %10;       % excent. placeholder mais distante em relação ao eixo x

info.pholder_size_px     = dva2pix(info.scr_dist_cm, info.scr_xsize_cm, info.scr_xsize,info.pholder_size_dva);
info.dist_pholder_y_perto_px     = dva2pix(info.scr_dist_cm, info.scr_xsize_cm, info.scr_xsize,info.dist_pholder_y_perto_dva);
info.dist_pholder_x_perto_px     = dva2pix(info.scr_dist_cm, info.scr_xsize_cm, info.scr_xsize,info.dist_pholder_x_perto_dva);
info.dist_pholder_x_longe_px    = dva2pix(info.scr_dist_cm, info.scr_xsize_cm, info.scr_xsize,info.dist_pholder_x_longe_dva);

% define posição de apresentação dos estímulos
y1 = info.scr_ycenter - info.dist_pholder_y_perto_px;
y2 = info.scr_ycenter + info.dist_pholder_y_perto_px;

x3  = info.scr_xcenter - info.dist_pholder_x_perto_px; % pholder perto esquerda
x3a = info.scr_xcenter - info.dist_pholder_x_longe_px; % pholder distante esquerda
x4  = info.scr_xcenter + info.dist_pholder_x_perto_px; % pholder perto direita
x4a = info.scr_xcenter + info.dist_pholder_x_longe_px; % pholder distante direita

info.pholdercoordL = [x3,  x3a, x3,  x3a; y2, y2, y1, y1];  % coordenadas pista lado esquerdo
info.pholdercoordR = [x4,  x4a, x4,  x4a; y2, y2, y1, y1];  % coord pista lado direito

%%
% There are four conditions: saccade congruent (SC) and incongruent (SI) and feature
% congruent (FC) and incongruent (FI).

% 1 = SC + FC
% 2 = SI + FC
% 3 = SC + FI
% 4 = SI + FI

condition1 = [repelem(1,85) repelem(2,85) repelem(3,15) repelem(4,15)]';
condition = repmat(condition1',1,2)';

% catch trials
catch_trl1 = zeros(200,1);
catch_trl1(81:85,1) = 1;
catch_trl1(166:170,1) = 1;
catch_trl1(181:185,1) = 1;
catch_trl1(196:200,1) = 1;

catch_trl = repmat(catch_trl1',1,2)';

% vertical gabor more prone on the left (80%)
stim_left_v = repelem(1,170)';
stim_right_v = repelem(2,30)';

% horizontal gabor more prone on the right (80%)
stim_left_h = repelem(2,170)';
stim_right_h = repelem(1,30)';

% saccade side (50% for each side).
sacc_side1 = [repelem([1 2],85)'; repelem([2 1],15)'];
sacc_side2 = [repelem([2 1],85)'; repelem([1 2],15)'];

feature_type = repelem([1 2], 200)';

stimulus_side = [stim_left_v; stim_right_v; stim_left_h; stim_right_h];
saccade_side = [sacc_side1; sacc_side2];

%        conditions 1:4    feature      targ side       sacc side       catch trials
%           see above      1 = verti    1 = left        1 = left        0 = no catch
%                          2 = hori     2 = right       2 = right       1 = catch

matrix = [condition     feature_type   stimulus_side   saccade_side   catch_trl];


% There will be three sessions in total. each session will have an
% orientation more prone to appear on each side of the screen. For
% instance, in a given session, most of the gabor targets on the left will
% have vertical orientation, while most on the right will have horizontal
% orientation.
% The orientation more prone on each side for each session is defined below.
% Subjects with odd number will have the first session with more vertical
% on the left and more horizontal on the right. In the second session this
% will invert and on the third will be the same as the first session. For
% even subjects number, the first session will be horizontal (left) and
% vertical (right).

if rem(sub.id_num,2) == 1
    trl.feature_ses = [1 2;2 1;1 2];
else
    trl.feature_ses = [2 1; 1 2; 2 1];
end

% create matrix of trials for each session, as well as timings for cue and
% target appearance and target orientation.

for session = 1:3

    matrix(1:200,2)   = trl.feature_ses(session,1);
    matrix(201:400,2) = trl.feature_ses(session,2);


    % randomize trials order within a given session. the loop below asures
    % that the first trial of each session is both sacade and feature
    % congruent.

    b = false;
    while b == false
        mat_rows = randperm(size(matrix,1));
        info.matrix =  matrix(mat_rows,:);
        if info.matrix(1,1) == 1
            b = true;
        end
    end


    %%
    % target orientation for each trial in a given session.
    trl.targ_ori(info.matrix(:,2)' == 1,1) = 0;      % vertical orientation
    trl.targ_ori(info.matrix(:,2)' == 2,1) = 90;     % horizontal orientation

    % ones mark the beginning of a block of trials.
    trl.onset_blocks = repmat([1 repelem(0,19)],1,20)';

    % defines trial onset and offset. the onsets are randomized to occur
    % between 500 (60 frames) - 900 (109 frames) ms after fixation onset to avoid temporal
    % expectation.
    trl.cue_on = randi([60 109],1,400)';
    trl.cue_off = trl.cue_on + 8; % cue offset after 75 ms

    trl.targ_on = trl.cue_on + 18; % presents the target 150ms after cue onset (SOA)
    trl.targ_off = trl.targ_on + 5; % it will stay on the screen for 50ms

    % White Noise timing based on target offset
    trl.wnoise_on  = trl.targ_off + 2;   % 16ms ms SOA wnoise-target
    trl.wnoise_off = trl.wnoise_on + 24; % 200 ms duration

    %% Create data directories

    if ~exist(sprintf('%s/Data/S%d/Task/', pc_path, sub.id_num), 'dir')
        mkdir(sprintf('%s/Data/S%d/Task/', pc_path, sub.id_num))
    end
    if ~exist(sprintf('%s/Data/S%d/Eye/', pc_path, sub.id_num), 'dir')
        mkdir(sprintf('%s/Data/S%d/Eye/', pc_path, sub.id_num))
    end


    %%
    %%% Save files

    % Save trials information
    sub.trlinfo_fname = sprintf('ses_%d_trlinfo_sub_%d_%s',session, sub.id_num, datestr(now,'yymmdd-HHMM')); %#ok<*TNOW1,*DATST>
    save(fullfile(sprintf('%s/Data/S%d/%s', pc_path, sub.id_num), [sub.trlinfo_fname, '.mat']), 'info', 'trl', 'sub','gabor','mask', '-v7.3');

    fprintf('Sessão_%d...',session)
    fprintf('\nFeito!\n')

end

