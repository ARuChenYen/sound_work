clc;clear;close all;

file_path = 'E:\Matlab MFiles\crying-data\Cubo_detectedcry_190510\noise+cry\碰撞聲+音量太大爆音\分割中\';
split_file_path_0frame = file_path;
% split_file_path_10frame = 'E:\Matlab MFiles\crying-data\Cubo_detectedcry\分割中\10frame\';
aud_path_list = dir(strcat(file_path,'*.wav'));%獲取該資料夾中所有wav格式的影象
aud_num = length(aud_path_list);%獲取音訊總數量

for i = 1:aud_num
    wavefile = aud_path_list(i).name;
    wavefolder = aud_path_list(i).folder;
    soundsplit_0frame(wavefile,wavefolder,split_file_path_0frame);
%     soundsplit_10frame(wavefile,wavefolder,split_file_path_10frame);
end