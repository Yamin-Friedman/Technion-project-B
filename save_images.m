for j = 0:11
    if j < 10
        filename = strcat('Dry\00',int2str(j),'\00');
    else
        filename = strcat('Dry\0',int2str(j),'\00');
    end
    
    images = zeros(1200,1600,66);
    for i = 0:9
        I = imread(strcat(filename,'0',int2str(i),'.jpg'));
        images(:,:,i + 1) = rgb2gray(I);
    end
    
    for i = 10:65
        I = imread(strcat(filename,int2str(i),'.jpg'));
        images(:,:,i + 1) = rgb2gray(I);
    end
    
    if j < 10
        mask_filename = strcat('Dry\00',int2str(j),'\images');
    else
        mask_filename = strcat('Dry\0',int2str(j),'\images');
    end
    save(mask_filename,'images');
end