%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ԭ�����ֳ����飺
% 1.��ͼ�� -> ��άֱ��ͼ�ĵȼ�Բ
% 2.�Եȼ�Բ�Ĳ������з������ֳɣ�ɫƫͼ��/��һ������ͼ��
% 3.�Ե�2�����е�ͼ�������ȡ��NNO����ͼ��
% 4.��3�ġ���һ������ͼ��ִ��1���裬�����������
% 5.���ս�ͼ���Ϊɫƫͼ��ͷ�ɫƫ���ټ��ͼ��������������ŵ���Ӧ���ļ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Img_name = '1.jpg';

tic;
% if figure_num > 1
%     delete(figure(figure_num - 1));
% end

Img_num=9;

Img_name = '../../database/ͼƬ2.jpg';

Img_sur = imread(Img_name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �� 1 ���裺 ��ͼ�� -> ��άֱ��ͼ�ĵȼ�Բ

[L, a, b, radius, u, D, Dq] = img_ecircle(Img_sur, Img_name); %�˴����ص�L/a/b��double���ͣ�δ�������ֵ
result_radius(1, Img_num) = radius;
result_u(1, Img_num) = u;
result_D(1, Img_num) = D;
result_Dq(1, Img_num) = Dq;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �� 2 ���裺�Եȼ�Բ�Ĳ������з������ֳɣ�ɫƫͼ��/��һ������ͼ��
if ((D > 10) && (Dq > 0.6)) || (Dq > 1.5)
    result = 1;%resultΪ1ʱ��ʾ������ɫƫͼ��(�����������ʵɫƫ������ɫƫ)
    
    %msgbox('��ͼ��Ϊɫƫͼ��');
% elseif (Dq > 6) 
%     result = -1; %returnΪ-1ʱ��ʾ����ɫƫͼ��
%     return;
else
    result = 0; %resultΪ0ʱ��ʾ��ģ�����ɣ���Ҫ��һ���жϡ�ʶ��
%    msgbox('��ͼ��Ϊ����ͼ��');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �� 3 ���裺�����е�ͼ��ִ��NNO���������������ɫƫͼ����Ϣ�����ڵڶ��У�ɫƫͼ�񱣴��ڵ�����
[NNO_img] = NNODetect2(L, a, b, Img_sur); % NNO_img Ϊͼ���Ӧ��NNO����    
% tmpName = sprintf('%dNNO', Img_num);
% imwrite(NNO_img, sprintf('%s.jpg', tmpName), 'jpg');
% 
% %     figure(figure_num);
% %     figure_num = figure_num + 1;
% %     imshow(NNO_img);
% %     title(sprintf('%s��NNO����', Img_name));
% %     delete(figure(figure_num - 1));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % �� 4 ���裺 ��3�����еĵȼ�Բ�����жϣ������������
% tmpName = sprintf('%s.jpg', tmpName);
% tmpImg = imread(tmpName);
% [L_NNO, a_NNO, b_NNO, radius_NNO, u_NNO, D_NNO, Dq_NNO] = img_ecircle(tmpImg, tmpName);
% 
%  %��ɫƫͼ����Ϣ�����ڵڶ��У�ɫƫͼ�񱣴��ڵ�����   
% if result == 0 %��ɫƫͼ��
%     result_radius(2, Img_num) = radius_NNO;
%     result_u(2, Img_num) = u_NNO;
%     result_D(2, Img_num) = D_NNO;
%     result_Dq(2, Img_num) = Dq_NNO;
% elseif result == 1 %����ɫƫͼ��
%     result_radius(3, Img_num) = radius_NNO;
%     result_u(3, Img_num) = u_NNO;
%     result_D(3, Img_num) = D_NNO;
%     result_Dq(3, Img_num) = Dq_NNO;
% end
% 
% 
% 
% 
% result_str = '�޷�ʶ��';
% %��������Դͼ���Ƶ�ָ�����ļ����ڣ���������Ҳ����������
% if result == 1 %����ɫƫͼ��
%     
%     result_str = 'ɫƫͼ��';
%     disp(result_str);
% elseif result == 0 %��ɫƫͼ��
%    
%     result_str = '��ɫƫͼ��';disp(result_str);
% else
%     msg('�ڶ�ͼ��%sִ�м��ʱ�����������ֹ��',Img_name);
%     disp(result_str);
% end
% 
% %��ʾԴͼ�񲢽�Դͼ��ļ������Ϊ������ʾ��ͼ����
% % figure(figure_num);
% % figure_num = figure_num + 1;
% % imshow(Img_sur);
% % title(result_str);
toc;
























