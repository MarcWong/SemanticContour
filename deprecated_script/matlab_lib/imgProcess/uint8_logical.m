gtpath = '/Users/marcWong/Dataset/AerialImageCroppedDataset/train/val_gt/';
list = dir([gtpath '*.jpg']);
for i = 1:length(list)
    imggt = imread([gtpath list(i).name]);
    imggt = imggt./255;
    imwrite(imggt,[gtpath list(i).name]);
end