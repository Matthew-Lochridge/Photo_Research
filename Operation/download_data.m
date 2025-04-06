function response = download_data(camera,data_code)
% Purpose: Download data from the PR-6XX 
% Syntax: D<data code>[CR] 
% Response: 0000,<data>[CR][LF] If all OK, else NNNN[CR][LF] (NNNNN = Error code) 
% Note: <data> in response code refers to the specific measurement data set returned 
%   based on the data code sent to the instrument. Refer to the Data Code section for details. 
    command = "D";
    if nargin == 2
        command = append(command,string(data_code));
    end
    if ~strcmp(camera.Terminator,"CR")
        configureTerminator(camera,"CR");
    end
    response = writeread(camera,command);
end

