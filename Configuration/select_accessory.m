function response = select_accessory(camera,code)
% Primary Accessory 
% A Primary Accessory is one that replaces the standard objective lens (typically the MS-75) 
% during use and can be used in conjunction with an Add-on Accessory. 
% Syntax: SPnn[CR]  
% Where: nn = Accessory Code 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
% Note: Accessory Codes can be found by running report 116 (command D116). See the Data Codes section for specific details. 
    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end
    response = writeread(camera,append("SP",string(code)));
end