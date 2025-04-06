function enter_remote_mode(camera)
% Entering Remote Mode 
% To enter remote mode “P” “H” “O” “T” “O” must be sent as single characters and not as a single string.   
    write(camera,"P","string");
    write(camera,"H","string");
    write(camera,"O","string");
    write(camera,"T","string");
    write(camera,"O","string");
end

