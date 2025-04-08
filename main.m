addpath('Codes\','Operation\');

camera = serialport('COM4',2400,'FlowControl','hardware','Timeout',20)
configureTerminator(camera,'CR/LF','CR');
enter_remote_mode(camera);

%response = measure(camera,'data_code',5)

exit_remote_mode(camera);
clear camera;