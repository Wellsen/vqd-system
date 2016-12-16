%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%将原程序拆分成三块：
% 1.由图像 -> 二维直方图的等价圆
% 2.对等价圆的参数进行分析，分成：色偏图像/进一步处理图像
% 3.对第2步骤中的图像进行提取其NNO区域图像。
% 4.对3的“进一步处理图像”执行1步骤，并给出结果。
% 5.最终将图像分为色偏图像和非色偏需再检测图像两类情况，并放到响应的文件夹内
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Img_name = '1.jpg';

tic;
% if figure_num > 1
%     delete(figure(figure_num - 1));
% end

Img_num=9;

Img_name = '../../database/图片2.jpg';

Img_sur = imread(Img_name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 第 1 步骤： 由图像 -> 二维直方图的等价圆

[L, a, b, radius, u, D, Dq] = img_ecircle(Img_sur, Img_name); %此处返回的L/a/b是double类型，未处理过的值
result_radius(1, Img_num) = radius;
result_u(1, Img_num) = u;
result_D(1, Img_num) = D;
result_Dq(1, Img_num) = Dq;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 第 2 步骤：对等价圆的参数进行分析，分成：色偏图像/进一步处理图像
if ((D > 10) && (Dq > 0.6)) || (Dq > 1.5)
    result = 1;%result为1时表示：明显色偏图像(这里包括：真实色偏、本质色偏)
    
    %msgbox('该图像为色偏图像！');
% elseif (Dq > 6) 
%     result = -1; %return为-1时表示：无色偏图像
%     return;
else
    result = 0; %result为0时表示：模棱两可，需要进一步判断、识别。
%    msgbox('该图像为正常图像！');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 第 3 步骤：对所有的图像都执行NNO区域的求解操作，非色偏图像信息保存在第二行，色偏图像保存在第三行
[NNO_img] = NNODetect2(L, a, b, Img_sur); % NNO_img 为图像对应的NNO区域    
% tmpName = sprintf('%dNNO', Img_num);
% imwrite(NNO_img, sprintf('%s.jpg', tmpName), 'jpg');
% 
% %     figure(figure_num);
% %     figure_num = figure_num + 1;
% %     imshow(NNO_img);
% %     title(sprintf('%s的NNO区域', Img_name));
% %     delete(figure(figure_num - 1));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 第 4 步骤： 对3步骤中的等价圆进行判断，给出检测结果。
% tmpName = sprintf('%s.jpg', tmpName);
% tmpImg = imread(tmpName);
% [L_NNO, a_NNO, b_NNO, radius_NNO, u_NNO, D_NNO, Dq_NNO] = img_ecircle(tmpImg, tmpName);
% 
%  %非色偏图像信息保存在第二行，色偏图像保存在第三行   
% if result == 0 %无色偏图像
%     result_radius(2, Img_num) = radius_NNO;
%     result_u(2, Img_num) = u_NNO;
%     result_D(2, Img_num) = D_NNO;
%     result_Dq(2, Img_num) = Dq_NNO;
% elseif result == 1 %明显色偏图像
%     result_radius(3, Img_num) = radius_NNO;
%     result_u(3, Img_num) = u_NNO;
%     result_D(3, Img_num) = D_NNO;
%     result_Dq(3, Img_num) = Dq_NNO;
% end
% 
% 
% 
% 
% result_str = '无法识别';
% %将分类后的源图像复制到指定的文件夹内，并将其结果也保存在里面
% if result == 1 %明显色偏图像
%     
%     result_str = '色偏图像！';
%     disp(result_str);
% elseif result == 0 %无色偏图像
%    
%     result_str = '非色偏图像。';disp(result_str);
% else
%     msg('在对图像：%s执行检测时出错！！检测终止。',Img_name);
%     disp(result_str);
% end
% 
% %显示源图像并将源图像的检测结果作为标题显示在图像上
% % figure(figure_num);
% % figure_num = figure_num + 1;
% % imshow(Img_sur);
% % title(result_str);
toc;
























