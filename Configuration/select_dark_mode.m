function response = select_dark_mode(camera,code)
% Select Dark Current Mode (PR-670 only) 
% Two dark current modes are available – Standard and Smart Dark. 
% In Standard Mode, the instrument measures the detector dark current after each light measurement. 
% If Smart Dark is enabled and two successive measurements yield the same exposure time, 
% then the dark current values from the first measurement are used for the second (and possibly successive) measurements. 
% Syntax: SDn[CR]  
% Where: n = Dark Current Mode  
%        0 = Disable Smart Dark 
%        1 = Enable Smart Dark 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end
    response = writeread(camera,append("SD",string(code)));
end

