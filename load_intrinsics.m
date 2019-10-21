camera_intrinsics = zeros(3,3,12);
for j = 0:11
    if j < 10
        filename = strcat('Undistort\00',int2str(j),'\intrinsic.txt');
    else
        filename = strcat('Undistort\0',int2str(j),'\intrinsic.txt');
    end 
    
    data = importdata(filename);
    camera_intrinsics(:,:,j + 1) = data;
end