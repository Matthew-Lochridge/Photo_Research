function response = set_measurement_param(camera,specifier)
% Purpose: Assign instrument and measurement set up parameters 
% Syntax: S[specifier][CR] 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    if ~strcmp(camera.Terminator,"CR")
        configureTerminator(camera,"CR");
    end
    response = writeread(camera,append("S",string(specifier)));
end

