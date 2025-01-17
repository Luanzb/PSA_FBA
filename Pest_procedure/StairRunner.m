
close all; clear; clc;

git_path = '/home/kaneda/Documents/GitHub/PSA_FBA';
addpath(genpath(git_path));

pc_path = '/home/kaneda/Documents/GitHub/Subjects';
addpath(genpath(pc_path));

pal_path = '/home/kaneda/Documents/Palamedes1_11_11/Palamedes';
addpath(genpath(pal_path));


% Ask subject number
answer = inputdlg({'Número Sujeito','Sessão','Olho Dominante (E/D)','Qual StairCase? (V/H)'}, '', [1 25]);

sub.id = answer{1}; sub.id_num = str2double(answer{1});
sub.ses_num = str2double(answer{2}); 


info_path = fullfile(sprintf('%s/Data/S%d/Staircase/ses_%d_staircase_sub_%d_*', pc_path,sub.id_num,sub.ses_num,sub.id_num));
info_file = dir(info_path);
load([info_file.folder '/' info_file.name])

sub.eye = answer{3};
sub.Staircase = answer{4};

%% Run experiment

[resp,PEST] = Stair_On_Screen(info,trl,gabor,mask,sub,mat);


PEST_analysis(PEST,resp,sub)

text = sprintf('Limiar de contraste em: %d',PEST.mean);
format short
disp(text);  

%% update staircase file adding resp and PEST variables

save(fullfile(sprintf('%s/Data/S%d/Staircase/%s', pc_path, sub.id_num), [info_file.name]), 'gabor', 'info', 'mask','mat','sub','trl','resp','PEST', '-v7.3');
