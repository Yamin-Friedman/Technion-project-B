function [I] = Fix_image(I,mask,cameraParam)
%Fix_image Fixes the image in preperation for feature detection
    I = double(histeq(uint8(I)));
    se = strel('rectangle',[1,20]);
    mask = imclose(mask,se);
    mask = imerode(mask,se);
    se = strel('rectangle',[20,1]);
    mask = imclose(mask,se);
    mask = imerode(mask,se);
    mask = imfill(mask);
    se = strel('disk',10);
    mask = imerode(mask,se);
    mask = imclose(mask,se);
    se = strel('disk',40);
    %mask = imdilate(mask,se);
    I = I.*mask;
    I = undistortImage(I,cameraParam);
end

