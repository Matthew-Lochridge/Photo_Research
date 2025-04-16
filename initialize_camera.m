function [camera,status] = initialize_camera(port,timeout)
% Entering Remote Mode 
% To enter remote mode “P” “H” “O” “T” “O” must be sent as single characters and not as a single string.
    camera = serialport(port,2400,'FlowControl','hardware','Timeout',timeout);
    configureTerminator(camera,'CR/LF','CR');
    write(camera,'P','char');
    write(camera,'H','char');
    write(camera,'O','char');
    write(camera,'T','char');
    write(camera,'O','char');
    status = read(camera,12,'char'); % response = ' REMOTE MODE'
end