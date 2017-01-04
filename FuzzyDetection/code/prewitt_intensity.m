function outval = prewitt_intensity(img) 
% OUTVAL = EDGE_INTENSITY(IMG) 
 
if nargin == 1 
    img=rgb2gray(img);
    img = double(img); 
    % Create horizontal sobel matrix 
    w = fspecial('prewitt'); 
     
    % Get the size of img 
    [r c ] = size(img); 
     
    gx = imfilter(img,w,'replicate'); 
    gy = imfilter(img,w','replicate'); 
    f=0.0
    for m = 1 : r 
        for n = 1 : c 
            
               g(m,n)=sqrt(gx(m,n)*gx(m,n) + gy(m,n)*gy(m,n)); 
            
        end 
    end 
    outval =mean(mean(g)); 
else 
    error('Wrong number of input!'); 
end