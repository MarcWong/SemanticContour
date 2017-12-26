fid = fopen('~/ningbo.txt');
filepath='/Users/marcWong/Dataset/hed-result/';
while ~feof(fid)
    file_name = fgetl(fid);
    ab = imread([filepath file_name '.png']);
    %x = ab(:,1:256,:);
    %imwrite(x,[filepath file_name '.jpg']);
    x = ab(:,256+1:256*2,:);
    imwrite(x,[filepath file_name '-gt.png']);
    %{
    x = ab(:,256*2+1:256*3,:);
    imwrite(x,[filepath file_name '-out1.png']);
    x = ab(:,256*3+1:256*4,:);
    imwrite(x,[filepath file_name '-out2.png']);
    x = ab(:,256*4+1:256*5,:);
    imwrite(x,[filepath file_name '-out3.png']);
    x = ab(:,256*5+1:256*6,:);
    imwrite(x,[filepath file_name '-out4.png']);
    x = ab(:,256*6+1:256*7,:);
    imwrite(x,[filepath file_name '-out5.png']);
    x = ab(:,256*7+1:256*8,:);
    imwrite(x,[filepath file_name '-fuse.png']);
    %}
end