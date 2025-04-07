function enter_remote_mode(camera)
% Entering Remote Mode 
% To enter remote mode “P” “H” “O” “T” “O” must be sent as single characters and not as a single string.   
    write(camera,'P','char');
    write(camera,'H','char');
    write(camera,'O','char');
    write(camera,'T','char');
    write(camera,'O','char');
end

