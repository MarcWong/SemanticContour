prePath = '/Users/wuyoukun/Desktop/pku_course/github-program/big/1/';
segFile = [prePath '1-seg.png'];
segImg = imread(segFile);
if length(size(segImg))==3
    segImg = rgb2gray(segImg);
end
segImg = imresize(segImg,0.5);
[m,n] = size(segImg);

%%
%padding image edges
e = false(m,n);
j = 2;
for i = 2:m-1
    if segImg(i,j)>0
        e(i,j) = 1;
    end
end
j = n-1;
for i = 2:m-1
    if segImg(i,j)>0
        e(i,j) = 1;
    end
end

i = 2;
for j = 2:n-1
    if segImg(i,j)>0
        e(i,j) = 1;
    end
end

i = m-1;
for j = 2:n-1
    if segImg(i,j)>0
        e(i,j) = 1;
    end
end

img = edge(segImg,'canny');
img = logical(img + e);
outputpath = [prePath 'contour/'];
%% split contours
savecontour(img,outputpath,20);

%% transform the contours to ordered points
waterfilling(outputpath);