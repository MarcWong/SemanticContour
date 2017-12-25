%% statistics
thres = 128;
dataset = 0;

if dataset == 0
    filepath = 'ningbo/';
    nmspath = 'output/';
    fid = fopen('~/ningbo.txt');
else
    filepath = 'train/';
    nmspath = 'bsds_output/';
    fid = fopen('~/train_1.lst');
end
P_sum = 0;
R_sum = 0;
file_sum = 0;
%%
while ~feof(fid)
    file_name = fgetl(fid);
    file_name = strrep(file_name,'train/aug_data/0.0_1_0/','');
    file_name = strrep(file_name,'.jpg','');
    file_sum = file_sum + 1;
    gt = imread([filepath file_name '-gt-expand.png']);
    %gt = imread([filepath file_name '-gt.png']);
    gt_origin = imread([filepath file_name '-gt.png']);
    %gt_origin = imread([filepath file_name '.png']);
    nms_img  = imread([nmspath file_name '_expansion_cmask.png']); 
    %nms_img  = imread([filepath file_name '_canny.jpg']); 
    %nms_img  = imread([nmspath file_name '_expansion_nms.png']);
    if max(max(nms_img(:,:)))==1
        nms_img = uint8(nms_img) .*255;
    end
    nms_img = expand(nms_img,128);
    nms_img = expand(nms_img,128);
    if length(size(gt_origin)) == 3
        gt_origin = rgb2gray(gt_origin);
    end
    if length(size(gt)) == 3
        gt = rgb2gray(gt);
    end
    gt = expand(gt,128);
    
    sum = 0;
    for i = 1:256
        for j = 1:256
            if gt_origin(i,j) == 255
                sum = sum+1;
            end
        end
    end

    TP = 0;
    FP = 0;
    FN = 0;
    for i = 1:256
        for j = 1:256
            if nms_img(i,j) > thres
                if  gt(i,j)< thres
                    FP = FP + 1;
                else
                    TP = TP + 1;
                end
            else
                if gt_origin(i,j) > thres
                    FN = FN + 1;
                end
            end
        end
    end
    
   %%
    %statistics
    P = TP/(TP+FP)*1.0;
    R = TP/(TP+FN)*1.0;
    P_sum = P_sum + P;
    R_sum = R_sum + R;
    %F1score = 2*P*R/(P+R);
    %mIoU
    %disp(['mIoU (TP/(TP+FP+FN))= ' num2str(TP/(TP+FP+FN)*1.0)]);
    %precision
    %disp(['precision(TP/(TP+FP))= ' num2str(P)]);
    %recall
    %disp(['recall(TP/(TP+FN))= ' num2str(R)]);
    %F1score
    %disp(['F1score= ' num2str(F1score)]);
end
P_sum = P_sum / file_sum;
R_sum = R_sum / file_sum;
F1score = 2*P_sum*R_sum/(P_sum+R_sum);
disp(['result_expansion_nomask']);
disp(['precision(TP/(TP+FP))= ' num2str(P_sum)]);
disp(['recall(TP/(TP+FN))= ' num2str(R_sum)]);
disp(['F1score= ' num2str(F1score)]);