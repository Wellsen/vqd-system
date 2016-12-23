% Ref[1]. COLOR CAST DETECTION FOR SURVEILLANCE VIDEO
%     USING ADDITIVE AND SUBTRACTIVE COLOR SYSTEM

% Ref[2]. A Two-Stage Blind Image Color Correction
%     Using Color Cast Estimation
function Flag = ColorCastDetection( Image )

close all;

DISPLAY = true;

[M, N, ~] = size( Image );

ImageR = Image( :, :, 1 );    [xR, yR] = imhist( ImageR );
ImageG = Image( :, :, 2 );    [xG, yG] = imhist( ImageG );
ImageB = Image( :, :, 3 );    [xB, yB] = imhist( ImageB );

if DISPLAY
    figure; 
    plot( yR, xR, 'r-' );  hold on;
    plot( yG, xG, 'g-' );  hold on;
    plot( yB, xB, 'b-' );  hold off;
    legend( 'R-channel', 'G-channel', 'B-channel' );
    title( 'image hist' );
    grid on;
end

% DeltaRG = abs( xR - xG );
% DeltaRB = abs( xR - xB );
% DeltaGB = abs( xG - xB );
% 
% if DISPLAY
%     figure; 
%     plot( yR, DeltaRG, 'r-' );  hold on;
%     plot( yG, DeltaRB, 'g-' );  hold on;
%     plot( yB, DeltaGB, 'b-' );  hold off;
%     legend( 'RG-channel', 'RB-channel', 'GB-channel' );
%     title( 'Delta' );
%     grid on;
% end

% Ref[1]. Formula (1) (2)
Hmin = min( min( ImageR, ImageG ), ImageB );
Hmax = max( max( ImageR, ImageG ), ImageB );

if DISPLAY
    figure;
    subplot( 211 );   imshow( Hmin );   title('Hmin');
    subplot( 212 );   imshow( Hmax );   title('Hmax');
end

% Ref[1]. Formula (3)
Ta = 5;
LbR = ( Hmax - ImageR ) < Ta;
LbG = ( Hmax - ImageG ) < Ta;
LbB = ( Hmax - ImageB ) < Ta;

% Ref[1]. Formula (4)
LdR = ( ImageR - Hmin ) < Ta;
LdG = ( ImageG - Hmin ) < Ta;
LdB = ( ImageB - Hmin ) < Ta;

% Normal point, Li( x, y ) = ( 1, 1, 1 )
Lb = LbR & LbG & LbB;
Ld = LdR & LdG & LdB;

if DISPLAY
    figure;
    subplot( 121 ); imshow( Lb );   title( 'Lb' );
    subplot( 122 ); imshow( Ld );   title( 'Ld' );
end

% Ref[1]. Formula (5)
LbR( Lb ) = ~LbR( Lb );
LbB( Lb ) = ~LbB( Lb );
LbG( Lb ) = ~LbG( Lb );

LdR( Ld ) = ~LdR( Ld );
LdB( Ld ) = ~LdB( Ld );
LdG( Ld ) = ~LdG( Ld );

if DISPLAY
    figure;
    subplot( 231 );	imshow( LbR );   title( 'LbR' );
    subplot( 232 );	imshow( LbB );   title( 'LbB' );
    subplot( 233 );	imshow( LbG );   title( 'LbG' );
    
  	subplot( 234 );	imshow( LdR );   title( 'LdR' );
    subplot( 235 );	imshow( LdB );   title( 'LdB' );
    subplot( 236 );	imshow( LdG );   title( 'LdG' );
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
    EIR = [ EIRb , EIRd ];
    Bar = bar( diag( EIR ), 'stack' );

    set( Bar( 1 ), 'FaceColor', [ 1, 0, 0 ] );
    set( Bar( 2 ), 'FaceColor', [ 0, 1, 0 ] );
    set( Bar( 3 ), 'FaceColor', [ 0, 0, 1 ] );
    
    set( Bar( 4 ), 'FaceColor', [ 1, 0, 0 ] );
    set( Bar( 5 ), 'FaceColor', [ 0, 1, 0 ] );
    set( Bar( 6 ), 'FaceColor', [ 0, 0, 1 ] );
    
    hold on;
    plot( [ 3.5, 3.5 ], [ 0 , max(EIR) ], 'k-' );
    hold off;
end

% Ref[2]. Formula (5)
[EIRb, Indexb] = sort( EIRb, 'descend' );
[EIRd, Indexd] = sort( EIRd, 'descend' );

T1 = 0.8;   T2 = 0.8;
CC = zeros( 1, 3 );

if EIRd( 1, 1 ) - EIRd( 1, 2) > T1
    CC( 1, Indexd( end ) ) = 1;
end

if EIRb( 1, 1 ) - EIRb( 1, 2) > T2
    CC( 1, Indexb( end ) ) = 1;
end

% sum(CC)
Flag = sum( CC ) ~= 0;
