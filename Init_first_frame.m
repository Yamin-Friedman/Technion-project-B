function [prevPoints,prevFeatures,vSet] = Init_first_frame(camera,frame)
%Init_first_frame Starts the construction of the camera placement

    load_intrinsics;
    masks = Load_masks_file(camera);

    I = Load_camera_frame(camera,5 + frame);
    mask = masks(:,:,frame);
    cameraParam = cameraParameters('IntrinsicMatrix',camera_intrinsics(:,:,camera + 1)','ImageSize',size(I));

    I = Fix_image(I,mask,cameraParam);

    border = 10;
    roi = [border, border, size(I, 2)- 2*border, size(I, 1)- 2*border];
    %prevPoints   = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi,'MetricThreshold',1000);
    prevPoints   = detectKAZEFeatures(I);

    % Remove invalid points
%     yloc = prevPoints.Location(:,1);
%     xloc = prevPoints.Location(:,2);
%     locs = [];
%     for i = 1:length(xloc)
%         if mask(round(xloc(i)),round(yloc(i))) == 0
%             locs = [locs,i];
%         end
%     end
%     prevPoints(locs) = [];

    % Extract features. Using 'Upright' features improves matching, as long as
    % the camera motion involves little or no in-plane rotation.
    prevFeatures = extractFeatures(I, prevPoints, 'Upright', true);
    
    % Temp debug section
    imshow(I,[]); hold on;
    plot(prevPoints.selectStrongest(10));

    % Create an empty viewSet object to manage the data associated with each
    % view.
    vSet = viewSet;

    % Add the first view. Place the camera associated with the first view
    % and the origin, oriented along the Z-axis.
    viewId = 1;
    vSet = addView(vSet, viewId, 'Points', prevPoints, 'Orientation', ...
        eye(3, 'like', prevPoints.Location), 'Location', ...
        zeros(1, 3, 'like', prevPoints.Location));
end

