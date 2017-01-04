clear;
clc;
close all;
Files = '../../database/';
% Name = 'colorcast_normal.bmp';
% Name = 'colorcast_yellow.bmp';
% Name = 'colorcast_red.bmp';
Name = '图片2.jpg';
img=imread([ Files, Name ]);
img_double=double(img);
R=img_double(:,:,1);
G=img_double(:,:,2);
B=img_double(:,:,3);
%求平均
avR=mean(mean(R));
avG=mean(mean(G));
avB=mean(mean(B));

grayvalue=(avR+avG+avB)/3;
sr=grayvalue/avR;
sg=grayvalue/avG;
sb=grayvalue/avB;

R=sr*R;
G=sg*G;
B=sb*B;
Rmax=max(max(R));
Gmax=max(max(G));
Bmax=max(max(B));
RGBmax=[Rmax,Gmax,Bmax];
factor=max(RGBmax);
factor=factor/255;
if (factor>1)
    R=R/factor;
    G=G/factor;
    B=B/factor;
end
new_img=cat(3,R,G,B);
nimg=uint8(new_img);
figure, imshow(nimg);%
figure, imshow(img);
% imwrite(uint8(img),'F:\3.22\410\liu\RGB\74.jpg');
% imwrite(nimg,strcat('F:\3.22\gy\矫正\',num2str(ii),'.jpg'));
% end
