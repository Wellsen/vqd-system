 Image = imread( '../database/mosaic.bmp' );
 
 Image = rgb2gray( Image );
 
 [row, col] = size( Image );
 
 Level = zeros( row, col, 256 );
 
 for i = 0 : 255
     Level( :, :, i + 1 ) = Image == i;
     imshow( Level( :, :, i + 1 ) );
 end
 