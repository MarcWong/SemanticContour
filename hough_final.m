%%parameters
expansion_times = 1;
gt_thres = 128;
block_num  = 5;
% 0 for ningbo3539, 1 for bsds
dataset = 2;
if(dataset == 0)
    fid = fopen('ningbo.txt');
    path = 'image/ningbo/';
    %unet_path = '/Users/marcWong/Dataset/unet-result/';
elseif dataset ==1
    fid = fopen('train_1.lst');
    path = 'image/train/';
else
    fid = fopen('/Users/marcWong/Tools/imgProcess/split.txt');
    path = '/Users/marcWong/Dataset/hed-newdataset/';
    outputpath = '/Users/marcWong/Dataset/output/';
end

%%
while ~feof(fid)
    file_name = fgetl(fid);
    origin  = imread([path file_name '.jpg']);
    subplot(221), imshow(origin),title('original image');
    img_gray = rgb2gray(origin);
    [m n] = size(img_gray);
    hough_bw=zeros([m n]);
    % the canny edge of image
    
    %thresh=[0.01,0.17];
    %sigma=5;
    %BW=edge(double(img_gray),'canny',thresh,sigma);
    BW = imread([outputpath file_name '_nms_canny.png']);
    BW = imdilate(BW,ones(2));%????
    gt = imread([path file_name '-gt.png']);
    subplot(224), imshow(gt), title('image edge');
    % the theta and rho of transformed space
    [H,Theta,Rho] = hough(BW,'RhoResolution',8);
    subplot(222), imshow(H,[],'XData',Theta,'YData',Rho,'InitialMagnification','fit'),...
        title('rho\_theta space and peaks');
    xlabel('\theta'), ylabel('\rho');
    axis on, axis normal, hold on;
    % label the top x intersections
    %P  = houghpeaks(H,100,'threshold',ceil(0.3*max(H(:))));
    P  = houghpeaks(H,200);
    x = Theta(P(:,2)); 
    y = Rho(P(:,1));
    plot(x,y,'*','color','r');
    %% find lines and plot them
    lines = houghlines(BW,Theta,Rho,P,'FillGap',20,'MinLength',40);
    subplot(221), hold on
    max_len = 0;
    for k = 1:length(lines)
     xy = [lines(k).point1; lines(k).point2];
     if xy(1,1) > xy(2,1)
         x1 = xy(2,1)*1.0;
         y1 = xy(2,2)*1.0;
         x2 = xy(1,1)*1.0;
         y2 = xy(1,2)*1.0;
         delta = (y2-y1) / (x2-x1);
         Q1 = [x2,y2];
         Q2 = [x1,y1];
         for kk = x1:x2
             yy = round(y1+(kk-x1)*delta);
             for t = y1:yy
                P= [kk,t];
                d = abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1); 
                if d <= 0.7
                hough_bw(t,kk)=1;
                end
            end
             hough_bw(yy,kk)=1;
         end
     elseif xy(1,1) < xy(2,1) %x1<x2
         x1 = xy(1,1)*1.0;
         y1 = xy(1,2)*1.0;
         x2 = xy(2,1)*1.0;
         y2 = xy(2,2)*1.0;
         delta = (y2-y1) / (x2-x1);
         
         Q1 = [x1,y1];
         Q2 = [x2,y2];
         
         for kk = x1:x2
             yy = round(y1+(kk-x1)*delta);
            
            for t = y1:yy
                P= [kk,t];
                d = abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1); 
                if d <= 0.7
                hough_bw(t,kk)=1;
                end
            end
             
             hough_bw(yy,kk)=1;
         end
     else
         x1 = xy(1,1)*1.0;
         y1 = xy(1,2)*1.0;
         y2 = xy(2,2)*1.0;
         for yy = y1: y2
            hough_bw(yy,x1)=1;
         end
     end
     plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','r');
    end
    subplot(223), imagesc(hough_bw),colormap(gray), axis image, axis off,  title('hough edge');
    
    imwrite(hough_bw,[outputpath file_name '_houghbw.jpg']);
    
    %hough_bw = expand(hough_bw,0,1);
    
    for i = 1:m
        for j = 1:n;
            if hough_bw(i,j) > 0
                origin(i,j,1) = 255;
                origin(i,j,2) = 0;
                origin(i,j,3) = 0;
            end
        end
    end
    imwrite(origin,[outputpath file_name '_hough.jpg']);
    %% counting
    %{
    gt_pos = 0;
    true_pos = 0;
    false_pos = 0;
    true_na = 0;
    false_na = 0;
    for i = 1:256
        for j = 1:256
            if gt(i,j) > 128
                gt_pos = gt_pos+1;
                if hough_bw(i,j) == 1
                    true_pos = true_pos + 1;
                else
                    false_pos = false_pos + 1;
                end
            else
                if hough_bw(i,j) == 1
                    false_na = false_na + 1;
                else
                    true_na = true_na + 1;
                end
            end
        end
    end
    %accuracy
    disp((true_pos+true_na)/(256*256)*1.0);
    %precision
    disp(true_pos/(true_pos+false_pos)*1.0);
    %recall
    disp(true_pos/(true_pos+false_na)*1.0);    
    %}
end