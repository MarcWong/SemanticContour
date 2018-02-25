%%parameters
expansion_times = 1;
gt_thres = 0;

edgeImg = '/Users/marcWong/Dataset/big/1/output_final.jpg';
%edgeImg = '/Users/marcWong/Dataset/big/1/contour.jpg';

gtImg = '/Users/marcWong/Dataset/big/1/1-gt.png';

originalImg = '/Users/marcWong/Dataset/big/1/1.jpg';

outputGt = '/Users/marcWong/Dataset/big/1/visualization_gt.jpg';
outputCmp = '/Users/marcWong/Dataset/big/1/visualization_compare.jpg';

%----------------------------------------%

    
c = imread(edgeImg);
c = expand(c,gt_thres,expansion_times);
%c = imread([nmspath file_name '_expansion_cmask.png']);

if max(max(c(:,:)))==1
    c = uint8(c).*255;
end


b = imread(gtImg);
b = imresize(b,0.5);
%b = imread([outputpath file_name '_fusion.jpg']);
%b = imread(['train/' file_name '-gt.png']);
%a = imread('canny.jpg');
if length(size(b))==3
    b = rgb2gray(b);
end

bb = imread(originalImg);
bb = imresize(bb,0.5);
[m n]=size(b);

e = zeros([m n 3]);

b = expand(b,gt_thres,expansion_times);
for i = 1:m
    for j = 1:n
        if c(i,j)>150 && b(i,j)>gt_thres
            e(i,j,1) = 255;
            e(i,j,2) = 0;
            e(i,j,3) = 0;
            
            bb(i,j,1) = 255;
            bb(i,j,2) = 0;
            bb(i,j,3) = 0;
        elseif c(i,j)>150 && b(i,j)<= gt_thres
            e(i,j,1) = 0;
            e(i,j,2) = 255;
            e(i,j,3) = 0;
        elseif b(i,j)>gt_thres && c(i,j)<= 150
            e(i,j,1) = 0;
            e(i,j,2) = 0;
            e(i,j,3) = 255;
        end
    end
end

%e = (e + ec);

e=uint8(e);

imwrite(bb,outputGt);
imwrite(e,outputCmp);