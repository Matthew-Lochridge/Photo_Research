function response = select_sync_mode(camera,code)
% Sync Mode 
% Instructs the instrument to adjust the exposure time, when using Adaptive Sensitivity mode, 
% to the nearest even multiple of the refresh rate (frequency) of the source. 
% Choices are No Sync, Auto Sync, and User Frequency. 
% In Auto Sync mode, the instrument measures the frequency of the source to determine its period. 
% The exposure time is then automatically altered so that it is an even multiple of the source period (1/frequency). 
% User Frequency will adjust the exposure time based on a user enter frequency in Hertz as entered using the SK command. 
% See the User Sync Frequency section for more details on defining the Sync frequency. 
% Syntax: SQf[CR]  or  SSf[CR]
% Where: f = Sync mode 
%        0 = No Sync 
%        1 = Auto Sync 
%        3 = User Frequency 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code)
    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end
    response = writeread(camera,append("SQ",string(code)));
end