gtpath = '/Users/marcWong/Dataset/ningbo3539/gt/';
srcpath = '/Users/marcWong/Dataset/ningbo3539/src/';
list = dir([gtpath '*.png']);
for i = 1:length(list)
    imggt = imread([gtpath list(i).name]);
    %imggt = imresize(imggt,[1920 1080]);
    img = imread([srcpath strcat(strrep(list(i).name,'.png',''),'.jpg')]);
    %subplot(2,2,1);
    %imshow(img);
    %title('data');
    
    %subplot(2,2,2);
    %imagesc(imggt);
    %colormap(gray)
    %axis image
    %title('ground truth');
    
    %BW_sobel = edge(imggt,'sobel');
    %imwrite(BW_sobel,'/Users/marcWong/Desktop/sobel.jpg')
    %BW_prewitt = edge(imggt,'prewitt');
    %imwrite(BW_prewitt,'/Users/marcWong/Desktop/prewitt.jpg')
    %BW_roberts = edge(imggt,'roberts');
    %imwrite(BW_roberts,'/Users/marcWong/Desktop/roberts.jpg')
    %BW_laplace = edge(imggt,'log');
    %imwrite(BW_laplace,'/Users/marcWong/Desktop/laplace.jpg')
    img = rgb2gray(img);
    BW_canny = edge(img,'canny');
    %imwrite(BW_canny,'/Users/marcWong/Desktop/canny.jpg')
    imshow(BW_canny);
    
    img(:,:,1) = img(:,:,1) + uint8(BW_canny)*255;
    img(:,:,2) = img(:,:,2) + uint8(BW_canny)*1;
    img(:,:,3) = img(:,:,3) + uint8(BW_canny)*1;
    
    %subplot(1,2,1);
    imshow(img);
    %subplot(1,2,2);
    %imagesc(uint8(BW_sobel),[0 1]);
    %colormap(gray)
    %axis image
    
    imwrite(img,['/Users/marcWong/Desktop/lab/ningbo3539_edge_gt/src/' strrep(list(i).name,'.png','') '.jpg']);
    imwrite(255.*uint8(BW_canny),['/Users/marcWong/Desktop/lab/ningbo3539_edge_gt/gt/' list(i).name]);
    
    %pause(1/10);
end
