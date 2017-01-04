function out_val=improved_spatial_frequencies(img);
I=double(img);
[m,n]=size(I);
f=0.0;
rf=0.0;
cf=0.0;
for x=1:m
    for y=2:n-1
        rf=rf+(abs(I(x,y+1)-I(x,y))+abs(I(x,y)-I(x,y-1)))^2;
    end
end
rf=sqrt(rf/m/n);
for x=2:m-1
    for y=1:n
        cf=cf+(abs(I(x+1,y)-I(x,y))+abs(I(x,y)-I(x-1,y)))^2;
    end
end
cf=sqrt(cf/m/n);
f=sqrt(rf^2+cf^2);
out_val=f;

