function out_val=laplacian_intensity(img)
I=double(img);
w=[-1,-4,-1;-4,20,-4;-1,-4,-1];
f=0.0;
[m,n]=size(I);
for i= 2 : m-1 
    for j = 2: n-1 
        S=20*I(i,j)-4*I(i,j-1)-4*I(i,j+1)-4*I(i-1,j)-4*I(i+1,j)-I(i+1,j+1)-I(i+1,j-1)-I(i-1,j+1)-I(i-1,j-1);
        f=f+S^2;
    end 
end
out_val = f/m/n;