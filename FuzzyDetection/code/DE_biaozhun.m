function out_val=DE_biaozhun(img1,img2,img3);
NP=8;   %种群规模
D=2;    %变量维数
F=0.3;  %交叉率
CR=0.9;  %变异因子
GM=100;   %迭代次数
G=1;     %初始化迭代次数
f_best=49.2044;  %适应度
M=0;
H=1;
best_width=32;
best_height=32; 
count=0;
%---------初始化种群------
X=cell(1,NP);
[m,n]=size(img1);
height_max=1;  %生成种群高的最大值
height_min=m;  %生成种群高的最小值
width_max=1;   %生成种群宽的最大值
width_min=n; %生成种群宽的最小值
for j=1:NP
    X{j}=[1+rand(1)*m,1+rand(1)*n];
end
%---------迭代------------
while G<=GM
    count=count+1;
   
   
%---------每次迭代种群宽、高的取值最大和最小值
    for j=1:NP
        if X{j}(1)>height_max
            height_max=X{j}(1);
        end
        if  X{j}(1)<height_min
            height_min=X{j}(1);
        end
        if X{j}(2)>width_max
            width_max=X{j}(2);
        end
         if  X{j}(2)<width_min
            width_min=X{j}(2);
         end
    end
%---------种群变异---------
    V=cell(1,NP); 
    i=1;
    while i<=NP
        a=randperm(NP);
        b=a(1:3);
        X1=X(b);
        V{i}=X1{1}+F*(X1{2}-X1{3});
        if((V{i}(1)>0)&(V{i}(2)>0)&V{i}(1)<m&V{i}(2)<n)
            i=i+1;
        end
    end
  
%-------交叉-------
 U=cell(1,NP);   
    for j=1:NP
        a=randperm(2);
        b=a(1);
        r_rand=rand();
        for i=1:2
            if r_rand>CR&i~=b
                U{j}(i)=X{j}(i);
            else
                U{j}(i)=V{j}(i);
            end
        end
    end
    for j=1:NP
        if U{j}(1)>height_max
            height_max=U{j}(1);
        end
        if  U{j}(1)<height_min
            height_min=U{j}(1);
        end
        if U{j}(2)>width_max
            width_max=U{j}(2);
        end
         if  U{j}(2)<width_min
            width_min=U{j}(2);
         end
    end
   
%-------选择--------
    G=G+1;
    for j=1:NP
        X{j}=ceil(X{j});
        U{j}=ceil(U{j});
        height_1=X{j}(1);
        width_1=X{j}(2);
        img_fusion_1=fusion(img1,img2,height_1,width_1);
        height_2=U{j}(1);
        width_2=U{j}(2);
        img_fusion_2=fusion(img1,img2,height_2,width_2);
        f_new_1=PSNP(img_fusion_1,img3);
        f_new_2=PSNP(img_fusion_2,img3);
        if f_new_1<f_new_2
            f=f_new_2;
            current_width=width_2;
            current_height=height_2;
            X{j}=U{j};
        else
            f=f_new_1;
            current_width=width_1;
            current_height=height_1;
        end
        if f>=f_best
            M=1;
            best_height=current_height;
            best_width=current_width;
            break;
        end
    end
    if M==1
        break;
    end
   

%----------判断种群中元素是否相等--------
    
    val=[0,0];
    for j=1:NP
        val=val+X{j};
    end
    avg_val=val/NP;
    number=0;
    for j=1:NP
        if(X{j}(1)==avg_val(1)&&X{j}(2)==avg_val(2))
            number=number+1;
        end
    end
    if(number==NP)
        H=0
        for j=2:NP
            X{j}=[1+rand(1)*m,1+rand(1)*n];
        end
    end
end

%------最佳分块----

out_val=G;



        
    
    
    
    

        
    
    



    
    


    
    



    
