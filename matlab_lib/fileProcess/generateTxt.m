fid = fopen('~/ningbo.txt','wt');
for i = 1:708
    fprintf(fid,'%d\n',i);
end