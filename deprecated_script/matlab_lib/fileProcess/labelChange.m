gtpath = '/Users/marcWong/Desktop/train/';
list = dir([gtpath '*.mat']);
for i = 1:length(list)
    imggt = imread([gtpath list(i).name]);
    imwrite(imggt,[gtpath strrep(list(i).name,'.jpg\^J','')]);
end