srcpath = '/Users/marcWong/Dataset/ningbo3539/src/';
list = dir([srcpath '*.jpg']);
for i = 1:length(list)
    img = imread([srcpath list(i).name]);
    img = imresize(img,0.5);
    I=rgb2gray(img); 
    [x,y]=size(I);
    BW=edge(I);
    
    rho_max=floor(sqrt(x^2+y^2))+1;  
    accarray=zeros(rho_max,180);    
    Theta=[0:pi/180:pi];          

    for n=1:x,
    for m=1:y
      if BW(n,m)==1
         for k=1:180
            rho=(m*cos(Theta(k)))+(n*sin(Theta(k)));
            rho_int=round(rho/2+rho_max/2);
            accarray(rho_int,k)=accarray(rho_int,k)+1;
         end
      end
    end
    end

    %figure;colormap gray;
    %imagesc(accarray);title('hough?????')
    %xlabel('\theta'), ylabel('\rho');

    %=====?????????????=====%
    %accarray=uint8(accarray);                %???????
    %figure;imshow(accarray);title('hough?????')
    %xlabel('\theta'), ylabel('\rho');
    %axis on, axis normal, hold on;

    %=======??hough??????======%
    %??100?????????hough???????
    K=1;                    %???????
    for rho_n=1:rho_max     %?hough?????????
    for theta_m=1:180
        if accarray(rho_n,theta_m)>=10 %?????????
            case_accarray_n(K)=rho_n;     %??????????
            case_accarray_m(K)=theta_m;
            K=K+1;
        end
    end
    end
    %?????????????,???????I_out
    I_out=zeros(x,y);
    I_jiao_class=zeros(x,y);
    for n=1:x,
    for m=1:y
      if BW(n,m)==1
         for k=1:180
            rho=(m*cos(Theta(k)))+(n*sin(Theta(k)));
            rho_int=round(rho/2+rho_max/2);
            %??????????100?????????????
            for a=1:K-1
                if rho_int==case_accarray_n(a)&&k==case_accarray_m(a)%%%==gai==%%% k==case_accarray_m(a)&rho_int==case_accarray_n(a)
                    I_out(n,m)=BW(n,m);  
                    I_jiao_class(n,m)=k;
                end
            end
         end
      end
    end
    end
    figure;imshow(I_out);title('hough trans');

%========hough??=========%
%=====matlab????========%
% ????? BW??????H
% [H,T,R] = hough(BW,'RhoResolution',0.5,'ThetaResolution',0.5);
% figure;imshow(H,'XData',T,'YData',R,'InitialMagnification','fit');title('hough????')
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;
    
    %C = corner(rgb2gray(img),'FilterCoefficients',fspecial('gaussian',[7 1],1),'QualityLevel',0.005,'SensitivityFactor',0.01);
    %figure;
    %imshow(img);
    %hold on;
    %plot(C(:,1), C(:,2), 'r.');
    
    %imagesc(uint8(BW_sobel),[0 1]);
    %colormap(gray)
    %axis image
    
   
    %pause(1/10);
end
