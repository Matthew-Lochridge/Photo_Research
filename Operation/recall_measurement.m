function response = recall_measurement(camera,data_code,measurement_id,file_name)
% Purpose: Recall stored measurement data from the PR-6XX 
% Syntax: R<data code>,<Measurement #>,<filename.ext>[CR] 
% Response: 0000,<data>[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
% Special Syntax 1 (Recall from RAM only): 
% Syntax: R<data code>,0[CR] Recall last written measurement 
% Response: 0000,<data>[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
% Special Syntax 2 (Recall from RAM only): 
% Syntax: R<data code>,+[CR] Increments the  Measurement ID (measurement number) and recalls the data. 
% Response: 0000,<data>[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
% Note: If data code is not specified, code 1 will be sent.  
%   If filename.ext is not specified, data returned will be that stored in the 
%   internal memory (RAM) of the instrument instead of the SD card. 
% <data> in response code refers to the specific measurement data set returned based on the 
% data code sent to the instrument. Refer to the Data Code section for specific information. 
    command = 'R';
    if ~strcmp(camera.Terminator,'CR')
        configureTerminator(camera,'CR');
    end
    response = writeread(camera,command);
end

