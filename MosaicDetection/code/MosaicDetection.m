function Nums = MosaicDetection( Image )
[ B, ~ ] = bwboundaries(Image, 'holes');
figure( 'Color', 'w' ); imshow( Image );
hold on;
for k = 1 : length( B )
    boundary = B{ k };
    if size( boundary, 1 ) > 10
        [ rectx, recty, area, perimeter ] = minboundrect( boundary( :, 2 ), boundary( :, 1 ), 'a' );
        line( rectx( : ), recty( : ), 'color', 'r' );
    end

% 	plot(boundary(:, 2), boundary(:, 1), 'r', 'LineWidth', 0.5)             % 标记色斑区域
end

[ L, ~ ] = bwlabel( Image, 4 );

stats = regionprops( L, 'all' );
PixelIndex = cat( 1, { stats.PixelIdxList }' );

[ r, c ] = find( Image == 1 );
[ rectx, recty, area, perimeter ] = minboundrect( c, r, 'a');

figure;
imshow( Image );
line( rectx( : ), recty( : ), 'color', 'r' );

