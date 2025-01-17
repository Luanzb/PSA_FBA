function [resp,PEST] = Stair_On_Screen(info,trl,gabor,mask,sub,mat)
% First column = Hits;
% Second column = False Alarms
% Third column =  Correct rejections
% fourth column = Miss
resp = zeros(60,4);

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

[PEST] = PEST_setup(info);

  if sub.Staircase == 'V'
       targ_ori = 1;
  elseif sub.Staircase == 'H'
      targ_ori = 2;
  end

try

    for session = 1:info.ntrials

         if mat(targ_ori).matrix(session,3) == 0
             [gabor] = PEST_alpha_update(gabor,PEST);
         end

        [gabortex, propertiesMat] = stim_gabor(win,gabor);


        % Cria Mask (White Noise patch)
        texMask1 = mask_noise(win, mask, info);
        texMask2 = mask_noise(win, mask, info);

        texMask = [texMask1; texMask2];


        if session == 1
            txt_ = '-----------------------';  txt3 = 'Pressione o botão space para iniciar';
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

                    Screen('DrawLine', win, info.black_idx, info.scr_xcenter,info.scr_ycenter ...
                        ,info.scr_xcenter - info.cue_length_px,info.scr_ycenter, info.cue_width_px);
                    Screen('DrawLine', win, info.black_idx, info.scr_xcenter,info.scr_ycenter ...
                        ,info.scr_xcenter + info.cue_length_px,info.scr_ycenter, info.cue_width_px);

            end

            % DRAW FIXATION POINT AND PLACEHOLDERS
            Screen('DrawDots', win, [info.scr_xcenter info.scr_ycenter], info.dot_size_pix*2, info.black_idx, [], 2,1);
            Screen('DrawDots', win, [info.scr_xcenter info.scr_ycenter], info.dot_size_pix, info.white_idx, [], 2,1);
            Screen('DrawDots',win,info.pholdercoordL,info.dot_size_pix,info.black_idx,[],2,1);
            Screen('DrawDots',win,info.pholdercoordR,info.dot_size_pix,info.black_idx,[],2,1);

            % SHOW TARGET if this trial isn't catch
            if mat(targ_ori).matrix(session,3) == 0
                if trial >= trl.targ_on(session,1) && trial <= trl.targ_off(session,1)

                    if mat(targ_ori).matrix(session,2) == 1
                        Screen('BlendFunction', win, 'GL_ONE', 'GL_ZERO');
                        Screen('DrawTextures', win, gabortex, [], info.coordL, trl.targ_ori(session,targ_ori),...
                            0, 1, [], [], kPsychDontDoRotation, propertiesMat');
                    else
                        Screen('BlendFunction', win, 'GL_ONE', 'GL_ZERO');
                        Screen('DrawTextures', win, gabortex, [], info.coordR, trl.targ_ori(session,targ_ori),...
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

            %             if trial == trl.targ_on(session,1)
            %                 current_display = Screen('GetImage',win);
            %                 imwrite(current_display, 'target.png');
            %             end

        end

        % DRAW FIXATION POINT AND PLACEHOLDERS
        Screen('DrawDots', win, [info.scr_xcenter info.scr_ycenter], info.dot_size_pix*2, info.black_idx, [], 2,1);
        Screen('DrawDots', win, [info.scr_xcenter info.scr_ycenter], info.dot_size_pix, info.white_idx, [], 2,1);

        if mat(targ_ori).matrix(session,2) == 1
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
        if response == 1 && mat(targ_ori).matrix(session,3) == 0 % Hit
            resp(session,1) = 1;
        elseif response == 1 && mat(targ_ori).matrix(session,3) == 1 % False alarm
            resp(session,2) = 1;
        elseif response == 0 && mat(targ_ori).matrix(session,3) == 1 % Correct Rejection
            resp(session,3) = 1;
        elseif response == 0 && mat(targ_ori).matrix(session,3) == 0 % Miss
            resp(session,4) = 1;
        end


        % update staircase value if the current trial had a target
        if mat(targ_ori).matrix(session,3) == 0
            if response == 1
                outcome = 1;
            else
                outcome = 0;
            end

            [info,PEST] = PEST_update(info,PEST,outcome);

        end


    end


    Screen('CloseAll');

catch


end


end