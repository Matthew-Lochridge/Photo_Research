function response = select_unit_system(camera,code)
% Photometric Units 
% Select English or Metric (SI) photometric values to be reported in the applicable Data Codes. 
% Syntax: SUn[CR]  
% Where: n = Units type  
%        0 = English 
%        1 = Metric (SI) 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end
    response = writeread(camera,append("SU",string(code)));
end