img = uint8(zeros([256 256 3]));
a = imread('11-gt.png');
b = imread('mask.jpg');
for i = 1:256
    for j = 1:256
        img(i,j,1) = a(i,j);
        img(i,j,3) = b(i,j);
    end
end
imwrite(img,'gt_mask.jpg');