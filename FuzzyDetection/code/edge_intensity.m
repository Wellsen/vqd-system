% function outval = edge_intensity(img)
img = imread( '../database/img3.bmp ' );
img = double( rgb2gray( img ) );
F = std2( img )
% 
% w = fspecial( 'sobel' );
% gx = imfilter( img, w, 'replicate' );
% gy = imfilter( img, w', 'replicate' );
% 
% [ r, c ] = size( img );
% g = zeros( r, c );
% for m = 1 : r
%     for n = 1 : c
%         g( m, n ) = sqrt( gx( m, n ) * gx( m, n ) + gy( m, n ) * gy( m, n ) );
%     end
% end
% outval = mean( mean( g ) )