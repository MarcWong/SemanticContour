%%parameters
expansion_times = 1;
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
visualParameter = '_houghbw';
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
    %c = expand(c,0,1);
    %c = imread([nmspath file_name '_expansion_cmask.png']);
    if max(max(c(:,:)))==1
        c = uint8(c).*255;
    end
    b = imread([filepath file_name '.jpg']);
    [m n]=size(c);
    for i = 1:m
        for j = 1:n;
            if c(i,j)>128
                b(i,j,1) = 255;
                b(i,j,2) = 0;
                b(i,j,3) = 0;
            end
        end
    end
    imwrite(b,[outputpath file_name '_visualization_' visualParameter '.png']);
end