%%parameters
expansion_times = 2;
gt_thres = 128;
% 0 for ningbo3539, 1 for bsds
dataset = 0;
visualParameter = 'expansion_nms';
file_suffix = '.png';
if dataset == 0
    filepath = 'ningbo/';
    nmspath = 'output/';
    path = 'visualization/';
    fid = fopen('~/ningbo.txt');
else
    filepath = 'train/';
    nmspath = 'bsds_output/';
    path = 'bsds_visualization/';
    fid = fopen('~/train_1.lst');
end
%%
while ~feof(fid)
    file_name = fgetl(fid);
    file_name = strrep(file_name,'train/aug_data/0.0_1_0/','');
    file_name = strrep(file_name,'.jpg','');
    
    c = imread([nmspath file_name '_' visualParameter file_suffix]);
    %c = imread([nmspath file_name '_expansion_cmask.png']);
    if max(max(c(:,:)))==1
        c = uint8(c).*255;
    end
    b = imread([filepath file_name '-gt.png']);
    %c = imread(['train/' file_name '_fusion.jpg']);
    %b = imread(['train/' file_name '-gt.png']);
    %a = imread('canny.jpg');
    if length(size(b))==3
        b = rgb2gray(b);
    end
    
    [m n]=size(b);
    e = zeros([m n 3]);
    
    expansion = expansion_times;
    while expansion > 0
        b = expand(b,gt_thres);
        expansion = expansion -1;
    end
    for i = 1:m
        for j = 1:n
            if c(i,j)>150 && b(i,j)>gt_thres
                e(i,j,1) = 255;
            elseif c(i,j)>150 && b(i,j)<= gt_thres
                e(i,j,2) = 255;
            elseif b(i,j)>gt_thres && c(i,j)<= 150
                e(i,j,3) = 255;
            end
        end
    end

    %e = (e + ec);

    e=uint8(e);
    imwrite(e,[path file_name '_visualization_' visualParameter '.png']);
end