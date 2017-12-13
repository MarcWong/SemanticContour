%%parameters
low_threshold = 50;
high_threshold = 166;
%k = 5;
%nms_threshold = [0.8*k k];
load_from_mat = 0;
%%
%fid = fopen('~/train_1.lst');
%path = 'image/train/';
fid = fopen('~/ningbo.txt');
path = 'image/ningbo/';
while ~feof(fid)
    file_name = fgetl(fid);
    file_name = strrep(file_name,'train/aug_data/0.0_1_0/','');
    file_name = strrep(file_name,'.jpg','');
    origin = imread([path file_name '.jpg']);
    gt = rgb2gray(imread([path file_name '-gt.png']));

    if load_from_mat == 1
        load([path file_name '.mat']);
        a1 = double(FrameStack{1});
        a2 = double(FrameStack{2});
        a3 = double(FrameStack{3});
        a4 = double(FrameStack{4});
        a5 = double(FrameStack{5});
        a6 = double(FrameStack{6});
        aa =(a1 + a2 + a3 + a4 + a5 + a6)./6;%fusion image
        aa = uint8(aa.*255);
    else
        a1 = imread([path file_name '-out1.png']);
        a2 = imread([path file_name '-out2.png']);
        a3 = imread([path file_name '-out3.png']);
        a4 = imread([path file_name '-out4.png']);
        a5 = imread([path file_name '-out5.png']);
        a6 = imread([path file_name '-fuse.png']);
        if length(size(a1))==3
            a1 = rgb2gray(a1);
            a2 = rgb2gray(a2);
            a3 = rgb2gray(a3);
            a4 = rgb2gray(a4);
            a5 = rgb2gray(a5);
            a6 = rgb2gray(a6);
        end
        aa =uint8((uint16(a1) + uint16(a2) + uint16(a3) + uint16(a4) + uint16(a5)+uint16(a6))./6.0);%fusion image
    end

    [m n] = size(aa);

    for i = 1:m
        for j = 1:n
            if aa(i,j) < low_threshold %threshold
                aa(i,j) = 0;
            %elseif aa(i,j) > high_threshold
             %   aa(i,j) = 255;
            end
        end
    end
    sh = graythresh(aa) + 0.06;
    mask = im2bw(aa, sh);
    imagesc(mask);
    %imshow(aa);
    imwrite(aa,[path file_name '_fusion.jpg']);
    nms1 = nms(a1);
    nms2 = nms(a2);
    nms3 = nms(a3);
    nms4 = nms(a4);
    nms5 = nms(a5);
    nms_fusion = nms(aa);

    %{
    figure;
    subplot(221);
    imshow(origin);
    subplot(222);
    imshow(gt);
    subplot(223);
    imagesc(nms1),colormap(gray),axis image, axis off;
    subplot(224);
    imagesc(nms_fusion),colormap(gray),axis image, axis off;
    %}
    origin_bw = rgb2gray(origin);
    canny_bw = edge(origin_bw,'canny');
    canny_bw = canny_bw .* mask;
    nms_fusion = nms_fusion .* mask;
    imwrite(canny_bw,[path file_name '_canny_mask.jpg']);
    imwrite(nms_fusion,[path file_name '_nms.jpg']);
end