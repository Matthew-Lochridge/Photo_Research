function toggle_echo_mode(camera)
% Purpose: Full Duplex (Echo) ON / OFF 
% Syntax: E[CR] 
% Response: None 
    if ~strcmp(camera.Terminator,"CR")
        configureTerminator(camera,"CR");
    end
    writeline(camera,"E");
end

