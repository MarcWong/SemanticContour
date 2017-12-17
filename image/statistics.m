%% statistics

thres = 128;

gt = imread('out249-gt.jpg');
gt_origin = imread('out249-gt.png');
%nms_img  = imread('out249-fusion.png');
nms_img  = imread('249_canny_mask_0.3.jpg');
nms_img = expand(nms_img,128);
nms_img = expand(nms_img,128);
nms = imread('nms-thres1.5.jpg');
nms_img = nms_img + nms;
if length(size(gt_origin)) == 3
    gt_origin = rgb2gray(gt_origin);
end
sum = 0;
for i = 1:256
    for j = 1:256
        if gt_origin(i,j) == 255
            sum = sum+1;
        end
    end
end

gt_pos = 0;
TP = 0;
FP = 0;
TN = 0;
FN = 0;
for i = 1:256
    for j = 1:256
        if gt(i,j) > thres
            gt_pos = gt_pos+1;
            if nms_img(i,j) > thres
                TP = TP + 1;
            elseif gt_origin(i,j) > thres
                FN = FN + 1;
            end
        else
            if nms_img(i,j) > thres
                FP = FP + 1;
            else
                TN = TN + 1;
            end
        end
    end
end
P = TP/(TP+FP)*1.0;
R = TP/(TP+FN)*1.0;
F1score = 2*P*R/(P+R);
%accuracy
disp(['accuracy ((TP+TN)/(TP+TN+FP+FN))= ' num2str((TP+TN)/(256*256)*1.0)]);
%precision
disp(['precision(TP/(TP+FP))= ' num2str(P)]);
%recall
%disp(['recall(TP/(TP+FN))= ' num2str(true_pos/(true_pos+false_na)*1.0)]);
disp(['recall(TP/(TP+FN))= ' num2str(R)]);

disp(['F1score= ' num2str(F1score)]);