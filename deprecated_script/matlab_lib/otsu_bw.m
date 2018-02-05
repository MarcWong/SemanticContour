function out = otsu_bw(img_in)
    sh = graythresh(img_in) + 0.08;
    out = im2bw(img_in,sh);
    %for x = 0:3
    %    for y = 0:3
    %        img_part = img_in(1+x*64:64 + x*64,1+y*64:64+y*64);
    %        sh = graythresh(img_part)+0.08;
    %        out(1+x*64:64 + x*64,1+y*64:64+y*64) = im2bw(img_part, sh);
    %    end
    %end
end