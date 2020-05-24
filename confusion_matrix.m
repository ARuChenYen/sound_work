clc;clear;close all;
test_file_path =  'E:\Matlab MFiles\crying-data\confusion_matrix_190602\test\';
predict_file_path = 'E:\Matlab MFiles\crying-data\confusion_matrix_190602\test\';
cm_text_file_path =  'E:\Matlab MFiles\crying-data\confusion_matrix_190602\test\';
cm_fig_file_path = 'E:\Matlab MFiles\crying-data\confusion_matrix_190602\test\';

test_file_list = dir(strcat(test_file_path,'*test.txt'));
predict_file_list = dir(strcat(predict_file_path,'*predict.out'));
test_file_num = length(test_file_list);
predict_file_num = length(predict_file_list);

for j = 1:test_file_num
    test_file_name = strcat(test_file_path,test_file_list(j).name);
    predict_file_name = strcat(test_file_path,predict_file_list(j).name);
    confusion_matrix_190605(test_file_name,predict_file_name,cm_text_file_path,cm_fig_file_path)
end