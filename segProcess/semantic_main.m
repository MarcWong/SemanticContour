prePath = '/Users/marcWong/Dataset/big/1/';
segFile = [prePath '1-seg.png'];
segImg = imread(segFile);
if length(size(segImg))==3
    segImg = rgb2gray(segImg);
end
segImg = imresize(segImg,0.5);
img = edge(segImg,'canny');
outputpath = [prePath 'contour/'];
%% split contours
savecontour(img,outputpath,50);

%% transform the contours to ordered points
waterfilling(outputpath);