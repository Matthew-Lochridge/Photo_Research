function response = set_backlight(camera,percentage)
% Purpose: Set LCD backlight level  
% Syntax: Bnn[CR] 
%   Bnn = Backlight / Brightness level in percentage. 
%   Range of nn = 0 to 100% 
% Response: Backlight set to nn % 
    if ~strcmp(camera.Terminator,"CR")
        configureTerminator(camera,"CR");
    end
    response = writeread(camera,append("B",string(percentage)));
end

