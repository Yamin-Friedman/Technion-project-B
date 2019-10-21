function [prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors] = Add_frames_to_set_by_camera_arc(start_frame,num_frames,prevPoints,prevFeatures,vSet)
%Add_frames_to_set_by_camera_arc Add num_frames to the camera set in an
%arcing order starting from start frame


    i = 0;
    jump_size = 3;
    for frame = start_frame:jump_size:start_frame + num_frames*jump_size - 1
        if i == 0
            for camera = 1:11
                [prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors] = Add_frame_to_set(camera,frame,prevPoints,prevFeatures,vSet);
            end
            start = 0;
        elseif mod(i,2) == 0
            for camera = 0:11
                [prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors] = Add_frame_to_set(camera,frame,prevPoints,prevFeatures,vSet);
            end
        elseif mod(i,2) == 1
            for camera = 11:-1:0
                [prevPoints,prevFeatures,vSet,xyzPoints,reprojectionErrors] = Add_frame_to_set(camera,frame,prevPoints,prevFeatures,vSet);
            end
        end
        i = i + 1;
    end
end

