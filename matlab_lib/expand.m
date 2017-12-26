function out =  expand(img_in,thres)
    if length(size(img_in)) == 3
        img_in = rgb2gray(img_in);
    end
    max_val = max(max(img_in(:,:)));
    [m n] = size(img_in);
    out = zeros([m n]);
    unvisit = true([m n]);
    for i = 2:m-1
        for j = 2:n-1
            if img_in(i,j)>thres && unvisit(i,j)
                unvisit(i,j) = false;
                out(i-1,j-1)=max_val;
                out(i,j-1)=max_val;
                out(i+1,j-1)=max_val;
                out(i-1,j)=max_val;
                out(i+1,j)=max_val;
                out(i-1,j+1)=max_val;
                out(i,j+1)=max_val;
                out(i+1,j+1)=max_val;
            end
        end
    end
    if max_val == 1
        out = logical(out);
    else
        out = uint8(out);
    end
end