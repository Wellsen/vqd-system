% addpath( './layer' );
addpath( './morphological' );

img = imread( '51.bmp' );

imshow( img, 'border', 'tight', 'initialmagnification', 'fit' );
set ( gcf, 'Position', [ 232   246   560   420 ] );
axis normal;