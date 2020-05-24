function confusion_matrix_190605 (test_file_name,predict_file_name,cm_text_path,cm_fig_path)

fid_test = fopen(test_file_name,'r','n','UTF-8'); %放測試資料
fid_predict = fopen(predict_file_name,'r','n','UTF-8'); %放預測資料
test_data = textscan(fid_test,'%s','delimiter','\n'); %輸入data
predict_data = textscan(fid_predict,'%s','delimiter','\n');
fclose(fid_test);fclose(fid_predict);

data_num = size(test_data{1,1});%取得data大小
num = 1;
for i = 1:data_num(1)
    test_label(i) =  str2num(test_data{1,1}{i,1}(1)); %只取用每條dataset的第一個label
    predict_label(i) = str2num(predict_data{1,1}{i,1}(1));
    if predict_label(i) ~= test_label(i) %如果預測跟測試不一樣就記錄位置
        mismatch(num) = i;
        num = num+1;
    else
    end
end

mfcc_num = test_file_name(length(test_file_name)-9:length(test_file_name)-8);
if isstrprop(mfcc_num(1),'digit') == 0
    mfcc_num(1) = mfcc_num(2);
    mfcc_num(2) = [];
else
end

cm_fig_name = ['mfcc_',mfcc_num,'_confusion_matrix'];
cm_fig_name = strcat(cm_fig_path,cm_fig_name);
fig = gcf;
cm = confusionchart(test_label,predict_label); %confusion matrix
print(gcf,'-dpng',[cm_fig_name],'-r0')

correct_num = data_num(1)-length(mismatch);%計算Accuracy
acc = (correct_num/data_num(1))*100;

%將不一樣的結果寫成txt檔案
text_name = ['mfcc_',mfcc_num,'_confusion_matrix.txt'];
text_name = strcat(cm_text_path,text_name);
fidtext = fopen(text_name,'w','n','UTF-8');
fprintf(fidtext,'Accuracy = %0.4f%% (%d/%d) (classification)\n',acc,correct_num,data_num(1));
for i =1:length(mismatch)
    position = mismatch(i);
    fprintf(fidtext,'The predict dataset %d is %d, but the test is %d\n',mismatch(i),predict_label(position),test_label(position));
end
fclose(fidtext);
end
