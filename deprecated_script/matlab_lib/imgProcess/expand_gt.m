srcpath = '/Users/marcWong/Desktop/lab/nonMaximumSupression/hed-bsds/gt/';
newpath = '/Users/marcWong/Desktop/lab/nonMaximumSupression/hed-bsds/gt_expand/';
list = dir([srcpath '*.png']);
for k = 1:length(list)
    imggt = imread([srcpath list(k).name]);
    imggt = rgb2gray(imggt);
    %imgcanny = edge(imggt,'canny');
    e = expand(imggt,128);
    imagesc(e);
    imwrite(e,[newpath list(k).name]);
end