function [output] = FnBRPCHE(input)

%% make histogram of input

[height, width]=size(input);

hists=zeros(1,256);

for i=1:height
    for j=1:width
        hists(input(i,j)+1)=hists(input(i,j)+1)+1;
    end
end

%% 

mean=0;
for i=1 : 256
    mean=mean+(hists(i)*(i-1));
end

 mean=round(mean/(height*width));

PR=100-mean*0.5;

max1=0; max2=0;
maxindex1=0; maxindex2=0;

    for i=1:mean
        if hists(i)>max1
            max1=hists(i);
            maxindex1=i;
        end
    end

    for i=mean+1:250
        if hists(i)>max2
            max2=hists(i);
            maxindex2=i;
        end
    end



  p1=round(max1*(PR/100));
  p2=round(max2*(PR/100));

%%

num1=numberbin_clip(hists,p1,1,mean);
num2=numberbin_clip(hists,p2,mean+1,256);


total=num1+num2;

clippedHist=zeros(1,256);

for i=1:mean
    if(hists(i)>p1)
     clippedHist(i)=p1;
    else
     clippedHist(i)=hists(i);   
    end
end


for i=mean+1:256
    if(hists(i)>p2)
     clippedHist(i)=p2;
    else
     clippedHist(i)=hists(i);   
    end
end

%%

clipHist=zeros(1,256);

for i=1:maxindex1-1
    clipHist(i)=clippedHist(i);
end

rightsum=0;

  k=256;
while k>maxindex2
    sum=(p2-clippedHist(k));
    if sum<0
        sum=0;
    end
    rightsum=rightsum+sum;
    if(rightsum>=total)
        rightsum=rightsum-sum;
        k=k+1;
        if(k==257)
            k=256;
        end
        break;
    end
    clipHist(k)=clippedHist(k)+sum;
    
    k=k-1;
end

for i=maxindex2+1:k
    clipHist(i)=clippedHist(i);
end

L=(total-rightsum)/(maxindex2-maxindex1+1);

for i=maxindex1:maxindex2
    clipHist(i)=clippedHist(i)+L;
end
     
%%    
pdf = clipHist/(width*height); %¡§±‘»≠

cdf = zeros(1,256);
cdf(1) = pdf(1);

for i=2:256
    cdf(i) = cdf(i-1)+pdf(i);
end

mf=round(cdf(:)*255);

output = zeros(height, width);
for i=1:height
    for j=1: width
        output(i,j)=mf(input(i,j)+1);
    end
end

end
