    % =========================================================================  
    %                   Snakes?Active Contour Models  
    % =========================================================================  
    % By gujinjin 2012/12/10-12  Sunny  
    % ??KASS??????  
    % ?????  
    % [1] KASS etc.Snakes?Active Contour Models  
    % [2] CSDN ?? - Author?????Tone  
    % [3] Ritwik Kumar(Harvard University),D.Kroon?Twente University)???  
    % [4] ???????????  
    % ------  
    clc;clf;clear all;  
      
    % =========================================================================  
    %                      ????????  
    % =========================================================================  
    % ??????  
    %I = imread('/Users/marcWong/Dataset/snake/out1_patch0_6_nms.jpg');
    I = imread('/Users/marcWong/Dataset/snake/demo.jpg');
    % ???????  
    I = im2double(I);   
    % ??????????  
    if(size(I,3)==3), I=rgb2gray(I); end  
    figure(1),imshow(I);  
    %---------------------------  
    %        ????  
    %---------------------------  
    sigma=1;  
    % ??????????????H  
    H = fspecial('gaussian',ceil(3*sigma), sigma);  
    % ?????????,???I?????  
    Igs = filter2(H,I,'same');  
    %Igs = I;
    %---------------------------  
    %      ??Snake????  
    %---------------------------  
    figure(2),imshow(Igs);  
    x=[];y=[];c=1;N=100; %??????c,??N  
    % ??User???????  
    % [x,y]=getpts  
    
    while c<N  
        [xi,yi,button]=ginput(1);  
        % ??????  
        x=[x xi];  
        y=[y yi];  
        hold on  
        % text(xi,yi,'o','FontSize',10,'Color','red');  
        plot(xi,yi,'ro');  
        % ??????????  
        if(button==3), break; end  
        c=c+1;  
    end  
    
    %{
    c = 6;
    x = [12.0000  120.0000  264.0000  392.0000  258.0000  158.0000];
    y = [56.0000  216.0000  398.0000  339.0000  119.0000   14.0000];
    %}
    % ???????????????Snake?  
    
    xy = [x;y];  
    c=c+1;  
    xy(:,c)=xy(:,1);  
    % ??????  
    
    t=1:c;  
    ts = 1:0.1:c;  
    xys = spline(t,xy,ts);  
    xs = xys(1,:);  
    ys = xys(2,:);  
    %{
    xys = xy;
    xs = xys(1,:);  
    ys = xys(2,:);  
    %}
    % ??????  
    hold on  
    temp=plot(x(1),y(1),'ro',xs,ys,'b.');  
    legend(temp,'??','???');  
      
    % =========================================================================  
    %                     Snakes??????  
    % =========================================================================  
    NIter =1000; % ????  
    alpha=0.2; beta=0.2; gamma = 1; kappa = 0.1;  
    wl = 0; we=0.4; wt=0;  
    [row col] = size(Igs);  
      
    % ???-???  
    Eline = Igs;  
    % ???-???  
    [gx,gy]=gradient(Igs);  
    %gx = Igs;
    %gy = Igs;
    Eedge = -1*sqrt((gx.*gx+gy.*gy));  
    % ???-????  
    % ???????????????????????  
    m1 = [-1 1];   
    m2 = [-1;1];  
    m3 = [1 -2 1];   
    m4 = [1;-2;1];  
    m5 = [1 -1;-1 1];  
    cx = conv2(Igs,m1,'same');  
    cy = conv2(Igs,m2,'same');  
    cxx = conv2(Igs,m3,'same');  
    cyy = conv2(Igs,m4,'same');  
    cxy = conv2(Igs,m5,'same');  
      
    for i = 1:row  
        for j= 1:col  
            Eterm(i,j) = (cyy(i,j)*cx(i,j)*cx(i,j) -2 *cxy(i,j)*cx(i,j)*cy(i,j) + cxx(i,j)*cy(i,j)*cy(i,j))/((1+cx(i,j)*cx(i,j) + cy(i,j)*cy(i,j))^1.5);  
        end  
    end  
      
    %figure(3),imshow(Eterm);  
    figure(4),imshow(abs(Eedge));  
    % ??? Eext = Eimage + Econ  
    %Eext = wl*Eline + we*Eedge + wt*Eterm;  
    Eext = -Igs;
    % ????  
    [fx,fy]=gradient(Eext);  
      
    xs=xs';  
    ys=ys';  
    [m n] = size(xs);  
    [mm nn] = size(fx);  
      
    % ????????  
    % ??: ???14? b(i)??vi??(i=i-2 ? i+2)  
    b(1)=beta;  
    b(2)=-(alpha + 4*beta);  
    b(3)=(2*alpha + 6 *beta);  
    b(4)=b(2);  
    b(5)=b(1);  
      
    A=b(1)*circshift(eye(m),2);  
    A=A+b(2)*circshift(eye(m),1);  
    A=A+b(3)*circshift(eye(m),0);  
    A=A+b(4)*circshift(eye(m),-1);  
    A=A+b(5)*circshift(eye(m),-2);  
      
    % ??????  
    [L U] = lu(A + gamma.* eye(m));  
    Ainv = inv(U) * inv(L);   
      
    % =========================================================================  
    %                      ????  
    % =========================================================================  
    %text(10,10,'+','FontName','Time','FontSize',20,'Color','red');  
    % ????  
    figure(3)  
    for i=1:NIter;  
        ssx = gamma*xs - kappa*interp2(fx,xs,ys);  
        ssy = gamma*ys - kappa*interp2(fy,xs,ys);  
       
        % ??snake????  
        xs = Ainv * ssx;  
        ys = Ainv * ssy;  
          
        % ??snake????  
        imshow(I);   
        hold on;  
        plot([xs; xs(1)], [ys; ys(1)], 'r-');  
        hold off;  
        pause(0.001)      
    end  