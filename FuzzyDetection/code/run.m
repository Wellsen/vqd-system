% clc; clear; close all;
% 
% file = 'mancar';
% addpath( ['../database/', file ] );
% 
% 
% image1 = imread( [ file, '1.bmp' ] );
% image2 = imread( [ file, '2.bmp' ] );
% image3 = imread( [ file, '3.bmp' ] );
% image4 = imread( [ file, '4.bmp' ] );
% 
% SSIM12 = ssim( image1, image2 );
% SSIM13 = ssim( image1, image3 );
% SSIM14 = ssim( image1, image4 );
% SSIM23 = ssim( image2, image3 );
% SSIM24 = ssim( image2, image4 );
% SSIM34 = ssim( image3, image4 );
% 
% PSNR12 = psnr( image1, image2 );
% PSNR13 = psnr( image1, image3 );
% PSNR14 = psnr( image1, image4 );
% PSNR23 = psnr( image2, image3 );
% PSNR24 = psnr( image2, image4 );
% PSNR34 = psnr( image3, image4 );
% 
% SSIM = [ SSIM12, SSIM13, SSIM14, SSIM23, SSIM24, SSIM34 ]
% PSNR = [ PSNR12, PSNR13, PSNR14, PSNR23, PSNR24, PSNR34 ]

close all;
butterfly = [ 0.9550, 0.9290, 0.8503, 0.9902, 0.9016, 0.9310 ];
tower = [ 0.9938, 0.9013, 0.7231, 0.9348, 0.7521, 0.8368 ];
mancar = [ 0.9575, 0.8774 , 0.6376, 0.9715, 0.7441, 0.8317 ];

figure;
plot(butterfly, 'r-<');   hold on;
plot(tower, 'g-o');   hold on;
plot(mancar, 'b->');   hold off;
legend( 'butterfly', 'tower', 'mancar' );
title( 'SSIM' );
grid on;

butterfly = [ 25.7112, 23.1377, 17.8749, 32.5230, 20.2214, 21.9324 ];
tower = [ 39.2129, 26.0163, 18.6184, 28.0171, 19.0476, 20.6443 ];
mancar = [ 30.1202, 25.6367 , 20.6081, 33.0803, 23.1052, 25.5792 ];

figure;
plot(butterfly, 'r-<');   hold on;
plot(tower, 'g-o');   hold on;
plot(mancar, 'b->');   hold off;
legend( 'butterfly', 'tower', 'mancar' );
title( 'PSNR' );
grid on;