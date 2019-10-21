function [images] = Load_images_file(camera)
%Load_images_file Loads the image file for the camera
foldername = Get_foldername_of_camera(camera);
filename = strcat(foldername,'images.mat');
images = load(filename);
images = images.images;
end

