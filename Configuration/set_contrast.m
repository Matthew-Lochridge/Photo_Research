function response = set_contrast(camera,percentage)
% Purpose: Set the display contrast . 
% Syntax: Xnnn where nnn is the contrast in % - Range 0 to 100% 
% Response: “Contrast set to nnn %” 
% See the Setup Command section for complete details 
    if ~strcmp(camera.Terminator,"")
        configureTerminator(camera,"");
    end
    response = writeread(camera,append("X",string(percentage)));
end

