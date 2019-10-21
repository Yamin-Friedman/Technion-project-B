function [tracker,vSet,prevPoints] = Init_tracker(camera,frame,vSet)
%Init_tracker Starts point tracker on first frame

    load_intrinsics;
    masks = Load_masks_file(camera);

    I = Load_camera_frame(camera,5 + frame);
    mask = masks(:,:,frame);
    cameraParam = cameraParameters('IntrinsicMatrix',camera_intrinsics(:,:,camera + 1)','ImageSize',size(I));

    I = Fix_image(I,mask,cameraParam);

    % Detect corners in the first image.
    prevPoints = detectMinEigenFeatures(I, 'MinQuality', 0.001);

    % Create the point tracker object to track the points across views.
    tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 6);

    % Initialize the point tracker.
    prevPoints = prevPoints.Location;
    initialize(tracker, prevPoints, I);

    % Store the dense points in the view set.
    vSet = updateConnection(vSet, 1, 2, 'Matches', zeros(0, 2));
    vSet = updateView(vSet, 1, 'Points', prevPoints);
end

