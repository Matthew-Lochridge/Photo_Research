function response = set_cycles_to_avg(camera,number)
% Cycles to Average 
% Defines the number of measurements (cycles) to average when calculating photometric and colorimetric values. 
% The average of the spectra are used to calculate other values. The range of cycles to average is 1 to 99. The default is 1. 
% Syntax: SNaa[CR] 
% Where: aa = Cycles to Average  (Range 1 to 99) 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end
    response = writeread(camera,append("SN",string(number)));
end

