[camera,~] = initialize_camera('COM4',20);
data = struct();
[data, error_code] = send_command(camera,data,'M',5);

[~,~] = send_command(camera,[],'Q',[],[],[],[]);
clear camera;