root1 = '/Users/marcWong/Dataset/massachuset_dataset/test/';
root2 = '/Users/marcWong/Dataset/massachuset_dataset/test_gt/';
root3 = '/Users/marcWong/Dataset/massachuset_dataset/train/';
root4 = '/Users/marcWong/Dataset/massachuset_dataset/train_gt/';
root5 = '/Users/marcWong/Dataset/massachuset_dataset/val/';
root6 = '/Users/marcWong/Dataset/massachuset_dataset/val_gt/';

root = root6;
listing = dir([root '*.tif']);
fileSum = length(listing); 
for imgNum=1:fileSum
    img = imread(strcat(root,listing(imgNum).name));
    a = strrep(listing(imgNum).name,'.tiff','')
    a = strrep(listing(imgNum).name,'.tif','')
    imwrite(img,[root a '_labelVal.jpg']);
end
