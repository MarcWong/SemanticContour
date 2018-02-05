function out =  expand(img_in,thres,step)
    if length(size(img_in)) == 3
        img_in = rgb2gray(img_in);
    end
    max_val = max(max(img_in(:,:)));
    [m n] = size(img_in);
    out = zeros([m n]);
    unvisit = true([m n]);
    for i = 1+step:m-step
        for j = 1+step:n-step
            if img_in(i,j)>thres && unvisit(i,j)
                unvisit(i,j) = false;
                for x = i-step:i+step
                    for y = j-step:j+step
                        out(x,y)=max_val;
                    end
                end
            end
        end
    end
    if max_val == 1
        out = logical(out);
    else
        out = uint8(out);
    end
end