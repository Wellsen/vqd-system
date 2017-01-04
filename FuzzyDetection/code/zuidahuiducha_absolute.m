function out_val=zuidahuiducha_absolute(img);
I=rgb2gray(img);
I=double(I);
[m,n]=size(I);
f=0.0;
for i=1:m
    for j=1:n
        if i==1
            if j==1
                A=[I(i,j),I(i,j+1),I(i+1,j),I(i+1,j+1)];
            elseif j==n
                A=[I(i,j),I(i+1,j),I(i,j-1),I(i+1,j-1)];
            else
                A=[I(i,j),I(i+1,j),I(i,j-1),I(i+1,j-1),I(i,j+1),I(i+1,j+1)];
            end
        elseif i==m
            if j==1
                A=[I(i,j),I(i,j+1),I(i-1,j),I(i-1,j+1)];
            elseif j==n
                A=[I(i,j),I(i-1,j),I(i,j-1),I(i-1,j-1)];
            else
                A=[I(i,j),I(i-1,j),I(i,j-1),I(i-1,j-1),I(i,j+1),I(i-1,j+1)];
            end
        else
            if j==1
                A=[I(i,j),I(i,j+1),I(i-1,j),I(i-1,j+1),I(i+1,j),I(i+1,j+1)];
            elseif j==n
                A=[I(i,j),I(i,j-1),I(i-1,j),I(i-1,j-1),I(i+1,j),I(i+1,j-1)];
            else
            A=[I(i,j),I(i-1,j-1),I(i-1,j),I(i-1,j+1),I(i,j-1),I(i,j+1),I(i+1,j-1),I(i+1,j),I(i+1,j+1)];
            end
        end
        m_max=max(A);
        m_min=min(A);
        f=f+(m_max-m_min)/m_max;
    end
end
out_val=f/m/n;