function response = measure_source_freq(camera)
% Purpose: Measure frequency of light source 
% Syntax: F[CR] 
% Response: 0000,ff.ff Hertz (Period = nnnnn milliseconds) If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    if ~strcmp(camera.Terminator,"CR")
        configureTerminator(camera,"CR");
    end
    response = writeread(camera,"F");
end

