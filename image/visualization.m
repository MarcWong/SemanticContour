fid = fopen('~/train_1.lst');
path = 'visualization/';
while ~feof(fid)
    e = zeros([256 256 3]);
    ec = zeros([256 256 3]);
    file_name = fgetl(fid);
    file_name = strrep(file_name,'train/aug_data/0.0_1_0/','');
    file_name = strrep(file_name,'.jpg','');
    c = imread(['train/' file_name '_fusion.jpg']);
    b = imread(['train/' file_name '-gt.png']);
    %a = imread('canny.jpg');
    if length(size(b))==3
        b = rgb2gray(b);
    end
    [m n]=size(b);
    for i = 1:m
        for j = 1:n
            if c(i,j)>150 && b(i,j)>128
                e(i,j,1) = 255;
            elseif c(i,j)>150 && b(i,j)<= 128
                e(i,j,2) = 255;
            elseif b(i,j)>128 && c(i,j)<= 150
                e(i,j,3) = 255;
            end
        end
    end

    %e = (e + ec);

    e=uint8(e);
    imwrite(e,[path file_name '_visualization.png']);
end