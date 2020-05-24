clc;clear;close all;

file_path = 'E:\Matlab MFiles\crying-data\Cubo_detectedcry\分割中\';
split_file_path = 'E:\Matlab MFiles\crying-data\Cubo_detectedcry\分割中\';
wavefile = 'audio_detected_cry_vm_1546114761.wav';
aud_num = 1;%音訊總數量
wavefile_to_read = [file_path,wavefile];

wavefilename = wavefile(1:end-4);
[audiodata,fs] = audioread(wavefile_to_read);
% audiodata = (audiodata(:,1)+audiodata(:,2))/2;
len_data = length(audiodata);    % original sample length
t1 = 0:1/fs:(len_data-1)/fs;
% audiodata = audiodata-mean(audiodata);

%enframe%
wlen = 1024;
overlap = 0;

inc = wlen - overlap;
frameNum = fix((len_data-overlap)/inc);
frameY = zeros(wlen,frameNum);
for i = 1:frameNum
    startIndex = (i-1)*inc+1;
    frameY(:,i) = audiodata(startIndex:(startIndex+wlen-1));
end

therhold = sqrt(mean(sum(abs(frameY)))/2);
volume1 = zeros(frameNum,1);
rline = repmat(therhold,frameNum,1);
vad = zeros(frameNum,1);
maxvolume = round(20+max(sum(abs(frameY))));

for i = 1:frameNum
    tt = frameY(:,i);
    volume1(i) = sum(abs(tt));
    if volume1(i) <= therhold
        vad(i) = 0;
    else
        vad(i) = maxvolume;
    end
end

sw = [];
for i = 1:frameNum-1
    if vad(i+1) ~= vad(i)
        sw = [sw i+1];
    end
end

vad2 = vad;
vad3 = vad;
%less than 10 frames treat as previous state
for i = 1:length(sw)-1
    if sw(i+1) - sw(i) < 10
        for i2 = sw(i):sw(i+1)
            vad3(i2) = vad3(i2-1);
        end
    end
end

%file split%
sw2 = [];
for i = 1:frameNum-1
    if vad2(i+1) ~= vad2(i)
        sw2 = [sw2 i+1];
    end
end

num = 1;
waudioY = {};
if isempty(sw2) == 1
    waudioY(num).audio = audiodata;
    waudioY(num).time = [0, (len_data-1)/fs];
    waudioY(num).stage = 'cry';
    waudioY(num).origin = wavefilename;
    waudioY(num).filename = [wavefilename,'_notsplit.wav'];
else
end
    
for i = 1:length(sw2)
    filename = [wavefilename,'_clip_', num2str(num,'%d'), '.wav'];
    ii2 = sw2(i);
    if i == length(sw2) && vad2(ii2) == maxvolume
        startIndex = (ii2-1)*inc+1;
        waudioY(num).audio = audiodata(startIndex:len_data);
        waudioY(num).time = [startIndex/fs, (len_data)/fs];
        waudioY(num).stage = 'cry';
        waudioY(num).origin = wavefilename;
        waudioY(num).filename = filename;
        num = num+1;
    elseif i == 1 && vad2(ii2) ==0
        endindex = (ii2-1)*inc;
        waudioY(num).audio = audiodata(1:endindex);
        waudioY(num).time = [0, (endindex)/fs];
        waudioY(num).stage = 'cry';
        waudioY(num).origin = wavefilename;
        waudioY(num).filename = filename;
        num = num+1;
    elseif i ~= 1 && i ~= length(sw2) && vad2(ii2) == maxvolume
        startIndex = (ii2-1)*inc+1;
        twlen = sw2(i+1) - sw2(i);
        waudioY(num).audio = audiodata(startIndex:(startIndex+twlen*inc-1));
        waudioY(num).time = [startIndex/fs, (startIndex+twlen*inc-1)/fs];
        waudioY(num).stage = 'cry';
        waudioY(num).origin = wavefilename;
        waudioY(num).filename = filename;
        num = num+1;
    elseif i == 1 && i ~= length(sw2) && vad2(ii2) == maxvolume
        startIndex = (ii2-1)*inc+1;
        twlen = sw2(i+1) - sw2(i);
        waudioY(num).audio = audiodata(startIndex:(startIndex+twlen*inc-1));
        waudioY(num).time = [startIndex/fs, (startIndex+twlen*inc-1)/fs];
        waudioY(num).stage = 'cry';
        waudioY(num).origin = wavefilename;
        waudioY(num).filename = filename;
        num = num+1;
    else
    end
end

%split the file, mark the file which the length less than 3 frame
filenum = size(struct2cell(waudioY));
if length(filenum) == 2
    filename = [split_file_path,waudioY(1).filename];
    waudioY(1).filename = filename;
    audiowrite(filename,waudioY(1).audio,fs);
else
    for i = 1:filenum(3)
        audio_frame_size = length(waudioY(i).audio)/wlen;
        filename = [split_file_path,waudioY(i).filename];
        if audio_frame_size < 3
            filename = [filename(1:end-4),'_less_than_3_frame.wav'];
            waudioY(i).filename = [waudioY(i).filename(1:end-4),'_less_than_3_frame.wav'];
        else
        end
        audiowrite(filename,waudioY(i).audio,fs);
    end
end

sampletime = (1:len_data)/fs;
frametime = (0:frameNum-1)*(inc)/fs;

figure(1)
subplot(3,1,1);
plot(sampletime,audiodata);
xlim([1,frametime(end)]);
subplot(3,1,2);
plot(frametime,volume1);
ylim([1,maxvolume+20]);
hold on;
plot(frametime,rline);
hold on;
plot(frametime,vad3);
subplot(3,1,3)
plot(frametime,volume1);
ylim([1,maxvolume+20]);
xlabel('Time (sec)')
hold on;
plot(frametime,rline);
hold on;
plot(frametime,vad2);

figure(2)
plot(sampletime,audiodata);

txtfilepath = [split_file_path,wavefilename,'_split_time_detail.txt'];
fid1 = fopen(txtfilepath,'w','n','UTF-8');
if length(filenum) == 2
    fprintf(fid1,'The %s in original file is in time: %f\n',waudioY(i).filename,waudioY(i).time);
else
    for i = 1:filenum(3)
        fprintf(fid1,'The %s in original file is in time: %f - %f\n',waudioY(i).filename,waudioY(i).time(1),waudioY(i).time(2));
    end
end
fclose(fid1);

