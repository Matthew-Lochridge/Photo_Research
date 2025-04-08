function response = get_status(camera)
% Purpose: Return instrument status / error report 
% Syntax: I[CR]  
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    response = writeread(camera,'I');
end