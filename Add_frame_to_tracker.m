function [tracker,vSet,prevPoints] = Add_frame_to_tracker(camera,frame,tracker,vSet,vSet_num,prevPoints)
%Add_frame_to_tracker Summary of this function goes here

    masks = Load_masks_file(camera);

    I = Load_camera_frame(camera,5 + frame);
    mask = masks(:,:,frame);
    
    load_intrinsics;
    cameraParam = cameraParameters('IntrinsicMatrix',camera_intrinsics(:,:,camera + 1)','ImageSize',size(I));

    I = Fix_image(I,mask,cameraParam);
    
    % Track the points.
    [currPoints, validIdx] = step(tracker, I);
    
    % Clear the old matches between the points.
    vSet = updateConnection(vSet, vSet_num, vSet_num+1, 'Matches', zeros(0, 2));

    vSet = updateView(vSet, vSet_num, 'Points', currPoints);
    
    % Store the point matches in the view set.
    matches = repmat((1:size(prevPoints, 1))', [1, 2]);
    matches = matches(validIdx, :);        
    vSet = updateConnection(vSet, vSet_num-1, vSet_num, 'Matches', matches);
end

