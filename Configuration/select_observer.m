function response = select_observer(camera,observer)
% CIE Observer 
% Photometric and Colorimetric values can be calculated using either CIE 2 or 10 Standard Observer data sets. 
% Use this specifier to choose the CIE data set for calculations for the next measurement. The default is 2 deg. 
% Syntax: SOn[CR]  
% Where: n = CIE Observer  
%        2 = 2 deg. 
%        10 = 10 deg. 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end
    response = writeread(camera,append("SO",string(observer)));
end