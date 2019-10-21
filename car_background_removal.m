bar = waitbar(0,"progress");
for j = 0:11
    waitbar(j*66/(12*66),bar);
    
    
    se = strel('disk',10);
    se2 = strel('disk',15);
    se3 = strel('square',80);
    %orig_masks = zeros(1200,1600,56);
    
    % save all foreground masks and images
    masks = zeros(1200,1600,56);
    images = zeros(1200,1600,3,56);
    
    % Init the detector for the first 33 frames
    detector = vision.ForegroundDetector('AdaptLearningRate',true,'LearningRate',0.1,'MinimumBackgroundRatio',0.5,'NumGaussians',2);
    
    % Currently the first 5 frames are used only to build the background model
    for i = 0:4
        I = Load_camera_frame(j,i);
        Mask = step(detector, I);
        waitbar((j*66 + i)/(12*66),bar);
    end
    for i = 5:9
        I = Load_camera_frame(j,i);
        Mask = step(detector, I);
        images(:,:,:,i - 4) = I;
        %    orig_masks(:,:,i - 4) = Mask;
        Mask = imclose(Mask,se);
        Mask = imclose(Mask,se2);
        Mask = imclose(Mask,se3);
        Mask = imfill(Mask,'holes');
        masks(:,:,i - 4) = Mask;
        waitbar((j*66 + i)/(12*66),bar);
    end
    
    for i = 10:32
        I = Load_camera_frame(j,i);
        images(:,:,:,i - 4) = I;
        Mask = step(detector, I);
        %    orig_masks(:,:,i - 4) = Mask;
        Mask = imclose(Mask,se);
        Mask = imclose(Mask,se2);
        Mask = imclose(Mask,se3);
        Mask = imfill(Mask,'holes');
        masks(:,:,i - 4) = Mask;
        waitbar((j*66 + i)/(12*66),bar);
    end
    
    % It was found to give better results to build a background model starting
    % from the end and going backwards due to the different lighting in the
    % later frames
    detector = vision.ForegroundDetector('AdaptLearningRate',true,'LearningRate',0.01,'MinimumBackgroundRatio',0.5,'NumGaussians',2);
    for i = 65:-1:61
        I = Load_camera_frame(j,i);
        I = imadjust(I,[],[],[]);
        Mask = step(detector, I);
        waitbar((j*66 + (99-i))/(12*66),bar);
    end
    for i = 60:-1:33
        I = Load_camera_frame(j,i);
        I = imadjust(I,[],[],[]);
        images(:,:,:,i - 4) = I;
        Mask = step(detector, I);
        %    orig_masks(:,:,i - 4) = Mask;
        Mask = imclose(Mask,se);
        Mask = imclose(Mask,se2);
        Mask = imclose(Mask,se3);
        Mask = imfill(Mask,'holes');
        masks(:,:,i - 4) = Mask;
        waitbar((j*66 + (99-i))/(12*66),bar);
    end
    
%     %% Used to show results of masks
%     for i = 1:size(masks,3)
%         figure;
%         subplot(1,3,1);
%         imshow(masks(:,:,i));
%         subplot(1,3,2);
%         imshow(uint8(reshape(images(:,:,:,i),1200,1600,3)));
%         %    subplot(1,3,3);
%         %    imshow(masks2.masks(:,:,i));
%         %    imshow(uint8(reshape(images(:,:,:,i),1200,1600,3)).*uint8(double(masks(:,:,i))));
%     end
    
    
    %% Save the masks
    
    if j < 10
        mask_filename = strcat('Dry\00',int2str(j),'\masks');
    else
        mask_filename = strcat('Dry\0',int2str(j),'\masks');
    end
    save(mask_filename,'masks');
    
end
waitbar(1,bar);