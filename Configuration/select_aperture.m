function response = select_aperture(camera,code)
% Aperture Select (PR-670 only) 
% Select the aperture to be used for the next measurement.   
% Syntax: SFa[CR]  
% Where: a = aperture code 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
% Note: See Data Code 117 for details on aperture codes. 
    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end
    response = writeread(camera,append("SF",string(code)));
end