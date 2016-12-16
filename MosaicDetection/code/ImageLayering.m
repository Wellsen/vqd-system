% divided into 256 layers
function ImageOutput = ImageLayering( ImageInput )

[Row, Col, ~] = size( ImageInput );

ImageOutput = zeros( Row, Col, 256 );

for level = 0 : 255
    ImageOutput( :, :, level + 1) = ImageInput == level;
end