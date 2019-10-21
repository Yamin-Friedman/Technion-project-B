function [prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors] = Add_frame_to_set(camera,frame,prevPoints,prevFeatures,vSet)
%Add_frame_to_set Adds a new frame to the camera set

    masks = Load_masks_file(camera);

    I = Load_camera_frame(camera,5 + frame);
    mask = masks(:,:,frame);
    
    load_intrinsics;
    cameraParam = cameraParameters('IntrinsicMatrix',camera_intrinsics(:,:,camera + 1)','ImageSize',size(I));
    intrinsics = cameraIntrinsics(cameraParam.FocalLength,cameraParam.PrincipalPoint,size(I));

    I = Fix_image(I,mask,cameraParam);
    
    % Detect, extract and match features.
    border = 10;
    roi = [border, border, size(I, 2)- 2*border, size(I, 1)- 2*border];
    %currPoints   = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi,'MetricThreshold',1000);
    currPoints   = detectKAZEFeatures(I);
%     yloc = currPoints.Location(:,1);
%     xloc = currPoints.Location(:,2);
%     locs = [];
%     for i = 1:length(xloc)
%         for x = -5:5
%             for y = -5:5
%                 if mask(round(xloc(i) + x),round(yloc(i) + y)) == 0
%                     locs = [locs,i];
%                     break;
%                 end
%             end
%         end
%     end
%     currPoints(locs) = [];
    currFeatures = extractFeatures(I, currPoints, 'Upright', true);
    
    %Temp for debug
    imshow(I,[]); hold on;
    plot(currPoints.selectStrongest(50));

    indexPairs = matchFeatures(prevFeatures, currFeatures, ...
        'MaxRatio', .7, 'Unique',  true);
    
    % Select matched points.
    matchedPoints1 = prevPoints(indexPairs(:, 1));
    matchedPoints2 = currPoints(indexPairs(:, 2));
    
    % Estimate the camera pose of current view relative to the previous view.
    % The pose is computed up to scale, meaning that the distance between
    % the cameras in the previous view and the current view is set to 1.
    % This will be corrected by the bundle adjustment.
    [relativeOrient, relativeLoc, inlierIdx] = helperEstimateRelativePose(...
        matchedPoints1, matchedPoints2, cameraParam);
    
    % Add the current view to the view set.
    vSet = addView(vSet, vSet.NumViews + 1, 'Points', currPoints);
    
    % Store the point matches between the previous and the current views.
    vSet = addConnection(vSet, vSet.NumViews -  1, vSet.NumViews, 'Matches', indexPairs(inlierIdx,:));
    
    % Get the table containing the previous camera pose.
    prevPose = poses(vSet, vSet.NumViews - 1);
    prevOrientation = prevPose.Orientation{1};
    prevLocation    = prevPose.Location{1};
        
    % Compute the current camera pose in the global coordinate system 
    % relative to the first view.
    orientation = relativeOrient * prevOrientation;
%    orientation = eye(3) * prevOrientation;
    location    = prevLocation + relativeLoc * prevOrientation;
    vSet = updateView(vSet, vSet.NumViews, 'Orientation', orientation, ...
        'Location', location);
    
    % Find point tracks across all views.
    tracks = findTracks(vSet);

    % Get the table containing camera poses for all views.
    camPoses = poses(vSet);

    % Triangulate initial locations for the 3-D world points.
    xyzPoints = triangulateMultiview(tracks, camPoses, intrinsics);
    
    % Refine the 3-D world points and camera poses.
%     [xyzPoints, camPoses, reprojectionErrors] = bundleAdjustment(xyzPoints, ...
%         tracks, camPoses, intrinsics, 'FixedViewId', 1, ...
%         'PointsUndistorted', true);
    reprojectionErrors = [];
    % Store the refined camera poses.
    vSet = updateView(vSet, camPoses);

    prevFeatures = currFeatures;
    prevPoints   = currPoints; 
end

