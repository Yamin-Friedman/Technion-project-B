
P_mat = zeros(3,4,12);
for j = 0:11
    if j < 10
        filename = strcat('Projection_matrices\txt\0000000',int2str(j),'.txt');
    else
        filename = strcat('Projection_matrices\txt\000000',int2str(j),'.txt');
    end 
    
    data = importdata(filename);
    P_mat(:,:,j + 1) = data.data;
end