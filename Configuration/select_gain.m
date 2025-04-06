function response = select_gain(camera,code)
% Speed Mode (PR-670 only) 
% Select the Speed Mode for the next measurement. Choices are Normal, 1X Fast, 2X Fast and 4X Fast. 
% Syntax: SGg[CR]  
% Where: g = Gain  
%        0 = Normal (DEFAULT),  
%        1 = 1X for AC sources,  
%        2 = 10X 
%        3 = 100X 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end
    response = writeread(camera,append("SG",string(code)));
end