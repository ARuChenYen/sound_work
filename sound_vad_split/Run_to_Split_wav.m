clc;clear;close all;

file_path = 'E:\Matlab MFiles\crying-data\Cubo_detectedcry_190510\noise+cry\�I���n+���q�Ӥj�z��\���Τ�\';
split_file_path_0frame = file_path;
% split_file_path_10frame = 'E:\Matlab MFiles\crying-data\Cubo_detectedcry\���Τ�\10frame\';
aud_path_list = dir(strcat(file_path,'*.wav'));%����Ӹ�Ƨ����Ҧ�wav�榡���v�H
aud_num = length(aud_path_list);%������T�`�ƶq

for i = 1:aud_num
    wavefile = aud_path_list(i).name;
    wavefolder = aud_path_list(i).folder;
    soundsplit_0frame(wavefile,wavefolder,split_file_path_0frame);
%     soundsplit_10frame(wavefile,wavefolder,split_file_path_10frame);
end