%%parameters
expansion_times = 5;
gt_thres = 128;
% 0 for ningbo3539, 1 for bsds
dataset = 2;
%----------------------------------------%
%optional parameters:
%_expansion_cmask_morphing
%_expansion_cmask
%.png

%_canny
%.jpg
visualParameter = '_nms';
file_suffix = '.jpg';
%----------------------------------------%

if(dataset == 0)
    filepath = 'ningbo/';
    nmspath = 'output/';
    path = 'visualization/';
    fid = fopen('../ningbo.txt');
elseif dataset ==1
    filepath = 'train/';
    nmspath = 'bsds_output/';
    path = 'bsds_visualization/';
    fid = fopen('../train_1.lst');
else
    fid = fopen('/Users/marcWong/Tools/imgProcess/split.txt');
    filepath = '/Users/marcWong/Dataset/hed-newdataset/';
    nmspath = '/Users/marcWong/Dataset/output/';
    outputpath = '/Users/marcWong/Dataset/output/';
end
%%
while ~feof(fid)
    file_name = fgetl(fid);
    file_name = strrep(file_name,'train/aug_data/0.0_1_0/','');
    file_name = strrep(file_name,'.jpg','');
    
    c = imread([nmspath file_name visualParameter file_suffix]);
    %c = imread([nmspath file_name '_expansion_cmask.png']);

    if max(max(c(:,:)))==1
        c = uint8(c).*255;
    end
    
    
    b = imread([filepath file_name '-gt.png']);
    %b = imread([outputpath file_name '_fusion.jpg']);
    %b = imread(['train/' file_name '-gt.png']);
    %a = imread('canny.jpg');
    if length(size(b))==3
        b = rgb2gray(b);
    end
    
    bb = imread([filepath file_name '.jpg']);
    [m n]=size(b);
    
    e = zeros([m n 3]);
    
    b = expand(b,gt_thres,expansion_times);
    for i = 1:m
        for j = 1:n
            if c(i,j)>150 && b(i,j)>gt_thres
                e(i,j,1) = 255;
                bb(i,j,1) = 255;
                bb(i,j,2) = 0;
                bb(i,j,3) = 0;
            elseif c(i,j)>150 && b(i,j)<= gt_thres
                e(i,j,2) = 255;
            elseif b(i,j)>gt_thres && c(i,j)<= 150
                e(i,j,3) = 255;
            end
        end
    end

    %e = (e + ec);

    e=uint8(e);
    
    imwrite(bb,[outputpath file_name '_visualization_gt' visualParameter '.png']);
    imwrite(e,[outputpath file_name '_visualization' visualParameter '.png']);
end