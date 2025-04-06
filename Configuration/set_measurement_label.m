function response = set_measurement_label(camera,label)
% Purpose: Assign measurement description 
% Syntax: L<Character String with max length of 20 characters>[CR] 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code)  
% Note: Entry remains valid for the duration of the current Remote Mode session or until a new L command is issued. 
% If L[CR] is issued with an empty string, the current description is returned. 
    if ~strcmp(camera.Terminator,"CR")
        configureTerminator(camera,"CR");
    end
    response = writeread(camera,append("L",label));
end

