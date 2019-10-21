function [I] = Load_camera_frame(camera,frame)
%Load_camera_frame Loads the frame for the camera
foldername = Get_foldername_of_camera(camera);
if frame < 10
        filename = strcat(foldername,'000',int2str(frame),'.jpg');
else
        filename = strcat(foldername,'00',int2str(frame),'.jpg');
end
I = imread(filename);
I = rgb2gray(I);
end

