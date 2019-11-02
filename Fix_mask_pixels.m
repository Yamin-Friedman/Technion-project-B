function [mask] = Fix_mask_pixels(mask)
%Fix_mask_pixels Summary of this function goes here
%   Detailed explanation goes here
for i = 2:size(mask,1) - 1
    for j = 2:size(mask,2) - 1
        if mask(i,j) == 1
            continue
        end
        count = 0;
        for k = i+1:size(mask,1)
            if mask(k,j) == 1
                count = count + 1;
                break;
            end
        end
        for k = j+1:size(mask,2)
            if mask(i,k) == 1
                count = count + 1;
                break;
            end
        end
        for k = i-1:-1:1
            if mask(k,j) == 1
                count = count + 1;
                break;
            end
        end
        for k = j-1:-1:1
            if mask(i,k) == 1
                count = count + 1;
                break;
            end
        end
        if count >= 3
            mask(i,j) = 1;
        end
    end
end
j = 1;
for i = 1:size(mask,1)
    mask(i,j) = ~mask(i,j);
end
j = size(mask,2);
for i = 1:size(mask,1)
    mask(i,j) = ~mask(i,j);
end
i = 1;
for j = 1:size(mask,2)
    mask(i,j) = ~mask(i,j);
end
i = size(mask,1);
for j = 1:size(mask,2)
    mask(i,j) = ~mask(i,j);
end
mask(size(mask,1),size(mask,2)/2) = 0;
mask(1,size(mask,2)/2) = 0;
mask(size(mask,1)/2,1) = 0;
mask(size(mask,1)/2,size(mask,2)) = 0;
mask = imfill(mask,'holes');
j = 1;
for i = 1:size(mask,1)
    mask(i,j) = ~mask(i,j);
end
j = size(mask,2);
for i = 1:size(mask,1)
    mask(i,j) = ~mask(i,j);
end
i = 1;
for j = 1:size(mask,2)
    mask(i,j) = ~mask(i,j);
end
i = size(mask,1);
for j = 1:size(mask,2)
    mask(i,j) = ~mask(i,j);
end
end

