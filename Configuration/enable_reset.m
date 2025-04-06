function response = enable_reset(camera)
% Purpose: Enable Reset Command Mode 
% Syntax: ZEnableReset 
% Response: 00000,Reset Commands Enabled  
% Reset Commands: 
%   ZResetPreferences – Reset all Preferences values to factory default. 
%   ZResetSetup       – Reset all Setup values to factory default.  
% NOTE: All Reset Commands will shut down the instrument after they are executed.
    if ~strcmp(camera.Terminator,"")
        configureTerminator(camera,"");
    end 
    response = writeread(camera,"ZEnableReset");
end

