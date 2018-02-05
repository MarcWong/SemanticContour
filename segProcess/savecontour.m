function out = savecontour(img,outputpath,minThres)
%img: input image
%minThres: minmum number of pixels of a valid contour
[m, n] = size(img);
if max(img(:)) > 1
    b = img > 128;
else
    b = img;
end
visit = false([m n]);
cnt = 0;
for ii = 1:m
    for jj = 1:n
        if b(ii,jj) && visit(ii,jj)==0 %find a new set
            e = false([m n]);
            visit(ii,jj)=1;
            
            e(ii,jj)=1;%select this point
            %fprintf(fid,'%d %d\n',ii,jj);%write to file
            
            queue_head=1;
            queue_tail=1;
            neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];  %8 neighbor
            %neighbour=[-1 0;1 0;0 1;0 -1];     %4 neighbor
            q{queue_tail}=[ii jj];
            queue_tail=queue_tail+1;
            [ser1 , ~]=size(neighbour);
            
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
                            %if mod(queue_tail,2) == 0
                                %fprintf(fid,'%d %d\n',pix1(1),pix1(2));  
                                %e(pix1(1),pix1(2)) = queue_tail/5;
                            %end
                        end
                    end
                end
                queue_head=queue_head+1;
            end
            %imagesc(e);
            if length(find(e==1)) > minThres
                cnt = cnt+1;
                imwrite(uint8(e).*255,[outputpath 'contour' num2str(cnt) '.jpg']);
            end
        end
    end
end