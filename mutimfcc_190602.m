clc;clear;close all;
tic()
%--畫三角波---------------------------
L = 1500;       %每個filter長度
w = triang(L);
%wvtool(w)
str1=zeros;
str2=zeros;
str3=zeros;

file_path =  'E:\Matlab MFiles\crying-data\Cubo_SVM_AudioData\Test_Data\單純人聲雜音\';
txt_file_path = 'E:\Matlab MFiles\crying-data\Cubo_SVM_AudioData\Dataset\Test\';
aud_path_list = dir(strcat(file_path,'*.wav'));%獲取該資料夾中所有wav格式的影象
aud_num = length(aud_path_list);%獲取音訊總數量

mfcc_data = {};
mfccY = {};
if aud_num > 0 %有滿足條件的音訊
    for j = 1:aud_num %逐一讀取音訊
        audio_name = aud_path_list(j).name;% 音訊名
        [y,fs] =  audioread(strcat(file_path,audio_name));%讀檔
        framecont=floor(length(y)/L); %會生成幾個frame
        y=y(:,1);%取單聲道
        frameY = mirframe(y);%取mirframe
        column_num = 1;
        for mfcc_num = 5:20%取5到20個mfcc
            mfccY{column_num,j} = mirmfcc(frameY,'Rank',1:mfcc_num);%取mfcc
            mfcc_data{column_num,j} = mirgetdata(mfccY{column_num,j});%取mfcc實際的值
            column_num = column_num+1;
        end
    end
else
end

total_mfcc_num = size(mfcc_data);
total_mfcc_num = total_mfcc_num(1);%自動計算有多少個mfcc
str1 = [];
for i =1:total_mfcc_num
    for j = 1:aud_num %將所有檔案中特定某個mfcc的值取出來
        str4=[txt_file_path, num2str(i+4), 'test.txt'];%MFCC訓練，測試檔案名稱
        fid2 = fopen(str4, 'a+','n','UTF-8');%開檔寫檔準備
        temp_data = mfcc_data{i,j};%將特定檔案中特定某個mfcc的值先取出來暫存
        temp_data_size = size(temp_data);%計算大小
        for k = 1:temp_data_size(2)
            for l = 1:temp_data_size(1)
                str1=[str1,num2str(l),':',num2str(temp_data(l,k)),' '];%將temp_data中的值寫進檔案中
            end
            str1 = strtrim(str1);
            str4=['0 ',str1];%1或0代表SVM的訓練資料，寫到最前面
            fprintf(fid2,'%s\n', str4);
            str1 = [];
        end
        fclose(fid2);
    end
end

%把每個frame的出處寫出來
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