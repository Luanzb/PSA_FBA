function [resp] = On_Screen(info,trl,sub,gabor,mask)
% First column = Hits;
% Second column = False Alarms
% Third column =  Correct rejections
% fourth column = Miss
resp = zeros(400,4);

%% Screen setup
PsychDefaultSetup(2);% default settings for setting up Psychtoolbox

Screen('Preference', 'SyncTestSettings', 0.01, 50, 0.25);
Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference', 'Verbosity', 0);
Screen('Preference', 'SkipSyncTests', 1);

% Define black and white (white== 1 and black, 0).
info.white_idx = WhiteIndex(info.scr_num);
info.black_idx = BlackIndex(info.scr_num);
info.gray_idx = info.white_idx/2;

[win, info.scr_rect] = PsychImaging('OpenWindow', info.scr_num, info.gray_idx, [], 32, 2, [], []); % RODA EM TELA TODA


block_counter = 0;

if trl.feature_ses(sub.ses_num,1) == 1
    ex_img = imread('D:/PSA_FBA/Images/target_VL.png');
else
    ex_img = imread('D:/PSA_FBA/Images/target_HL.png');
end
ex_tex = Screen('MakeTexture', win, ex_img); clear ex_img;

try

    for session = 1:info.ntrials

        % Cria gabor patch com contrast especifico para H e V.
        if info.matrix(session,2) == 1; gabor.contrast = sub.targ_V;
        else; gabor.contrast = sub.targ_H; end
        [gabortex, propertiesMat] = stim_gabor(win,gabor);


        % Cria Mask (White Noise patch)
        texMask1 = mask_noise(win, mask, info);
        texMask2 = mask_noise(win, mask, info);

        texMask = [texMask1; texMask2];


        if trl.onset_blocks(session,1) == 1

            block_counter = block_counter + 1;

            Screen('DrawTexture', win, ex_tex, [], [], 0);

            txt_ = '-----------------------'; txt1 = sprintf('Bloco %d/%d', block_counter, sum(trl.onset_blocks));
            txt2 = 'Atenção ao local de apresentação dos estimulos'; txt3 = 'Pressione o botão space para iniciar';
            DrawFormattedText(win, [txt1 '\n\n' txt_ '\n\n' txt2 '\n\n' txt_ txt_ txt_], 'center', info.scr_ycenter - 250, info.black_idx);
            DrawFormattedText(win, [txt3 '\n\n' txt_ txt_ txt_], 'center', info.scr_ycenter + 125, info.black_idx);

            Screen('Flip', win);

            respToBeMade = true;
            while respToBeMade
                [~,~,keyCode] = KbCheck;
                if keyCode(info.escapeKey)
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(info.space)
                    respToBeMade = false;
                end
            end


        end


        % DRAW FIXATION POINT in red FOR 500 MS BEFORE TRIAL ONSET.
        Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
        Screen('DrawDots', win, [info.scr_xcenter info.scr_ycenter], info.dot_size_pix*2, info.black_idx, [], 2,1);
        Screen('DrawDots', win, [info.scr_xcenter info.scr_ycenter], info.dot_size_pix, [1 0 0], [], 2,1);
        Screen('DrawDots',win,info.pholdercoordL,info.dot_size_pix,info.black_idx,[],2,1);
        Screen('DrawDots',win,info.pholdercoordR,info.dot_size_pix,info.black_idx,[],2,1);
        Screen('Flip', win);
        WaitSecs(.5);

        for trial = 1:trl.wnoise_off(session,1) % TRIAL WILL END 200 MS AFTER TARG OFF (mask off)


            Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

            % CUE ONSET
            if trial >= trl.cue_on(session,1) && trial <= trl.cue_off(session,1)

                if info.matrix(session,4) == 1
                    Screen('DrawLine', win, info.black_idx, info.scr_xcenter,info.scr_ycenter ...
                        ,info.scr_xcenter - info.cue_length_px,info.scr_ycenter, info.cue_width_px);
                else
                    Screen('DrawLine', win, info.black_idx, info.scr_xcenter,info.scr_ycenter ...
                        ,info.scr_xcenter + info.cue_length_px,info.scr_ycenter, info.cue_width_px);
                end
            end

            % DRAW FIXATION POINT AND PLACEHOLDERS
            Screen('DrawDots', win, [info.scr_xcenter info.scr_ycenter], info.dot_size_pix*2, info.black_idx, [], 2,1);
            Screen('DrawDots', win, [info.scr_xcenter info.scr_ycenter], info.dot_size_pix, info.white_idx, [], 2,1);
            Screen('DrawDots',win,info.pholdercoordL,info.dot_size_pix,info.black_idx,[],2,1);
            Screen('DrawDots',win,info.pholdercoordR,info.dot_size_pix,info.black_idx,[],2,1);

            % SHOW TARGET if this trial isn't catch
            if info.matrix(session,5) == 0
                if trial >= trl.targ_on(session,1) && trial <= trl.targ_off(session,1)

                    if info.matrix(session,3) == 1
                        Screen('BlendFunction', win, 'GL_ONE', 'GL_ZERO');
                        Screen('DrawTextures', win, gabortex, [], info.coordL, trl.targ_ori(session),...
                            0, 1, [], [], kPsychDontDoRotation, propertiesMat');
                    else
                        Screen('BlendFunction', win, 'GL_ONE', 'GL_ZERO');
                        Screen('DrawTextures', win, gabortex, [], info.coordR, trl.targ_ori(session),...
                            0, 1, [], [], kPsychDontDoRotation, propertiesMat');
                    end
                end
            end

            % Draw noise patches
            if trial >= trl.wnoise_on(session,1) && trial <= trl.wnoise_off(session,1)

                Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
                Screen('DrawTextures',win,texMask,[],[info.coordL info.coordR],0,[],[]);


            end

            Screen('Flip', win);

%                         if trial == trl.targ_on(session,1)+2
%                             current_display = Screen('GetImage',win);
%                             imwrite(current_display, 'target_HL.png');
%                         end

        end

        % DRAW FIXATION POINT AND PLACEHOLDERS
        Screen('DrawDots', win, [info.scr_xcenter info.scr_ycenter], info.dot_size_pix*2, info.black_idx, [], 2,1);
        Screen('DrawDots', win, [info.scr_xcenter info.scr_ycenter], info.dot_size_pix, info.white_idx, [], 2,1);

        if info.matrix(session,3) == 1
            Screen('DrawDots',win,info.pholdercoordL,info.dot_size_pix*2,info.black_idx,[],2,1);
            Screen('DrawDots',win,info.pholdercoordR,info.dot_size_pix,info.black_idx,[],2,1);
        else
            Screen('DrawDots',win,info.pholdercoordL,info.dot_size_pix,info.black_idx,[],2,1);
            Screen('DrawDots',win,info.pholdercoordR,info.dot_size_pix*2,info.black_idx,[],2,1);
        end


        Screen('Flip', win);

        respToBeMade = true;
        while respToBeMade
            [~,~,keyCode] = KbCheck;
            if keyCode(info.escapeKey)
                ShowCursor;
                sca;
                return
            elseif keyCode(info.s)
                response = 1;
                respToBeMade = false;
            elseif keyCode(info.n)
                response = 0;
                respToBeMade = false;
            end
        end

        % Colect answer for each trial.
        if response == 1 && info.matrix(session,5) == 0 % Hit
            resp(session,1) = 1;
        elseif response == 1 && info.matrix(session,5) == 1 % False alarm
            resp(session,2) = 1;
        elseif response == 0 && info.matrix(session,5) == 1 % Correct Rejection
            resp(session,3) = 1;
        elseif response == 0 && info.matrix(session,5) == 0 % Miss
            resp(session,4) = 1;
        end


        if trl.onset_blocks(session+1,1) == 1 || session == size(trl.onset_blocks,1)
            if session == size(trl.onset_blocks,1)
                txt = 'Voce completou todos os blocos da sessão. \n\n Parabéns!';
                DrawFormattedText(win, txt, 'center', info.scr_ycenter - 250, info.black_idx);
            elseif trl.onset_blocks(session+1,1) == 1
                txt = sprintf('Bloco %i/%i completo.\n\n Hora do descanso \n\n --- Pressione o botão space para continuar ---', block_counter, sum(trl.onset_blocks));
                DrawFormattedText(win, txt, 'center', info.scr_ycenter, info.black_idx);
            end
            Screen('Flip', win);

            respToBeMade = true;
            while respToBeMade
                [~,~,keyCode] = KbCheck;
                if keyCode(info.escapeKey)
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(info.space)
                    respToBeMade = false;
                end
            end

        end


    end


    Screen('CloseAll');

catch


end


end