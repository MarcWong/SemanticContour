%% statistics

gt = imread('out249-gt-1.jpg');
gt_origin = imread('out249-gt.png');
hough_bw  = imread('nms-thres1.5.jpg');
gt_origin = rgb2gray(gt_origin);
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
        if gt(i,j) > 128
            gt_pos = gt_pos+1;
            if hough_bw(i,j) > 128
                TP = TP + 1;
            elseif gt_origin(i,j) > 128
                FP = FP + 1;
            end
        else
            if hough_bw(i,j) > 128
                FN = FN + 1;
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