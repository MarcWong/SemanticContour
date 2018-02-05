%%parameters
expansion_times = 1;
gt_thres = 128;

%edgeImg = '/Users/marcWong/Dataset/big/1/output_final.jpg';
%edgeImg = '/Users/marcWong/Dataset/big/1/contour.jpg';
edgeImg = '/Users/marcWong/Dataset/big/1/1-gt.png';

originalImg = '/Users/marcWong/Dataset/big/1/1.jpg';
outputImg = '/Users/marcWong/Dataset/big/1/original_visualization_gt.jpg';
%----------------------------------------%
edgeI = imread(edgeImg);
%edgeI = imresize(edgeI,0.5);
if length(size(edgeI))==3
        edgeI = rgb2gray(edgeI);
end
if max(edgeI(:))==1
    edgeI = uint8(edgeI).*255;
end
if expansion_times>0
    edgeI = expand(edgeI,128,expansion_times);
end
[m n]=size(edgeI);
originI = imread(originalImg);
originI = imresize(originI,0.5);
for i = 1:m
    for j = 1:n;
        if edgeI(i,j)>gt_thres
            originI(i,j,1) = 255;
            originI(i,j,2) = 0;
            originI(i,j,3) = 0;
        end
    end
end
imwrite(originI,outputImg);