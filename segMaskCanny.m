function out = segMaskCanny(varargin)
% usage: segMaskCanny(path,os_param);
% os_param = 0 % for unix/mac os
% os_param = 1 % for windows
path = varargin{1};
os_param = varargin{2};

if os_param == 0
    gtpath = [path '/final/' ];
    srcpath = [path '/src/' ];
    outputpath = [path '/output/' ];
    outputVispath = [path '/outputVis/' ];
elseif os_param == 1
    gtpath = [path '\final\' ];
    srcpath = [path '\src\' ];
    outputpath = [path '\output\' ];
    outputVispath = [path '\outputVis\' ];
else
    display('please give a valid os_param, 0 for unix/mac, 1 for windows');
    out = -1;
    return;
end

list = dir([gtpath '*.jpg']);
for k = 1:length(list)
    imggt = imread([gtpath list(k).name]);
    imgsrc = imread([srcpath list(k).name]);
    %imggt = imresize(imggt,0.25);
    %imgsrc = imresize(imgsrc,0.25);
    %imagesc(imggt);
    [m n] = size(imggt);
    for i = 1:m
        for j = 1:n
            if imggt(i,j) == 1
                imggt(i,j) = 255;
            else
                imggt(i,j) = 0;
            end
        end
    end
    %imgCont = edge(imggt,'canny',0.5);
    
    %{
    b = edge(rgb2gray(imgsrc),'canny',0.5);
    c = imgCont .* b;
    %c = expand(c,0,1);

    
    e = false([m n]);
    visit = false([m n]);
    
    %c=c>128;
    %b=b>128;
    for ii = 1:m
        for jj = 1:n
            if c(ii,jj) && b(ii,jj) && visit(ii,jj)==0
                e(ii,jj)=1;
                visit(ii,jj)=1;
                tmp=ones(m,n);
                queue_head=1;
                queue_tail=1;
                neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];  %8 neighbor
                %neighbour=[-1 0;1 0;0 1;0 -1];     %4 neighbor
                q{queue_tail}=[ii jj];
                queue_tail=queue_tail+1;
                [ser1 ser2]=size(neighbour);

                while queue_head~=queue_tail
                    pix=q{queue_head};
                    for i=1:ser1
                        pix1=pix+neighbour(i,:);
                        if pix1(1)>=1 && pix1(2)>=1 &&pix1(1)<=m && pix1(2)<=n
                            if b(pix1(1),pix1(2))==1 && visit(pix1(1),pix1(2)) == 0
                                visit(pix1(1),pix1(2)) = 1;
                                e(pix1(1),pix1(2))=1;
                                q{queue_tail}=[pix1(1) pix1(2)];
                                queue_tail=queue_tail+1;
                            end      
                        end
                    end
                    queue_head=queue_head+1;
                end
            end
        end
    end
    %}
   %{
    e = expand(e,0,3);
    for i = 1:m
        for j = 1:n
            if e(i,j) == 1
                imgsrc(i,j,1) = 255;
                imgsrc(i,j,2) = 0;
                imgsrc(i,j,3) = 0;
            end
        end
    end
    imwrite(imgsrc,[outputVispath list(k).name]);
    %}
    %imwrite(e,[outputpath list(k).name]);

    %{
    for i = 1:m
        for j = 1:n
            if imgCont(i,j)
                imgsrc(i,j,1) = 255;
                imgsrc(i,j,2) = 0;
                imgsrc(i,j,3) = 0;
            end
        end
    end
    imwrite(imgsrc,[outputVispath list(k).name]);
     %} 
    imwrite(imggt,[outputpath list(k).name]);
end
end