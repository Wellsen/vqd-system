
function [L_rt, a_rt, b_rt, radius, u, D, Dq] = img_ecircle(Img_sur, Img_name)
% tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%第一步骤：实现rgb->Lab功能
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cform = makecform('srgb2lab');
if isa(Img_sur, 'uint8')
    Img_sur = double(Img_sur)/255;
end
Lab = applycform(Img_sur, cform);
%Img_sur = uint8(Img_sur * 255);
% [M, N, d] = size(Img_sur);
L_rt = Lab(:, :, 1);
a_rt = Lab(:, :, 2);
b_rt = Lab(:, :, 3);

%[M, N] = size(a_rt);
L = uint8(L_rt);
a = uint8(a_rt + 128);
b = uint8(b_rt + 128);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%第二步骤：求解ab平面二维直方图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h_grayX = imhist(a);  %该函数用于获取图像数据直方图
h_grayY = imhist(b); %该函数用于获取图像数据直方图 
ind_grayX = find(h_grayX)-1;  %返回所有非0的元素的位置,该位置的值即为像素值，结果为所有个数不为0的像素
ind_grayY = find(h_grayY)-1; 
[X,Y] = meshgrid(ind_grayX,ind_grayY);%用于生成网格采样点的函数，生成绘制3-D图形所需的网格数据。在进行3-D图形绘制方面有广泛应用  
[m,n] = size(X);   % m是grayind_avr的长度，n是grayind的长度  
data = zeros(m,n); %data中的内容即为二维直方图数据
% 遍历存在的灰度与均值，寻找对应像素并计数  

%a_X = uint8(zeros(M, N, n));
for x_i = 1:n
    a_X(:, :, x_i) = (uint8(a) == X(1, x_i));
end
%b_Y = uint8(zeros(M, N, m));
for y_i = 1:m
    b_Y(:, :, y_i) = (uint8(b) == Y(y_i, 1));
end

 for i=1:m
     grayY = b_Y(:, :, i);
     for j=1:n
         grayX = a_X(:, :, j);  %gray为和I同大小的矩阵，与X(i,j)相等的元素处为1，其他处为0
         data(i,j) = length(find(grayX & grayY));  
     end
 end
 
clear a_X;
clear b_Y;


X = X - 128;
Y = Y - 128;
surf(X, Y, data); 
xlabel('A');  
ylabel('B');  
zlabel('像素数');
title(sprintf('%s的ab二维平面直方图',Img_name));
saveas(gcf, sprintf('%s的ab二维平面直方图.bmp',Img_name), 'bmp');
delete(gcf);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %第三步骤：求解ab直方图的拟合曲线
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_via = (linspace(-128, 127, 256)); %a和b的范围为-128-127（(包含)-128--127的共256个元素）
x_via = t_via';%,x_via表示k
%此处的归一化是将所有像素点的分布进行归一化，即像素点的个数为（0,1）的比例值
h_grayX = h_grayX / sum(h_grayX);%h_grayX表示F(a,b)
h_grayY = h_grayY / sum(h_grayY);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%第四步骤：求解二维直方图对应等价圆
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%第一种方法--------------------------------------------------------------
%fitObject_X = fit(x_via, h_grayX, 'gauss1');
%fitObject_Y = fit(x_via, h_grayY, 'gauss1');
% %x11 = x_via;%a/b的范围为-128到+127，共256个级别
%        a1 = fitObject_X.a1;
%        b1 = fitObject_X.b1;
%        c1 = fitObject_X.c1;
% syms x1;
% syms y1;
% %y1 = a1*exp(-((x1-b1)/c1)^2) + a2*exp(-((x1-b2)/c2)^2) + a3*exp(-((x1-b3)/c3)^2);
% y1 = a1*exp(-((x1-b1)/c1)^2);
% %plot(y1);
% center_x = double(int(x1 * y1, x1,-128, 127));%此处-128,127对应x的变化范围——注意
% radius_x_2 = double(int((center_x - x1)^2 * y1, x1, -128, 127));
% 
% %x22 = x_via;%a/b的范围为-128到+127，共256个级别
%        a12 = fitObject_Y.a1;
%        b12 = fitObject_Y.b1;
%        c12 = fitObject_Y.c1;
% syms x2;
% syms y2;
% y2 = a12*exp(-((x2-b12)/c12)^2);
% center_y = double(int(x2*y2, x2, -128, 127));%此处-128,127对应x的变化范围——注意
% radius_y_2 = double(int((center_y - x2)^2 * y2, x2, -128, 127));
% %根据以上所求得的结果设定圆心
% %=================
% x0 = center_x;
% y0 = center_y; %原点
% radius = sqrt(radius_x_2 + radius_y_2);
% u = sqrt(center_x * center_x + center_y * center_y);

%%%第二种方法-------------------------------------------
centerX = double(sum(x_via.*h_grayX));%h_grayX表示F(a,b),x_via表示k,centerX表示ua
rediusX = double(sum(((centerX-x_via).^2).*h_grayX));

centerY = double(sum(x_via.*h_grayY));
rediusY = double(sum(((centerY-x_via).^2).*h_grayY));
%根据以上所求得的结果设定圆心
%=================
x0 = centerX;
y0 = centerY; %原点% 
radius = sqrt(rediusX + rediusY);%???????????????
u = sqrt(centerX * centerX + centerY * centerY);
%%%%%%%%%%%%%-------------------------------

theta=0:pi/100:2*pi; %角度[0,2*pi] 
R=radius; %半径70
x=R*cos(theta)+x0;
y=R*sin(theta)+y0;
u = double(u);
D = u - radius;
Dq = D / radius;
t_D = num2str(D);
t_radius = num2str(radius);
t_Dq = num2str(Dq);
cx = num2str(x0);
cy = num2str(y0);

figure(2);%%绘图------8
plot(x0, y0, '-'); 
hold on
plot(x, y, '-'); 
hold on
plot([0, x0], [0, y0]);
hold on
title(sprintf('%s的ab二维平面直方图等价圆',Img_name));

text(25, -5, ['x0 = ', cx],'fontsize', 14);
text(25, -15, ['y0 = ', cy],'fontsize', 14);
text(25, -25, ['D = ', t_D],'fontsize', 14);
text(25, -35, ['ratius = ', t_radius],'fontsize', 14);
text(25, -45, ['Dq = ', t_Dq],'fontsize', 14);

xlim([-50, 80]);
ylim([-50, 70]);
grid on
axis equal
xlabel('A');  
ylabel('B');  
zlabel('像素数'); 
saveas(gcf, sprintf('%s的ab二维直方图的等价圆.bmp',Img_name), 'bmp');
delete(gcf);
% toc;
%}
