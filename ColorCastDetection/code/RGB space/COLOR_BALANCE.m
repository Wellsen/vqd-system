close all;
clear
clc
Files = '../../database/';
% Name = 'colorcast_normal.bmp';
% Name = 'colorcast_yellow.bmp';
Name = 'colorcast_red.bmp';
% Name = '图片2.jpg';
X=imread([ Files, Name ]);

X01=X(:,:,1);
X02=X(:,:,2);
X03=X(:,:,3);

%%%%%%%%%%%%%%%%%%%原图%%%%%%%%%%%%%%%%%%%%%%%5
figure (1)
subplot(1,3,1)
imshow(X01)
title('红')
subplot(1,3,2)
imshow(X02)
title('绿')
subplot(1,3,3)
imshow(X03)
title('蓝')

figure(2)
%subplot(2,3,4)
imshow(X)
title('原图')

%%%%%%%%%%%%%%%%%%%白平衡%%%%%%%%%%%%%%%%%%%%%%%5
Y=0.299*X01+0.587*X02+0.114*X03;
Ymax=max(max(Y));
Ymean=mean(mean(Y));
Y=Y>=0.95*Ymax;
Sy=sum(sum(Y));
Rmean=sum(X01(Y))/Sy;
Gmean=sum(X02(Y))/Sy;
Bmean=sum(X03(Y))/Sy;
X1(:,:,1)=Ymean/Rmean*X01;
X1(:,:,2)=Ymean/Gmean*X02;
X1(:,:,3)=Ymean/Bmean*X03;

% subplot(2,3,5)
figure (3)
imshow(X1)
title('白平衡法')

%%%%%%%%%%%%%%%%%%%最大颜色值平衡法%%%%%%%%%%%%%%%%%%%%%%%5
Rmax=max(max(X01));%255
Gmax=max(max(X02));%236
Bmax=max(max(X03));%246
Cmax=min([Rmax,Gmax,Bmax]);
Nr=sum(sum(X01>=Cmax));%4302
Ng=sum(sum(X02>=Cmax));%1
Nb=sum(sum(X03>=Cmax));%7
Nmax=max([Nr,Ng,Nb]);
for pix=Rmax:-1:0%红
    Lr=X01>=pix;
    nr=sum(sum(Lr));
    if nr>=Nmax
        Rth=pix;
        break
    end
end
for pix=Gmax:-1:0%绿
    Lr=X02>=pix;
    nr=sum(sum(Lr));
    if nr>=Nmax
        Gth=pix;
        break
    end
end
for pix=Bmax:-1:0%蓝
    Lr=X03>=pix;
    nr=sum(sum(Lr));
    if nr>=Nmax
        Bth=pix;
        break
    end
end
X2(:,:,1)=double(Cmax)/double(Rth)*X01;
X2(:,:,2)=double(Cmax)/double(Gth)*X02;
X2(:,:,3)=double(Cmax)/double(Bth)*X03;

%subplot(2,3,6)
figure (4);
imshow(X2);
title('最大颜色值平衡法')