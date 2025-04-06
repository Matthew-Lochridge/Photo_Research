function reset_preferences(camera)
% ZResetPreferences – Reset all Preferences values to factory default. 
% NOTE: All Reset Commands will shut down the instrument after they are executed.
    write(camera,"ZResetPreferences","string");
end

