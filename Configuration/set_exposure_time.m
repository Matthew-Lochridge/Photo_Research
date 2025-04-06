function response = set_exposure_time(camera,time)
% Select Exposure Time 
% Enter the Exposure (Integration) time for the next measurement in milliseconds. 
% Possible values are 6 – 6,000 (6 sec.) for Standard Mode, and 6 - 30,000 (30 sec.) for Extended Mode. 
% See the H specifier for more information on setting Standard or Extended Modes.  
% To set the instrument to Adaptive Exposure, send SE0 (ttttt = 0) 
% Syntax: SEttttt[CR]  
% Where: ttttt = exposure time in milliseconds 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
% Note: Standard and Extended modes apply only to PR-670. PR-655 exposure range is 3 to 6,000 ms 
    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end
    response = writeread(camera,append("SE",string(time)));
end