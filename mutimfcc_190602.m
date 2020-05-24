clc;clear;close all;
tic()
%--�e�T���i---------------------------
L = 1500;       %�C��filter����
w = triang(L);
%wvtool(w)
str1=zeros;
str2=zeros;
str3=zeros;

file_path =  'E:\Matlab MFiles\crying-data\Cubo_SVM_AudioData\Test_Data\��¤H�n����\';
txt_file_path = 'E:\Matlab MFiles\crying-data\Cubo_SVM_AudioData\Dataset\Test\';
aud_path_list = dir(strcat(file_path,'*.wav'));%����Ӹ�Ƨ����Ҧ�wav�榡���v�H
aud_num = length(aud_path_list);%������T�`�ƶq

mfcc_data = {};
mfccY = {};
if aud_num > 0 %���������󪺭��T
    for j = 1:aud_num %�v�@Ū�����T
        audio_name = aud_path_list(j).name;% ���T�W
        [y,fs] =  audioread(strcat(file_path,audio_name));%Ū��
        framecont=floor(length(y)/L); %�|�ͦ��X��frame
        y=y(:,1);%�����n�D
        frameY = mirframe(y);%��mirframe
        column_num = 1;
        for mfcc_num = 5:20%��5��20��mfcc
            mfccY{column_num,j} = mirmfcc(frameY,'Rank',1:mfcc_num);%��mfcc
            mfcc_data{column_num,j} = mirgetdata(mfccY{column_num,j});%��mfcc��ڪ���
            column_num = column_num+1;
        end
    end
else
end

total_mfcc_num = size(mfcc_data);
total_mfcc_num = total_mfcc_num(1);%�۰ʭp�⦳�h�֭�mfcc
str1 = [];
for i =1:total_mfcc_num
    for j = 1:aud_num %�N�Ҧ��ɮפ��S�w�Y��mfcc���Ȩ��X��
        str4=[txt_file_path, num2str(i+4), 'test.txt'];%MFCC�V�m�A�����ɮצW��
        fid2 = fopen(str4, 'a+','n','UTF-8');%�}�ɼg�ɷǳ�
        temp_data = mfcc_data{i,j};%�N�S�w�ɮפ��S�w�Y��mfcc���ȥ����X�ӼȦs
        temp_data_size = size(temp_data);%�p��j�p
        for k = 1:temp_data_size(2)
            for l = 1:temp_data_size(1)
                str1=[str1,num2str(l),':',num2str(temp_data(l,k)),' '];%�Ntemp_data�����ȼg�i�ɮפ�
            end
            str1 = strtrim(str1);
            str4=['0 ',str1];%1��0�N��SVM���V�m��ơA�g��̫e��
            fprintf(fid2,'%s\n', str4);
            str1 = [];
        end
        fclose(fid2);
    end
end

%��C��frame���X�B�g�X��
first_frame = 38;
end_frame = 0 ;
str5=[txt_file_path, 'frame_origin.txt'];
fid3= fopen(str5, 'a+','n','UTF-8');
for i = 1:aud_num
    frame_num = size(mfcc_data{1,i});
    frame_num = frame_num(2);
    end_frame = first_frame + frame_num - 1;
    frame_mark = [num2str(first_frame),'-',num2str(end_frame)];
    fprintf(fid3,'The frame %s is from %s\n', frame_mark,aud_path_list(i).name);
    first_frame = end_frame+1;
    frame_mark = [];
end
fclose(fid3);

toc()