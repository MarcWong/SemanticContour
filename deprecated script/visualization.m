e = zeros([256 256 3]);
ea = zeros([256 256 3]);
c = imread('nms-thres1.5.jpg');
b = imread('out249-gt.jpg');
a = imread('canny.jpg');

%for i = 1:256
%    for j = 1:256
%        if a(i,j)>128
%            ea(i,j,1) = 255;
%        end
%    end
%end

for i = 1:256
    for j = 1:256
        if c(i,j)>128 && b(i,j)>128
            e(i,j,1) = 255;
        elseif c(i,j)>128 && b(i,j)<= 128
            e(i,j,2) = 255;
        elseif b(i,j)>128 && c(i,j)<= 128
            e(i,j,3) = 255;
        end
    end
end

%e = (e + ea);

e=uint8(e);
imwrite(e,'hed_nms.png');