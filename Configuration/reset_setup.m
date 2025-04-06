function reset_setup(camera)
% ZResetSetup – Reset all Setup values to factory default.  
% NOTE: All Reset Commands will shut down the instrument after they are executed.
    write(camera,"ZResetSetup","string");
end

