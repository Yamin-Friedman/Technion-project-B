function [foldername] = Get_foldername_of_camera(camera)
%Get_foldername_of_camera returns the foldername for the camera
    if camera < 10
        foldername = strcat('Dry\00',int2str(camera),'\');
    else
        foldername = strcat('Dry\0',int2str(camera),'\');
    end
end

