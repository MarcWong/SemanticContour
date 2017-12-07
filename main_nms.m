%%parameters
gray_threshold = 50;
%k = 5;
%nms_threshold = [0.8*k k];
%%
file_num = '249';
origin = imread(['image/out' file_num '-origin.png']);
gt = rgb2gray(imread(['image/out' file_num '-gt.png']));
a1 = rgb2gray(imread(['image/out' file_num '-1.png']));
a2 = rgb2gray(imread(['image/out' file_num '-2.png']));
a3 = rgb2gray(imread(['image/out' file_num '-3.png']));
a4 = rgb2gray(imread(['image/out' file_num '-4.png']));
a5 = rgb2gray(imread(['image/out' file_num '-5.png']));
a6 = rgb2gray(imread(['image/out' file_num '-fusion.png']));

aa =uint8((uint16(a1) + uint16(a2) + uint16(a3) + uint16(a4) + uint16(a5)+uint16(a6))./6.0);%fusion image

for i = 1:256
    for j = 1:256
        if aa(i,j) < gray_threshold %threshold
            aa(i,j) = 0;
        end
    end
end
%imshow(aa);

nms1 = nms(a1);
nms2 = nms(a2);
nms3 = nms(a3);
nms4 = nms(a4);
nms5 = nms(a5);
nms_fusion = nms(aa);

figure;
subplot(221);
imshow(origin);
subplot(222);
imshow(gt);
subplot(223);
imagesc(nms1),colormap(gray),axis image, axis off;
subplot(224);
imagesc(nms_fusion),colormap(gray),axis image, axis off;
imwrite(nms_fusion,'nms-1.1.jpg');