function response = get_status(camera)
% Purpose: Return instrument status / error report 
% Syntax: I[CR]  
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    if ~strcmp(camera.Terminator,'CR')
        configureTerminator(camera,'CR');
    end
    response = writeread(camera,'I');
end