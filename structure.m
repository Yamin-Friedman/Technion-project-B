clc;
figure;
bar = waitbar(0,"progress");

% setup params
start_camera = 0;%Starting camera
num_camera = 1;
start_frame = 7;%Starting frame
num_frames = 0;%Number of frames to traverse
direction = 1;%Direction of traversal
frame_jump = 2;%Number of frames to skip

[prevPoints,prevFeatures,vSet,intrinsics_vector] = Init_first_frame(start_camera,start_frame - 2);

[prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors,intrinsics_vector] = Add_frames_to_set_single_camera(start_camera,start_frame,num_frames,frame_jump,direction,prevPoints,prevFeatures,vSet,intrinsics_vector);
%[prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors,intrinsics_vector] = Add_frames_to_set_single_frame(start_frame + (frame_jump * num_frames) + 2,start_camera,num_camera,direction,prevPoints,prevFeatures,vSet,intrinsics_vector);
%[prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors,intrinsics_vector] = Add_frames_to_set_single_camera(start_camera + num_camera,start_frame + (frame_jump * num_frames),num_frames,frame_jump,-direction,prevPoints,prevFeatures,vSet,intrinsics_vector);
% [prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors] = Add_frames_to_set_by_camera_arc(frame,num_frames,prevPoints,prevFeatures,vSet);
waitbar(1,bar);

% reference
% [prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors] =
% Add_frames_to_set_single_frame(frame,start_camera,num_camera,direction,prevPoints,prevFeatures,vSet,intrinsics_vector);
%%
bar = waitbar(0,"progress");
camera = 3;
frame = 2;
[tracker,vSet,prevPoints] = Init_tracker(camera,frame,vSet);
vSet_num = 1;
for frame = 2:4
    if frame == 2
        for camera = 1:11
            [tracker,vSet] = Add_frame_to_tracker(camera,frame,tracker,vSet,vSet_num);
        end
    elseif mod(frame,2) == 0
        for camera = 0:11
            [tracker,vSet] = Add_frame_to_tracker(camera,frame,tracker,vSet,vSet_num);
        end
    elseif mod(frame,2) == 1
        for camera = 11:-1:0
            [tracker,vSet] = Add_frame_to_tracker(camera,frame,tracker,vSet,vSet_num);
        end
    end
    vSet_num = vSet_num + 1;
end

waitbar(1,bar);

%%
[xyzPoints] = show_camera_locations(vSet,xyzPoints,reprojectionErrors);
%%

% Find point tracks across all views.
tracks = findTracks(vSet);

% Find point tracks across all views.
camPoses = poses(vSet);

% Triangulate initial locations for the 3-D world points.
xyzPoints = triangulateMultiview(tracks, camPoses,...
    intrinsics);

% Refine the 3-D world points and camera poses.
[xyzPoints, camPoses, reprojectionErrors] = bundleAdjustment(...
    xyzPoints, tracks, camPoses, intrinsics, 'FixedViewId', 1, ...
    'PointsUndistorted', true);
% Display the refined camera poses.
figure;
plotCamera(camPoses, 'Size', 0.2);
hold on

% Exclude noisy 3-D world points.
goodIdx = (reprojectionErrors < 5);

% Display the dense 3-D world points.
pcshow(xyzPoints(goodIdx, :), 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
    'MarkerSize', 45);
grid on
hold off

% Specify the viewing volume.
loc1 = camPoses.Location{1};
xlim([loc1(1)-5, loc1(1)+4]);
ylim([loc1(2)-5, loc1(2)+4]);
zlim([loc1(3)-1, loc1(3)+20]);
camorbit(0, -30);

title('Dense Reconstruction');