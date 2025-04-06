function clear_error(camera)
% Purpose: Clears the current instrument error 
% Syntax: C[CR] 
% Response: None 
    if ~strcmp(camera.Terminator,"CR")
        configureTerminator(camera,"CR");
    end
    writeline(camera,"C");
end

