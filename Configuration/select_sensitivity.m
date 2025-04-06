function response = select_sensitivity(camera,code)
% Sensitivity Mode (PR-670 only) 
% Select the Sensitivity Mode for the next measurement. 
% The two available modes are Standard and Extended. 
% In Standard Mode, the exposure time range is 6 ms to 6,000 ms (6 sec.). 
% In Extended Mode, the upper limit is extended to 30,000 ms (30 sec.). 
% Syntax: SHm[CR]  
% Where: m = Sensitivity Mode  
%        0 = Standard Mode 
%        1 = Extended Mode 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end
    response = writeread(camera,append("SH",string(code)));
end