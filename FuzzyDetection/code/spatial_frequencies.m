function out_val=spatial_frequencies(img);
I=double(img);
[m,n]=size(I);
f=0.0;
rf=0.0;
cf=0.0;
for x=1:m
    for y=1:n-1
        rf=rf+(I(x,y+1)-I(x,y))^2;
    end
end
rf=sqrt(rf/m/n);
for x=1:m-1
    for y=1:n
        cf=cf+(I(x+1,y)-I(x,y))^2;
    end
end
cf=sqrt(cf/m/n);
f=sqrt(rf^2+cf^2);
out_val=f;

