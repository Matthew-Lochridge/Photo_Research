addpath('Codes\','Configuration\','Operation\');

measurements = {};

camera = serialport('COM4',2400,'FlowControl','hardware')
enter_remote_mode(camera);
model = parse_data(measure(camera,111));
camera.Tag = model.model;



exit_remote_mode(camera);
clear camera;