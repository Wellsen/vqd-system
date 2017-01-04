function E = difference_absolute( img )
I = rgb2gray( img );
[ m, n ] = size( I );
f = 0.0;
I = double( I );
for x = 1 : m - 1
    for y = 1 : n - 1
        Ix = I( x + 1, y ) - I( x, y );
        Iy = I( x, y + 1 ) - I( x, y );
        f = f + abs( Ix ) + abs( Iy );
    end
end
E = f / m / n;