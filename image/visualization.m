e = zeros([256 256 3]);
ec = zeros([256 256 3]);
a = imread('nms.jpg');
b = imread('out249-gt.png');
c = imread('hough.jpg');

for i = 1:256
    for j = 1:256
        if c(i,j)>128;
            ec(i,j,1) = 255;
            ec(i,j,2) = 255;
        end
    end
end

for i = 1:256
    for j = 1:256
        if a(i,j)>128 && b(i,j,1)>128
            e(i,j,1) = 255;
        elseif a(i,j)>128 && b(i,j,1)<= 128
            e(i,j,2) = 255;
        elseif b(i,j,1)>128 && a(i,j)<= 128
            e(i,j,3) = 255;
        end
    end
end

e = (e + ec);

e=uint8(e);
imwrite(e,'1.png');