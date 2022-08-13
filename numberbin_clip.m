function [ num ] = numberbin_clip( hist,clip,a,b )

num=0;
for i=a:b
    if hist(i)>clip
        num=num+(hist(i)-clip);
    end
    
end

end

