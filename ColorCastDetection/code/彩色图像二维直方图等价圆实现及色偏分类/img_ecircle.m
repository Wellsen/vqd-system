
function [L_rt, a_rt, b_rt, radius, u, D, Dq] = img_ecircle(Img_sur, Img_name)
% tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��һ���裺ʵ��rgb->Lab����
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
%�ڶ����裺���abƽ���άֱ��ͼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h_grayX = imhist(a);  %�ú������ڻ�ȡͼ������ֱ��ͼ
h_grayY = imhist(b); %�ú������ڻ�ȡͼ������ֱ��ͼ 
ind_grayX = find(h_grayX)-1;  %�������з�0��Ԫ�ص�λ��,��λ�õ�ֵ��Ϊ����ֵ�����Ϊ���и�����Ϊ0������
ind_grayY = find(h_grayY)-1; 
[X,Y] = meshgrid(ind_grayX,ind_grayY);%�����������������ĺ��������ɻ���3-Dͼ��������������ݡ��ڽ���3-Dͼ�λ��Ʒ����й㷺Ӧ��  
[m,n] = size(X);   % m��grayind_avr�ĳ��ȣ�n��grayind�ĳ���  
data = zeros(m,n); %data�е����ݼ�Ϊ��άֱ��ͼ����
% �������ڵĻҶ����ֵ��Ѱ�Ҷ�Ӧ���ز�����  

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
         grayX = a_X(:, :, j);  %grayΪ��Iͬ��С�ľ�����X(i,j)��ȵ�Ԫ�ش�Ϊ1��������Ϊ0
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
zlabel('������');
title(sprintf('%s��ab��άƽ��ֱ��ͼ',Img_name));
saveas(gcf, sprintf('%s��ab��άƽ��ֱ��ͼ.bmp',Img_name), 'bmp');
delete(gcf);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %�������裺���abֱ��ͼ���������
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_via = (linspace(-128, 127, 256)); %a��b�ķ�ΧΪ-128-127��(����)-128--127�Ĺ�256��Ԫ�أ�
x_via = t_via';%,x_via��ʾk
%�˴��Ĺ�һ���ǽ��������ص�ķֲ����й�һ���������ص�ĸ���Ϊ��0,1���ı���ֵ
h_grayX = h_grayX / sum(h_grayX);%h_grayX��ʾF(a,b)
h_grayY = h_grayY / sum(h_grayY);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���Ĳ��裺����άֱ��ͼ��Ӧ�ȼ�Բ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%��һ�ַ���--------------------------------------------------------------
%fitObject_X = fit(x_via, h_grayX, 'gauss1');
%fitObject_Y = fit(x_via, h_grayY, 'gauss1');
% %x11 = x_via;%a/b�ķ�ΧΪ-128��+127����256������
%        a1 = fitObject_X.a1;
%        b1 = fitObject_X.b1;
%        c1 = fitObject_X.c1;
% syms x1;
% syms y1;
% %y1 = a1*exp(-((x1-b1)/c1)^2) + a2*exp(-((x1-b2)/c2)^2) + a3*exp(-((x1-b3)/c3)^2);
% y1 = a1*exp(-((x1-b1)/c1)^2);
% %plot(y1);
% center_x = double(int(x1 * y1, x1,-128, 127));%�˴�-128,127��Ӧx�ı仯��Χ����ע��
% radius_x_2 = double(int((center_x - x1)^2 * y1, x1, -128, 127));
% 
% %x22 = x_via;%a/b�ķ�ΧΪ-128��+127����256������
%        a12 = fitObject_Y.a1;
%        b12 = fitObject_Y.b1;
%        c12 = fitObject_Y.c1;
% syms x2;
% syms y2;
% y2 = a12*exp(-((x2-b12)/c12)^2);
% center_y = double(int(x2*y2, x2, -128, 127));%�˴�-128,127��Ӧx�ı仯��Χ����ע��
% radius_y_2 = double(int((center_y - x2)^2 * y2, x2, -128, 127));
% %������������õĽ���趨Բ��
% %=================
% x0 = center_x;
% y0 = center_y; %ԭ��
% radius = sqrt(radius_x_2 + radius_y_2);
% u = sqrt(center_x * center_x + center_y * center_y);

%%%�ڶ��ַ���-------------------------------------------
centerX = double(sum(x_via.*h_grayX));%h_grayX��ʾF(a,b),x_via��ʾk,centerX��ʾua
rediusX = double(sum(((centerX-x_via).^2).*h_grayX));

centerY = double(sum(x_via.*h_grayY));
rediusY = double(sum(((centerY-x_via).^2).*h_grayY));
%������������õĽ���趨Բ��
%=================
x0 = centerX;
y0 = centerY; %ԭ��% 
radius = sqrt(rediusX + rediusY);%???????????????
u = sqrt(centerX * centerX + centerY * centerY);
%%%%%%%%%%%%%-------------------------------

theta=0:pi/100:2*pi; %�Ƕ�[0,2*pi] 
R=radius; %�뾶70
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

figure(2);%%��ͼ------8
plot(x0, y0, '-'); 
hold on
plot(x, y, '-'); 
hold on
plot([0, x0], [0, y0]);
hold on
title(sprintf('%s��ab��άƽ��ֱ��ͼ�ȼ�Բ',Img_name));

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
zlabel('������'); 
saveas(gcf, sprintf('%s��ab��άֱ��ͼ�ĵȼ�Բ.bmp',Img_name), 'bmp');
delete(gcf);
% toc;
%}
