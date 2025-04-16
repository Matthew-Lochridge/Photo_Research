[camera,status] = initialize_camera('COM4',20)
data = struct();
% [data, error_code] = send_command(camera,data,'M',601,[],[],[])
response = writeread(camera,'M601'); % '00000,0,-1,-1,-1,0,1,0,3,1,1,2,0.00'
[~,~] = send_command(camera,[],'Q',[],[],[],[]);
clear camera;