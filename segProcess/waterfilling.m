function out =  waterfilling(outputpath)
listing = dir([outputpath '*.jpg']);
imgSum = length(listing);
for imgNum = 1:imgSum
    imgName = [outputpath listing(imgNum).name];
    img = imread(imgName);
    %img2 = uint8(zeros(512,512));
    imgpath=strrep(imgName,'.jpg','');
    outputFile = [imgpath '.txt'];

    [m, n] = size(img);

    %{
    fid = fopen(path,'w');
    cnt = 0;
    p = 0;
    for i = 1:m
        for j = 1:n
            if img(i,j)>128
                cnt = cnt+1;
                if mod(cnt,2) == 1
                    img2(i,j) = 255;
                    fprintf(fid,'%d %d\n',i,j);
                    p = p+1;
                end
            end
        end
    end
    imshow(img2);
    fclose(fid);
    %}
    %{
    point = detectHarrisFeatures(img);

    %imshow(img); hold on;
    a = point.selectStrongest(30);
    x_count = 0;
    y_count = 0;

    %plot(a);
    for i =1:a.Count
        img2(floor(a.Location(i,2)),floor(a.Location(i,1))) = 255;
        x_count = floor(a.Location(i,2))+x_count;
        y_count = floor(a.Location(i,1))+y_count;
    end
    x_count = x_count / a.Count;
    y_count = y_count / a.Count;

    imshow(img2);
    %}

    fid = fopen(outputFile,'w');
    b = img > 128;
    e = false([m n]);
    visit = false([m n]);

    for ii = 1:m
        for jj = 1:n
            if b(ii,jj) && visit(ii,jj)==0

                visit(ii,jj)=1;
                e(ii,jj)=1;%select this point
                fprintf(fid,'%d %d\n',ii,jj);

                queue_head=1;
                queue_tail=1;
                neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];  %8 neighbor
                %neighbour=[-1 0;1 0;0 1;0 -1];     %4 neighbor
                q{queue_tail}=[ii jj];
                queue_tail=queue_tail+1;
                [ser1 , ~]=size(neighbour);

                init_point = 0;
                for w=1:ser1
                    pixn=q{queue_head}+neighbour(w,:);
                    if b(pixn(1),pixn(2)) && init_point == 0
                        init_point = 1;
                        q{queue_tail}=[pixn(1) pixn(2)];
                        queue_tail=queue_tail+1;
                    end
                    visit(pixn(1),pixn(2)) = 1;
                end

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
                                if mod(queue_tail,4) == 0
                                    fprintf(fid,'%d %d\n',pix1(1),pix1(2));
                                    %img2(pix1(1),pix1(2)) = queue_tail/5;
                                end
                            end
                        end
                    end
                    queue_head=queue_head+1;
                end
            end
        end
    end
    fclose(fid);
end
end