function [masks] = Load_masks_file(camera)
%Load_masks_file Loads the mask file for the camera
foldername = Get_foldername_of_camera(camera);
filename = strcat(foldername,'masks.mat');
masks = load(filename);
masks = masks.masks;
end

