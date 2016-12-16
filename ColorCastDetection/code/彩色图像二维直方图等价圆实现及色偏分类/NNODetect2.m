function NNO_img = NNODetect2(L, a, b, Img_sur)


squre = a.^2 + b.^2;
maxRadius = max(max(squre));
maxRadius = sqrt(double(maxRadius));

threShold = maxRadius / 4;
[M, N, d] = size(Img_sur);

tmp = (squre <= threShold^2);
tmp_L = (L < 95) & (L > 30);
tmp = tmp & tmp_L;

while (length(find(tmp)) / (M * N) < 0.1) && (threShold < maxRadius)
    threShold = threShold + 1;
    tmp = (squre <= threShold^2);
    tmp = tmp & tmp_L;
end

if threShold >= maxRadius
    msgbox('ªÒ»°NNO«¯”Ú ß∞‹£°£°');
    msgbox(sprintf('maxRadius:%3d####theShold:%3d', maxRadius, threShold));
    return;
else
    NNO_img = Img_sur;
    NNO_img(:, :, 1) = (uint8(tmp).*Img_sur(:, :, 1));
    NNO_img(:, :, 2) = (uint8(tmp).*Img_sur(:, :, 2));
    NNO_img(:, :, 3) = (uint8(tmp).*Img_sur(:, :, 3));
%     figure(3);
%     imshow(NNO_img);
end


















