%use these parameters when random crop
srcpath = ['/Users/marcWong/Desktop/' theta_and_flip];
%outputpath = ['/Users/marcWong/Desktop/lab/ningbo3539_edge_gt/train/aug_gt_scale_1.5/' theta_and_flip];
outputpath2 = ['/Users/marcWong/Desktop/lab/ningbo3539_edge_gt/train/aug_gt_scale_0.5/' theta_and_flip];


%use these parameters when scaling
theta_and_flip = '315.0_1_0/';
%srcpath = ['/Users/marcWong/Desktop/lab/ningbo3539_edge_gt/train/aug_gt/' theta_and_flip];
%outputpath = ['/Users/marcWong/Desktop/lab/ningbo3539_edge_gt/train/aug_gt_scale_1.5/' theta_and_flip];
%outputpath2 = ['/Users/marcWong/Desktop/lab/ningbo3539_edge_gt/train/aug_gt_scale_0.5/' theta_and_flip];

%use these parameters when flipping
%theta_str = '270.0';
%srcpath = ['/Users/marcWong/Desktop/lab/ningbo3539_edge_gt/train/aug_gt/' theta_str '_1_0/'];
%outputpath = ['/Users/marcWong/Desktop/lab/ningbo3539_edge_gt/train/aug_gt/' theta_str '_1_1/'];


%use these parameters when rotation
%srcpath = '/Users/marcWong/Desktop/lab/ningbo3539_edge_gt/train/aug_gt/0.0_1_0/';
%theta_str = '315.0'; %please add '.0' if it's a integer angle
%theta = str2double(theta_str);
%outputpath = ['/Users/marcWong/Desktop/lab/ningbo3539_edge_gt/train/aug_gt/' theta_str '_1_0/'];


list = dir([srcpath '*.png']);
for i = 1:length(list)
    img = imread([srcpath list(i).name]);
    
    %%  scale
    
    %imgout = imresize(img,[1920 1080]);
    %imgout = imresize(img,1.5); % parameter of scaling
    imgout2 = imresize(img,0.5);
   %%  flip
    
    %imgout = flip(img,1);
   
   %%   rotate  %
    
    %{
    arch = mod(theta,90)/180*3.14;
    imgout = imrotate(img,theta);%rotate a specific angle
    if mod(theta,90) ~= 0
        [x, y, c] = size(imgout);
        crop_width = floor(256 / (cos(arch)*(1+tan(arch))));
        imgout = imgout((x-crop_width)/2:(x+crop_width)/2,(x-crop_width)/2:(x+crop_width)/2,:);
    end
   %}
    
   %% plot
    %subplot(1,2,1);
    %imshow(img);
    %subplot(1,2,2);
    %imshow(imgout);
    %pause(1/10000);
    
    %% output
    %imwrite(imgout,[outputpath list(i).name]);
    imwrite(imgout2,[outputpath2 list(i).name]);
end