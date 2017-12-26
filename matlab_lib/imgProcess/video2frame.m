obj = VideoReader('/Users/marcWong/Desktop/1.mov');%??????
numFrames = obj.NumberOfFrame;% ????
 for k = 1 : numFrames% ???15?
     frame = read(obj,k);%?????
     imshow(frame);%???
     imwrite(frame,strcat('/Users/marcWong/Desktop/lab/1/',num2str(k),'.jpg'),'jpg');% ???
 end