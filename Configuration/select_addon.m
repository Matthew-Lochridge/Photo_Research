function response = select_addon(camera,code,number)
% Select Add-on Accessory
% An Add-on accessory is one that is used in conjunction with a primary accessory. 
% For example, a neutral density filter (Add-on Accessory) used with the MS-75 (Primary Accessory). 
% Up to 3 Add-on accessories can be specified for a measurement. 
% Syntax: San[CR]   
% Where: a = A for Addon 1, B for Addon 2, or C for Addon 3
%        n = Accessory code 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
% Note: Accessory Codes can be found by running report 116 (command D116). 
% See the Data Codes section for specific details. 
    command = "S";
    switch number
        case 1
            command = append(command,"A",string(code));
        case 2
            command = append(command,"B",string(code));
        case 3
            command = append(command,"C",string(code));
    end
    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end
    response = writeread(camera,command);
end