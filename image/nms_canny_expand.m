%%parameters
expansion_times = 1;
gt_thres = 128;

%%
%fid = fopen('~/train_1.lst');
path = 'output/';
fid = fopen('~/ningbo.txt');
while ~feof(fid)
    expansion = expansion_times;
    e = false([256 256]);
    visit = false([256 256]);
    file_name = fgetl(fid);
    file_name = strrep(file_name,'train/aug_data/0.0_1_0/','');
    file_name = strrep(file_name,'.jpg','');
    c = imread(['ningbo/' file_name '_nms_mask.jpg']);
    b = imread(['ningbo/' file_name '_canny.jpg']);
    
    [m n]=size(c);
    c=c>128;
    b=b>128;
    for ii = 1:m
        for jj = 1:n
            if c(ii,jj) && b(ii,jj) && visit(ii,jj)==0
                e(ii,jj)=1;
                visit(ii,jj)=1;
                tmp=ones(m,n);
                queue_head=1;       %???
                queue_tail=1;       %???
                neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];  %?????????????????
                %neighbour=[-1 0;1 0;0 1;0 -1];     %?????
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
   
    %figure(1);
    %imshow(e);
    imwrite(e,[path file_name '_expansion_nmask.png']);
end
