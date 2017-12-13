srcpath = '/Users/marcWong/Dataset/ningbo3539_new/gt/';
newpath = '/Users/marcWong/Dataset/ningbo3539_new/gt/';
list = dir([srcpath '*.png']);
for m = 1:length(list)
    imggt = imread([srcpath list(m).name]);
    %imggt = rgb2gray(imggt);
    %imgcanny = edge(imggt,'canny');
    
    e = zeros([256 256]);

    for i = 2:255
        for j = 2:255
            if imggt(i,j)==1
                e(i-1,j-1)=1;
                e(i,j-1)=1;
                e(i+1,j-1)=1;
                e(i-1,j)=1;
                e(i,j)=1;
                e(i+1,j)=1;
                e(i-1,j+1)=1;
                e(i,j+1)=1;
                e(i+1,j+1)=1;
            end
        end
    end
    %imagesc(e);
    imwrite(uint8(e),[newpath list(m).name]);
end