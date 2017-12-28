%%parameters
expansion_times = 1;
gt_thres = 128;
block_num  = 5;
% 0 for ningbo3539, 1 for bsds
dataset = 2;
if(dataset == 0)
    fid = fopen('ningbo.txt');
    path = 'image/ningbo/';
    %unet_path = '/Users/marcWong/Dataset/unet-result/';
elseif dataset ==1
    fid = fopen('train_1.lst');
    path = 'image/train/';
else
    fid = fopen('/Users/marcWong/Tools/imgProcess/split.txt');
    path = '/Users/marcWong/Dataset/hed-newdataset-output/';
    outputpath = '/Users/marcWong/Dataset/hed-newdataset-output/';
end
%%
while ~feof(fid)
    file_name = fgetl(fid);
    file_name = strrep(file_name,'train/aug_data/0.0_1_0/','');
    file_name = strrep(file_name,'.jpg','');
    c = imread([path file_name '_nms.jpg']);
    b = imread([path file_name '_canny_mask.jpg']);
    [m n]=size(c);
    
    %%
    %visualization of seed points
    %{
    seed = uint8(zeros(m,n));
    for ii = 1:m
        for jj = 1:n
            if c(ii,jj)>128 && b(ii,jj)>128
                seed(ii,jj) = 255;
            end
        end
    end
    imwrite(seed,[outputpath file_name '_seed.png']);
    %}
    
    %%
    %waterfilling
    e = false([m n]);
    visit = false([m n]);
    
    c=c>128;
    b=b>128;
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
    %%
    % morphing
    
    %{
    e_exp = expand(e,0,expansion_times);
    e2 = false([m n]);
    
    for ii = 1:m
        for jj = 1:n
            temp_x=0; temp_y=0; sum=0;
            visit = false([m n]);
            if e(ii,jj) && visit(ii, jj) ==0
                temp_x=ii; temp_y=jj; sum=0;
                visit(ii, jj)=1;
                neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];  %8 neighbor
                queue_head=1; queue_tail=1;
                q{queue_tail} = [ii jj];
                queue_tail = queue_tail+1;
                [ser1 ser2] = size(neighbour);
                while queue_head ~= queue_tail
                    pix = q{queue_head};
                    for i = 1:ser1
                        pix1 = pix+neighbour(i,:);
                        if pix1(1)>=1 && pix1(1)<=m && pix1(2)>=1 && pix1(2)<=n && e(pix1(1), pix1(2))==1 && visit(pix1(1), pix1(2))==0
                            visit(pix1(1), pix1(2)) =1;
                            sum = sum+1;
                            if sum <= block_num
                                q{queue_tail} = [pix1(1) pix1(2)];
                                queue_tail = queue_tail+1;
                            end
                        end
                    end
                    queue_head = queue_head+1;
                end
            end
            if sum>block_num
                e2(temp_x, temp_y) =1;
            end
        end
    end
    %}
    imwrite(e,[outputpath file_name '_expansion_cmask_morphing.png']);
end