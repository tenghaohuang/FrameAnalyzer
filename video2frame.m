function [frames_path] = video2frame(fileName,folderName)
%VIDEO2FRAME Summary of this function goes here
%   Detailed explanation goes here
a=VideoReader(fileName);

directName = folderName;
count = 0;
for img = 1:a.NumberOfFrames;
    
    progress = img/a.NumberOfFrames;
    h_w = waitbar(progress);
    filename=strcat('frame',num2str(img),'.jpg');
    b = read(a, img);
    imwrite(b,fullfile(directName,filename));
end
close(h_w);
frames_path = directName;
end

