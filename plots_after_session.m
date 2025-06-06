
denplot = '/home/kaneda/Documents/Data density plot/';
addpath(genpath(denplot));

sacc_off = 300;
sacc_on = 170;
%%

if trl.repeated_blk(1,1) == 0 && trl.repeated_blk(1,2) == 0  
    macrosacvec2 = s.macrosacvec;
elseif trl.repeated_blk (1,1) == 1 && trl.repeated_blk (1,2) == 0
    macrosacvec2 = s.macrosacvec(61:end,:);
elseif trl.repeated_blk (1,1) == 0 && trl.repeated_blk (1,2) == 1
    macrosacvec2 = [s.macrosacvec(1:420,:); s.macrosacvec(481:end,:)];
elseif trl.repeated_blk (1,1) == 1 && trl.repeated_blk (1,2) == 1
    macrosacvec2 = [s.macrosacvec(61:420,:); s.macrosacvec(481:end,:)];    
end



cue_side = info.matrix(:,3);
cue_side(info.matrix(:,1)==3 & info.matrix(:,3)==1,1) = 2;
cue_side(info.matrix(:,1)==3 & info.matrix(:,3)==2,1) = 1;
cue_side(info.matrix(:,1)==4 & info.matrix(:,3)==1,1) = 2;
cue_side(info.matrix(:,1)==4 & info.matrix(:,3)==2,1) = 1;

sac_side = zeros(840,1);
sac_side(cue_side(:,1)==1 & macrosacvec2(:,4) < 0,1) = 1;
sac_side(cue_side(:,1)==2 & macrosacvec2(:,4) > 0,1) = 1;


% data filtered by saccade accuracy (saccade error <= 2.6)

sac_acc = hypot(info.EccDVA - abs(macrosacvec2(:,4)), abs(macrosacvec2(:,5))) >= 0 ...
    & hypot(info.EccDVA - abs(macrosacvec2(:,4)), abs(macrosacvec2(:,5))) <= 2.6;


% data filtered by saccade latencies between 165 and 350 ms.

sac_lat = macrosacvec2(:,1) >= sacc_on & macrosacvec2(:,1) <= sacc_off;

sac_offset = macrosacvec2(:,2) >= 200;

% create a vector of ones (non-rejected trials) and zeros
% (rejected trials) regarding saccade latency, side and accuracy.

sac1 = sac_lat(:,1)==1 & sac_side(:,1)==1 & sac_acc(:,1)==1 & sac_offset(:,1)==1;
sac = [sac1(61:420,:); sac1(481:end,:)];

%%


orientation(trl.targ_ori(:,1)==315,1) = 1; %#ok<*SAGROW>
orientation(trl.targ_ori(:,1)==45,1) = 2;

response2 = resp(:,5) & orientation(:,1);

response = [response2(61:420,:); response2(481:end,:)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matrix = [info.matrix(61:420,:); info.matrix(481:end,:)];
resp2 =  [resp(61:420,:); resp(481:end,:)];

value = size(matrix,1);

%%
% pre hits
hits1 = resp2(1:value,1)==1 & matrix(1:value,4) == 0 & matrix(1:value,1)==1 & sac(:,1)==1 & response(1:value,1) == 1; % val high prob
hits2 = resp2(1:value,1)==1 & matrix(1:value,4) == 0 & matrix(1:value,1)==2 & sac(:,1)==1 & response(1:value,1) == 1; % val low prob
hits3 = resp2(1:value,1)==1 & matrix(1:value,4) == 0 & matrix(1:value,1)==3 & sac(:,1)==1 & response(1:value,1) == 1; % inval high prob
hits4 = resp2(1:value,1)==1 & matrix(1:value,4) == 0 & matrix(1:value,1)==4 & sac(:,1)==1 & response(1:value,1) == 1; % inval low prob
%--------------------------------------------------------------------------
% pre FA
fa1 = resp2(1:value,2)==1 & matrix(1:value,4) == 1 & matrix(1:value,1) == 1 & sac(:,1)==1; % val high prob
fa2 = resp2(1:value,2)==1 & matrix(1:value,4) == 1 & matrix(1:value,1) == 2 & sac(:,1)==1; % val low prob
fa3 = resp2(1:value,2)==1 & matrix(1:value,4) == 1 & matrix(1:value,1) == 3 & sac(:,1)==1; % inval high prob
fa4 = resp2(1:value,2)==1 & matrix(1:value,4) == 1 & matrix(1:value,1) == 4 & sac(:,1)==1; % inval low prob
fa_high =   [fa1;fa3]; % high prob
fa_low = [fa2;fa4]; % low prob
%--------------------------------------------------------------------------
% pre correct rejection valid (cr1 & cr2) and invalid (cr3 & cr4)
cr1 = resp2(1:value,3)==1 & matrix(1:value,4) == 1 & matrix(1:value,1) == 1 & sac(:,1)==1;
cr2 = resp2(1:value,3)==1 & matrix(1:value,4) == 1 & matrix(1:value,1) == 2 & sac(:,1)==1;
cr3 = resp2(1:value,3)==1 & matrix(1:value,4) == 1 & matrix(1:value,1) == 3 & sac(:,1)==1;
cr4 = resp2(1:value,3)==1 & matrix(1:value,4) == 1 & matrix(1:value,1) == 4 & sac(:,1)==1;
cr_high =   [cr1;cr3]; % val
cr_low = [cr2;cr4]; % inval
%--------------------------------------------------------------------------

% pre miss
miss1 = resp2(1:value,4)==1 & matrix(1:value,4) == 0 & matrix(1:value,1)==1 & sac(:,1)==1;
miss2 = resp2(1:value,4)==1 & matrix(1:value,4) == 0 & matrix(1:value,1)==2 & sac(:,1)==1;
miss3 = resp2(1:value,4)==1 & matrix(1:value,4) == 0 & matrix(1:value,1)==3 & sac(:,1)==1;
miss4 = resp2(1:value,4)==1 & matrix(1:value,4) == 0 & matrix(1:value,1)==4 & sac(:,1)==1;

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hits11 = sum(hits1) / (sum(hits1) + sum(miss1));
hits22 = sum(hits2) / (sum(hits2) + sum(miss2));
hits33 = sum(hits3) / (sum(hits3) + sum(miss3));
hits44 = sum(hits4) / (sum(hits4) + sum(miss4));

fa_high = sum(fa_high) / (sum(fa_high) + sum(cr_high));
fa_low = sum(fa_low) / (sum(fa_low) + sum(cr_low));


if hits11 == 0; hits11 = .25; end
if hits22 == 0; hits22 = .25; end
if hits33 == 0; hits33 = .25; end
if hits44 == 0; hits44 = .25; end

if fa_high == 0;fa_high = .25; end
if fa_low == 0; fa_low = .25; end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pal_path = '/home/kaneda/Documents/Palamedes1_11_11/Palamedes';
addpath(genpath(pal_path));

pHF = [hits11 fa_high;hits22 fa_low; hits33 fa_high; hits44 fa_low];


[dP, C, lnB, pC]=PAL_SDT_1AFC_PHFtoDP(pHF);

pH=pHF(:,1);
pF=pHF(:,2);

SDM=[pH';pF';dP'];
SDM=SDM';

%         fprintf('\n');
disp('     pHit      pFA    dprime');
disp(SDM);

%%
%% data filtered by saccades executed to the correct side.

cue_side = info.matrix(:,3);
cue_side(info.matrix(:,1)==3 & info.matrix(:,3)==1,1) = 2;
cue_side(info.matrix(:,1)==3 & info.matrix(:,3)==2,1) = 1;
cue_side(info.matrix(:,1)==4 & info.matrix(:,3)==1,1) = 2;
cue_side(info.matrix(:,1)==4 & info.matrix(:,3)==2,1) = 1;

sac_side1 = zeros(840,1);
sac_side1(cue_side(:,1)==1 & macrosacvec2(:,4) < 0,1) = 1;
sac_side1(cue_side(:,1)==2 & macrosacvec2(:,4) > 0,1) = 1;

sac_side = [sac_side1(61:420,:); sac_side1(481:end,:)];

% data filtered by saccade accuracy (saccade error <= 2.6)

sac_acc1 = hypot(info.EccDVA - abs(macrosacvec2(:,4)), abs(macrosacvec2(:,5))) >= 0 ...
    & hypot(info.EccDVA - abs(macrosacvec2(:,4)), abs(macrosacvec2(:,5))) <= 2.6;

sac_acc = [sac_acc1(61:420,:); sac_acc1(481:end,:)];

% data filtered by saccade latencies between 165 and 350 ms.

sac_lat1 = macrosacvec2(:,1) >= sacc_on & macrosacvec2(:,1) <= sacc_off;
sac_lat = [sac_lat1(61:420,:); sac_lat1(481:end,:)];

sac_offset1 = macrosacvec2(:,2) >= 200;
sac_offset = [sac_offset1(61:420,:); sac_offset1(481:end,:)];

% creacte a vector of ones (non-rejected trials) and zeros
% (rejected trials) regarding saccade latency, side and accuracy.

sac = sac_lat(:,1)==1 & sac_side(:,1)==1 & sac_acc(:,1)==1 & sac_offset(:,1)==1;

matrix = [info.matrix(61:420,:); info.matrix(481:end,:)];
%%

pre_1 = sum(sac(:,1)==1 & matrix(:,1)==1 & matrix(:,4)==0);
pre_2 = sum(sac(:,1)==1 & matrix(:,1)==2 & matrix(:,4)==0);
pre_3 = sum(sac(:,1)==1 & matrix(:,1)==3 & matrix(:,4)==0);
pre_4 = sum(sac(:,1)==1 & matrix(:,1)==4 & matrix(:,4)==0);

pre_catch1 = sum(sac(:,1)==1 & matrix(:,1)==1 & matrix(:,4)==1);
pre_catch2 = sum(sac(:,1)==1 & matrix(:,1)==2 & matrix(:,4)==1);
pre_catch3 = sum(sac(:,1)==1 & matrix(:,1)==3 & matrix(:,4)==1);
pre_catch4 = sum(sac(:,1)==1 & matrix(:,1)==4 & matrix(:,4)==1);


trial_1 = 100 - ((pre_1 / sum(matrix(:,1)==1 & matrix(:,4)==0)) * 100);
trial_2 = 100 - ((pre_2 / sum(matrix(:,1)==2 & matrix(:,4)==0)) * 100);
trial_3 = 100 - ((pre_3 / sum(matrix(:,1)==3 & matrix(:,4)==0)) * 100);
trial_4 = 100 - ((pre_4 / sum(matrix(:,1)==4 & matrix(:,4)==0)) * 100);

trial_catch1 = 100 - ((pre_catch1 / sum(matrix(:,1)==1 & matrix(:,4)==1)) * 100);
trial_catch2 = 100 - ((pre_catch2 / sum(matrix(:,1)==2 & matrix(:,4)==1)) * 100);
trial_catch3 = 100 - ((pre_catch3 / sum(matrix(:,1)==3 & matrix(:,4)==1)) * 100);
trial_catch4 = 100 - ((pre_catch4 / sum(matrix(:,1)==4 & matrix(:,4)==1)) * 100);


total_trls = [trial_1 trial_catch1
    trial_2 trial_catch2
    trial_3 trial_catch3
    trial_4 trial_catch4];


disp('  trials excluded (%) ');
disp('   nocatch   catch');
disp(total_trls);



%% Saccade accuracy
        sacvec = rmmissing([macrosacvec2(61:420,:);macrosacvec2(481:end,:)]);

[ dmap, limits,fudge ] =dataDensity(rmmissing(sacvec(:,4)),rmmissing(sacvec(:,5)),1920,1080,[-26.6667/2.5 26.6667/2.5 -15/5 15/5],.005);
%% Saccade accuracy

subplot(2,4,1:2)


cmap = colormap(slanCM('amber',30)); % flipud( % colormap(viridis);
% cm =  imagesc(sacc_accuracy);
set(gca, 'YDir','normal');
[C,h] = contourf(dmap);
h.EdgeColor = 'flat';

        viscircles([(960-720) (1080/2); (960+720) (1080/2)], [(99)  (99)], 'Color', 'w','LineStyle',':','LineWidth',1.2,'EnhanceVisibility',0);
        viscircles([(960-720) (1080/2); (960+720) (1080/2)], [(234)  (234)], 'Color', 'y','LineStyle',':','LineWidth',1.2,'EnhanceVisibility',0);
        viscircles([(960) (1080/2)],1, 'Color', 'w','LineStyle','-','LineWidth',5,'EnhanceVisibility',0);

%scatter(1920/2,1080/2,'w','.'); hold on;
clb =   colorbar;
clb.Units = "normalized";
clb.Box = "off";
clb.LineWidth = 1.2;
clb.TickDirection = "out";
clb.Location = "northoutside";
hold on;

ax = gca;
set(gca,'TickDir','out');
set(gca, 'Box', 'off','XColor','k','YColor','k','XLimitMethod','tickaligned');
axis([0 1920 0 1080]);
% ax.FontSize = 12;
% ax.LineWidth = 1.2;
% 
% 
 ax.XTick = [960-720 1920/2 960+720];
 ax.YTick = [0 1080/2 1080]; % 36 px (1dva). 36px*2dva=72 px

ax.XTickLabel = ["-8";"0";"8"];
ax.YTickLabel = ["-3";"0";"3"];


%% Saccade Reaction Times

lat1 = sacvec(sacvec(:,1) <= 200,1);
lat2 = sacvec(sacvec(:,1) >= 201 & sacvec(:,1) <= 250,1);
lat3 = sacvec(sacvec(:,1) >= 251 & sacvec(:,1) <= 300,1);
lat4 = sacvec(sacvec(:,1) >= 301 & sacvec(:,1) <= 350,1);
lat5 = sacvec(sacvec(:,1) >= 351 & sacvec(:,1) <= 400,1);
lat6 = sacvec(sacvec(:,1) >= 401,1);

subplot(2,4,3)

histogram(sacvec(:,1),50,'BinWidth',5,"FaceColor",[1 1 1],"FaceAlpha",1,"EdgeColor",[1 1 1],"LineWidth",1.3); hold on;

% Define rectangle vertices (x and y coordinates of all 4 corners)
% Order matters - we'll go clockwise from bottom-left

x1 = [100 sacc_on sacc_on 100];  % x-coordinates of corners
y1 = [0 0 80 80];  % y-coordinates of corners
x2 = [290 500 500 290];  % x-coordinates of corners
y2 = [0 0 80 80];  % y-coordinates of corners
% Create a blue transparent rectangle
%patch(x, y, [205,101,0]/255,'FaceAlpha', .1,'EdgeColor', 'none','LineWidth', 1,'LineStyle', '--'); 
patch(x1, y1, [0.5 0.5 0.5],'FaceAlpha', .2,'EdgeColor', 'none','LineWidth', 1,'LineStyle', '--'); 
patch(x2, y2, [0.5 0.5 0.5],'FaceAlpha', .2,'EdgeColor', 'none','LineWidth', 1,'LineStyle', '--'); 
hold on;

histogram(lat1(:,1),40,'BinWidth',5,"FaceColor",[225,170,0]/255,"FaceAlpha",.5,"EdgeColor",[225,170,0]/255,"LineWidth",1.1); hold on;
histogram(lat2(:,1),40,'BinWidth',5,"FaceColor",[205,101,0]/255,"FaceAlpha",.5,"EdgeColor",[205,101,0]/255,"LineWidth",1.1); hold on;
histogram(lat3(:,1),40,'BinWidth',5,"FaceColor",[147,0,0]/255,"FaceAlpha",.5,"EdgeColor",[147,0,0]/255,"LineWidth",1.1); hold on;
histogram(lat4(:,1),40,'BinWidth',5,"FaceColor",[76,38,0]/255,"FaceAlpha",.5,"EdgeColor",[76,38,0]/255,"LineWidth",1.1); hold on;
histogram(lat5(:,1),40,'BinWidth',5,"FaceColor",[0,0,0]/255,"FaceAlpha",.5,"EdgeColor",[0,0,0]/255,"LineWidth",1.1); hold on;
histogram(lat6(:,1),40,'BinWidth',5,"FaceColor",[0 0 0]/255,"FaceAlpha",.8,"EdgeColor",[0 0 0]/255,"LineWidth",1.1); hold on;

xlabel('SRT (ms)','FontSize',8);
ylabel('Nº of Trials','FontSize',8);

    set(gca,'TickDir','out');
    set(gca, 'Box', 'off');
    ax = gca;
    ax.FontSize = 8;
    ax.LineWidth = 1.2;
    ax.XLim = [100 500];
    ax.YLim = [0 70];

    x = xline(median(sacvec(:,1)),':'); hold on;
    x.LineWidth = 2;
    x.Color = [0 0 0];

%% Targ offset - Sacc onset

lat1 = sacvec(sacvec(:,1) <= 200,1);
lat2 = sacvec(sacvec(:,1) >= 201 & sacvec(:,1) <= 250,1);
lat3 = sacvec(sacvec(:,1) >= 251 & sacvec(:,1) <= 300,1);
lat4 = sacvec(sacvec(:,1) >= 301 & sacvec(:,1) <= 350,1);
lat5 = sacvec(sacvec(:,1) >= 351 & sacvec(:,1) <= 400,1);
lat6 = sacvec(sacvec(:,1) >= 401,1);

lat1 = 190-lat1;
lat2 = 190-lat2;
lat3 = 190-lat3;
lat4 = 190-lat4;
lat5 = 190-lat5;
lat6 = 190-lat6;

subplot(2,4,4)

histogram(sacvec(:,1),50,'BinWidth',5,"FaceColor",[1 1 1],"FaceAlpha",1,"EdgeColor",[1 1 1],"LineWidth",1.3); hold on;

% Define rectangle vertices (x and y coordinates of all 4 corners)
% Order matters - we'll go clockwise from bottom-left
x1 = [-100 0 0 -100];  % x-coordinates of corners
y1 = [0 0 70 70];  % y-coordinates of corners

% Create a blue transparent rectangle
%patch(x, y, [205,101,0]/255,'FaceAlpha', .1,'EdgeColor', 'none','LineWidth', 1,'LineStyle', '--'); 
patch(x1, y1, [205,101,0]/255,'FaceAlpha', .2,'EdgeColor', 'none','LineWidth', 1,'LineStyle', '--'); 
hold on;

histogram(lat1(:,1),40,'BinWidth',5,"FaceColor",[225,170,0]/255,"FaceAlpha",.5,"EdgeColor",[225,170,0]/255,"LineWidth",1.1); hold on;
histogram(lat2(:,1),40,'BinWidth',5,"FaceColor",[205,101,0]/255,"FaceAlpha",.5,"EdgeColor",[205,101,0]/255,"LineWidth",1.1); hold on;
histogram(lat3(:,1),40,'BinWidth',5,"FaceColor",[147,0,0]/255,"FaceAlpha",.5,"EdgeColor",[147,0,0]/255,"LineWidth",1.1); hold on;
histogram(lat4(:,1),40,'BinWidth',5,"FaceColor",[76,38,0]/255,"FaceAlpha",.5,"EdgeColor",[76,38,0]/255,"LineWidth",1.1); hold on;
histogram(lat5(:,1),40,'BinWidth',5,"FaceColor",[0,0,0]/255,"FaceAlpha",.5,"EdgeColor",[0,0,0]/255,"LineWidth",1.1); hold on;
histogram(lat6(:,1),40,'BinWidth',5,"FaceColor",[0 0 0]/255,"FaceAlpha",.8,"EdgeColor",[0 0 0]/255,"LineWidth",1.1); hold on;

xlabel('Targ offset - Sacc onset','FontSize',8);
ylabel('Nº of Trials','FontSize',8);

    set(gca,'TickDir','out');
    set(gca, 'Box', 'off');
    ax = gca;
    ax.FontSize = 8;
    ax.LineWidth = 1.2;
    ax.XLim = [-200 300];
    ax.YLim = [0 70];

    x = xline(0,':'); hold on;
    x.LineWidth = 2;
    x.Color = [0 0 0];


%% Plots for hits and FAs

subplot(2,4,5)
plot = bar([1 2],[SDM(1:2,1)';SDM(3:4,1)']*100,...
    FaceColor="none",LineWidth=1.5,BarWidth=.4);
plot(1).EdgeColor = [205,101,0]/255;

title('Discrimination performance ','FontSize',8);

name={'Congruent';'Incongruent'};
set(gca,'xticklabel',name,'FontWeight','normal');

hold on;
%-------------------------------------------------------------------------

plot2 = bar([1 2],[SDM(1:2,2)';SDM(3:4,2)']*100,LineWidth=1.5,BarWidth=.4);
plot2(1).EdgeColor = [205,101,0]/255;
plot2(1).FaceColor = [205,101,0]/255;
plot2(2).FaceColor = [0 0 0];

name={'Congruent';'Incongruent'};
set(gca,'xticklabel',name,'FontWeight','normal');
ylabel('Performance (%)','FontWeight', 'bold','FontSize',8);
xlabel('Saccadic Cue','FontWeight','bold','FontSize',8);

%-------------------------------------------------------------------------

hold on
ax = gca;
ax.LineWidth = 1.2;
ax.FontSize = 8;
set(gca,'TickDir','out');
set(gca, 'Box', 'off');
 ax.YLim = [0 100];

% Combine the handles of the bar plots
allBars = [plot, plot2];

leg = legend(allBars, {'High (Hits)';'Low (Hits)';'High (FAs)';'Low (FAs)'},'Location','northeast','FontSize', 6);
hold on;
legend('boxoff');
title(leg,'Feature Probability');

%% ensitivity (d) for both saccade congrency and feature probability

subplot(2,4,6)

plot3 = bar([1 2],[SDM(1:2,3)';SDM(3:4,3)'],LineWidth=1.5,BarWidth=.4);
plot3(1).EdgeColor = [205,101,0]/255;
plot3(1).FaceColor = [205,101,0]/255;
plot3(2).FaceColor = [0 0 0];

title('Discrimination performance','FontSize',8);

name={'Congruent';'Incongruent'};
set(gca,'xticklabel',name,'FontWeight','normal');
ylabel('Sensitivity (d)','FontWeight', 'bold','FontSize',8);
xlabel('Saccadic Cue','FontWeight','bold','FontSize',8);

%-------------------------------------------------------------------------

hold on
ax = gca;
ax.LineWidth = 1.2;
ax.FontSize = 8;
set(gca,'TickDir','out');
set(gca, 'Box', 'off');
 ax.YLim = [0 3];

leg = legend(plot3, {'High';'Low';},'Location','northeast','FontSize', 6);
hold on;
legend('boxoff');
title(leg,'Feature Probability');

%%

subplot(2,4,7)

plot3 = bar([mean(SDM(1:2,3))';mean(SDM(3:4,3))'],LineWidth=1.5,BarWidth=.4);
plot3.EdgeColor = [205,101,0]/255;
plot3.FaceColor = [205,101,0]/255;

name={'Congruent';'Incongruent'};
set(gca,'xticklabel',name,'FontWeight','normal');
ylabel('Sensitivity (d)','FontWeight', 'bold','FontSize',8);
xlabel('Saccadic Cue','FontWeight','bold','FontSize',8);

hold on
ax = gca;
ax.LineWidth = 1.2;
ax.FontSize = 8;
set(gca,'TickDir','out');
set(gca, 'Box', 'off');
 ax.YLim = [0 3];


%%

subplot(2,4,8)

plot3 = bar([mean([SDM(1,3) SDM(3,3)])';mean([SDM(2,3) SDM(4,3)])'],LineWidth=1.5,BarWidth=.4);
plot3.EdgeColor = [205,101,0]/255;
plot3.FaceColor = [205,101,0]/255;

name={'High';'Low'};
set(gca,'xticklabel',name,'FontWeight','normal');
ylabel('Sensitivity (d)','FontWeight', 'bold','FontSize',8);
xlabel('Feature probability','FontWeight','bold','FontSize',8);

hold on
ax = gca;
ax.LineWidth = 1.2;
ax.FontSize = 8;
set(gca,'TickDir','out');
set(gca, 'Box', 'off');
 ax.YLim = [0 3];