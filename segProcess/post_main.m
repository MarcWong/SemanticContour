inputpath = '/Users/marcWong/Dataset/big/1/result/';
outputpath = '/Users/marcWong/Dataset/big/1/';
listing = dir([inputpath '*.jpg']);
imgSum = length(listing);
m = 2500;
n = 2500;
e = zeros([m n]);
for imgNum = 1:imgSum
    imgName = [inputpath listing(imgNum).name];
    img = imread(imgName);
    img = rgb2gray(img) > 96;
    e = e + img;
end
e = e>0;
imwrite(e,[outputpath 'output_final.jpg']);
visualorigin;