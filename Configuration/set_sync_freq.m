function response = set_sync_freq(camera,freq)
% User Sync Frequency 
% Enter the frequency (in Hertz) of the source being measured. The range is 20 to 400 Hz.  
% This command works in unison with the SYNC Mode setting. 
% See the S specifier for complete details on setting the SYNC Mode. 
% Syntax: SKfff[CR] 
% Where: fff = frequency in Hertz. Range is 20 to 400 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end
    response = writeread(camera,append("SK",string(freq)));
end