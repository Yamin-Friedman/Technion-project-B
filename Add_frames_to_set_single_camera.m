function [prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors,intrinsics_vector] = Add_frames_to_set_single_camera(camera,start_frame,num_frames,frame_jump,direction,prevPoints,prevFeatures,vSet,intrinsics_vector)
%Add_frames_to_set_single_camera Adds frames to the set for a single camera
% Start_frame is the first frame to add, num_frames is the amount of frames
% to add, frame_jump is how many frames to jump each time, direction is
% which way to traverse the frames


for frame = start_frame:(direction * frame_jump):start_frame + (direction * frame_jump * num_frames)
     [prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors,intrinsics_vector] = Add_frame_to_set(camera,frame,prevPoints,prevFeatures,vSet,intrinsics_vector);
end
end

