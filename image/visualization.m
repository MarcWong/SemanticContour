%%parameters
expansion_times = 2;
gt_thres = 128;

%%
%fid = fopen('~/train_1.lst');
path = 'visualization/';
fid = fopen('~/ningbo.txt');
while ~feof(fid)
    expansion = expansion_times;
    e = zeros([256 256 3]);
    ec = zeros([256 256 3]);
    file_name = fgetl(fid);
    file_name = strrep(file_name,'train/aug_data/0.0_1_0/','');
    file_name = strrep(file_name,'.jpg','');
    c = imread(['ningbo/' file_name '_canny.jpg']);
    b = imread(['ningbo/' file_name '-gt.png']);
    %c = imread(['train/' file_name '_fusion.jpg']);
    %b = imread(['train/' file_name '-gt.png']);
    %a = imread('canny.jpg');
    if length(size(b))==3
        b = rgb2gray(b);
    end
    
    [m n]=size(b);
    
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
    imwrite(e,[path file_name '_visualization_nomask.png']);
end