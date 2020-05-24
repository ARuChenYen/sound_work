clc;clear;close all;
wavefileDir = dir();

num = 1;
filesequence =1;
for i = filesequence:length(wavefileDir)
    checkwavefile = wavefileDir(i).name;
    if length(checkwavefile)>=4
        iswave = lower(checkwavefile(end-3:end));
        if strcmp(iswave, '.wav') == 1
            wavefile = wavefileDir(i).name;
            [crypower, scale, cc] = FFT_result_and_All_Power (wavefile);
            All_power_Sum(num,:) = crypower;
            num = num + 1;
        else
        end
    else 
    end
    filesequence = filesequence+1;
end

totalpowersum = sum(sum(All_power_Sum));
aa = size(All_power_Sum);
for i = 1:aa(2)
    %normalize
    %feature_all_power(i) = sum(All_power_Sum(:,i))/totalpowersum;
    
    %not normalize
    feature_all_power(i) = sum(All_power_Sum(:,i));
end

fig = gcf;
fig.Position = [1,41,1920,962];
plot(scale(1:floor(cc/2)),feature_all_power)
title('feature All Power, 0-10000Hz')
xlabel('Frequency')
ylabel('Total Power')
set(gca,'xtick',[0:100:6000])
xlim([0 4000])
grid on
print(gcf,'-dpng',['碰撞拍打聲+背景音樂聲'],'-r0')