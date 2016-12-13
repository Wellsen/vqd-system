% Ref[1]. COLOR CAST DETECTION FOR SURVEILLANCE VIDEO
%     USING ADDITIVE AND SUBTRACTIVE COLOR SYSTEM

% Ref[2]. A Two-Stage Blind Image Color Correction
%     Using Color Cast Estimation

clc;    clear;  close all;

DISPLAY = true;

Files = '../database/';
Name = 'colorcast_red.bmp';
% Name = 'colorcast_normal.bmp';

Image = imread( [ Files, Name ] );

[M, N, ~] = size( Image );

ImageR = Image( :, :, 1 );    [xR, yR] = imhist( ImageR );
ImageG = Image( :, :, 2 );    [xG, yG] = imhist( ImageG );
ImageB = Image( :, :, 3 );    [xB, yB] = imhist( ImageG );

if DISPLAY
    figure; 
    plot( yR, xR, 'r-' );  hold on;
    plot( yG, xG, 'g-' );  hold on;
    plot( yB, xB, 'b-' );  hold off;
    legend( 'R-channel', 'G-channel', 'B-channel' );
    grid on;
end

% Ref[1]. Formula (1) (2)
Hmin = min( min( ImageR, ImageG ), ImageB );
Hmax = max( max( ImageR, ImageG ), ImageB );

if DISPLAY
    figure;
    subplot( 211 );   imshow( Hmin );   title('Hmin');
    subplot( 212 );   imshow( Hmax );   title('Hmax');
end

% Ref[1]. Formula (3)
Ta = 10;
LbR = ( Hmax - ImageR ) < Ta;
LbG = ( Hmax - ImageG ) < Ta;
LbB = ( Hmax - ImageB ) < Ta;

% Ref[1]. Formula (4)
LdR = ( ImageR - Hmin ) < Ta;
LdG = ( ImageG - Hmin ) < Ta;
LdB = ( ImageB - Hmin ) < Ta;

% Li( x, y ) = ( 1, 1, 1 )
Lb = LbR & LbG & LbB;
Ld = LdR & LdG & LdB;

% Ref[1]. Formula (5)
LbR( Lb ) = ~LbR( Lb );
LbB( Lb ) = ~LbB( Lb );
LbG( Lb ) = ~LbG( Lb );

LdR( Ld ) = ~LdR( Ld );
LdB( Ld ) = ~LdB( Ld );
LdG( Ld ) = ~LdG( Ld );

if DISPLAY
    figure;
    subplot( 121 ); imshow( Lb );   title( 'Lb' );
    subplot( 122);  imshow( Ld );   title( 'Ld' );
end

% Ref[1]. Formula (6)
length = M * N;

EIRbR = sum( LbR( : ) ) / length;
EIRbG = sum( LbG( : ) ) / length;
EIRbB = sum( LbB( : ) ) / length;

EIRdR = sum( LdR( : ) ) / length;
EIRdG = sum( LdG( : ) ) / length;
EIRdB = sum( LdB( : ) ) / length;

EIRb = [ EIRbR, EIRbG, EIRbB ];
EIRd = [ EIRbB, EIRdG, EIRdB ];

if DISPLAY
    figure;
    bar( [ EIRb ; EIRd ] );
end

% Ref[2]. Formula (5)
[EIRb, Indexb] = sort( EIRb, 'descend' );
[EIRd, Indexd] = sort( EIRd, 'descend' );

T1 = 0.6;   T2 = 0.6;
CC = zeros( 1, 3 );

if EIRd( 1, 1 ) - EIRd( 1, 2) > T1
    CC( 1, Indexd( end ) ) = 1;
end

if EIRb( 1, 1 ) - EIRb( 1, 2) > T2
    CC( 1, Indexb( end ) ) = 1;
end

% sum(CC)
Flag = sum( CC ) ~= 0;
