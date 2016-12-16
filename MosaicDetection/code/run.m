clc; clear; close all;

ImageColor = imread( '../database/mosaic.bmp' );

ImageGray = rgb2gray( ImageColor );

ImageSet = ImageLayering( ImageGray );

Nums = 0;
MosaicThreshold = 20;

for level = 70 : 256
    Nums = Nums + MosaicDetection( ImageSet( :, :, level ) );
    if Nums > MosaicThreshold
        disp( 'There is a mosaic of this image' );
        break;
    end
end