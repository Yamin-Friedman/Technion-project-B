function [prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors,intrinsics_vector] = Add_frames_to_set_single_frame(frame,start_camera,num_camera,direction,prevPoints,prevFeatures,vSet,intrinsics_vector)
%Add_frames_to_set_single_frame Adds frames to the set for a single frame
%and multiple cameras
% start_camera is the first camera to add, num_camera is the amount of
% cameras to add, direction is which way to traverse the cameras


for camera = start_camera:direction:start_camera + (direction * num_camera)
     [prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors,intrinsics_vector] = Add_frame_to_set(camera,frame,prevPoints,prevFeatures,vSet,intrinsics_vector);
end
end

