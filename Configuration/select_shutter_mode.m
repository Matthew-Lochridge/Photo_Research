function response = select_shutter_mode(camera,code)
% Measure Shutter Control 
% Controls the actions of the measure shutter. When set to 0 the measure shutter will be closed after each measurement and a dark measurement will be taken. 
% When Measure shutter control is set to 1, the measure shutter will never close and no dark measurements will be taken. 
% It is recommended that a measurement be taken with Measure shutter control set to 0 so that a dark measurement can be captured. 
% Syntax: SZs[CR]  
% Where: s = Shutter Control 
%        0 = Close after a measurement 
%        1 = Never close (always open)  
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end
    response = writeread(camera,append("SZ",string(code)));
end