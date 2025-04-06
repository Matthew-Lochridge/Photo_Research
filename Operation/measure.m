function response = measure(camera,data_code)
% Purpose: Make a Measurement with the PR-6XX 
% Syntax: M<data code>[CR] 
% Response: 0000,<data>[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
% Note: <data> in response code refers to the specific measurement 
%   data set returned based on the data code sent to the instrument. 
% Refer to the Data Code section for specific information. 
    if ~strcmp(camera.Terminator,"CR")
        configureTerminator(camera,"CR");
    end
    response = writeread(camera,append("M",string(data_code)));
end

