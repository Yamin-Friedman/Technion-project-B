function [I] = Fix_image(I,mask,cameraParam)
%Fix_image Fixes the image in preperation for feature detection
    I = double(histeq(uint8(I)));

    I = I.*mask;
    I = undistortImage(I,cameraParam);
end

