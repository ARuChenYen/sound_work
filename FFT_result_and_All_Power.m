function [power_cryAll, fscale, n2] = FFT_result_and_All_Power (wavefile)

wavefilename = wavefile(1:(length(wavefile)-4));
[audiodata,fs] = audioread(wavefile);
% audiodata = (audiodata(:,1)+audiodata(:,2))/2;
len_data = length(audiodata);    % original sample length
t1 = 0:1/fs:(len_data-1)/fs;

%filter%
cutofffrequence = 250;
[bb,ba] = fir1(100,cutofffrequence/(fs/2),'high');
audiodata = filter(bb,ba,audiodata);

% figure(1)
% plot(t1,audiodata)
% title('original data')
% xlabel('Time (seconds)')
% ylabel('Amplitude')
% xlim([0 t1(end)])
% saveas(gcf, [wavefilename,'originaldata'], 'png');

%enframe%
wlen = 2048;
overlap = 0.5*wlen;
inc = wlen - overlap;
frameNum = fix((len_data-overlap)/inc);
frameY = zeros(wlen,frameNum);
win_hann = hann(wlen);
for i = 1:frameNum
    startIndex = (i-1)*inc+1;
    frameY(:,i) = audiodata(startIndex:(startIndex+wlen-1));
    frameY(:,i) = frameY(:,i) - median(frameY(:,i));
    frameY(:,i) = win_hann.*frameY(:,i);
end

%Frame FFT%
n2 = pow2(nextpow2(wlen));  % transform length
fftframeY = fft( frameY,n2);
powerframeY = abs(fftframeY).^2/n2;
powerframeY = powerframeY((1:n2/2),:);

fscale = (0:wlen-1)*(fs/wlen);
for i =1:(n2/2)
    power_cryAll(i) = sum(powerframeY(i,:));
end


% figure(7)
% plot(fscale(1:floor(n2/2)),powerframeY)
% title('No filter, All frame, 0-10000Hz')
% xlabel('Total Frequency')
% ylabel('Total Power ()')
% xlim([0 5000])
% % saveas(gcf, [wavefilename,'Allframe'], 'png');
% 
% figure(8)
% plot(fscale(1:floor(n2/2)),power_cryAll)
% title('No filter, All frame, 0-10000Hz')
% xlabel('Total Frequency')
% ylabel('Total Power ()')
% xlim([0 5000])
