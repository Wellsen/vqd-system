function out_val = edge_intensity(img) 
% OUTVAL = EDGE_INTENSITY(IMG) 
 
if nargin == 1 
    img=rgb2gray(img);
    img = double(img); 
    % Create horizontal sobel matrix 
    w = fspecial('sobel'); 
     
    % Get the size of img 
    [r c ] = size(img); 
     
    gx = imfilter(img,w,'replicate'); 
    gy = imfilter(img,w','replicate'); 
    f=0.0;
    for m = 1 : r 
        for n = 1 : c 
            
               f = f+sqrt(gx(m,n)*gx(m,n) + gy(m,n)*gy(m,n)); 
            
        end 
    end 
    out_val = f/m/n; 
else 
    error('Wrong number of input!'); 
end