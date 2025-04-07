function response = update_setup(camera,specifier,user_input)
% Purpose: Assign instrument and measurement set up parameters 
% Syntax: S[specifier][CR] 
% Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 

    if ~strcmp(camera.Terminator,"CR")
        camera.Terminator = "CR";
    end

    switch specifier

        % Purpose: Set LCD backlight level  
        % Syntax: Bnn[CR] 
        %   Bnn = Backlight / Brightness level in percentage. 
        %   Range of nn = 0 to 100% 
        % Response: Backlight set to nn % 
        case "backlight"
            command = append("B",string(user_input));

        % Purpose: Full Duplex (Echo) ON / OFF 
        % Syntax: E[CR] 
        % Response: None 
        case "echo_mode"
            command = "E";

        % Purpose: Assign measurement description 
        % Syntax: L<Character String with max length of 20 characters>[CR] 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code)  
        % Note: Entry remains valid for the duration of the current Remote Mode session or until a new L command is issued. 
        % If L[CR] is issued with an empty string, the current description is returned. 
        case "measurement_label"
            command = append("L",string(user_input));
       
        % Select Add-on Accessory
        % An Add-on accessory is one that is used in conjunction with a primary accessory. 
        % For example, a neutral density filter (Add-on Accessory) used with the MS-75 (Primary Accessory). 
        % Up to 3 Add-on accessories can be specified for a measurement. 
        % Syntax: San[CR]   
        % Where: a = A for Addon 1, B for Addon 2, or C for Addon 3
        %        n = Accessory code 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        % Note: Accessory Codes can be found by running report 116 (command D116). 
        % See the Data Codes section for specific details. 
        case "addon_1"
            command = append("SA",string(user_input));
        case "addon_2"
            command = append("SB",string(user_input));
        case "addon_3"
            command = append("SC",string(user_input));

        % Select Dark Current Mode (PR-670 only) 
        % Two dark current modes are available – Standard and Smart Dark. 
        % In Standard Mode, the instrument measures the detector dark current after each light measurement. 
        % If Smart Dark is enabled and two successive measurements yield the same exposure time, 
        % then the dark current values from the first measurement are used for the second (and possibly successive) measurements. 
        % Syntax: SDn[CR]  
        % Where: n = Dark Current Mode  
        %        0 = Disable Smart Dark 
        %        1 = Enable Smart Dark 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        case "dark_mode"
            command = append("SD",string(user_input));

        % Select Exposure Time 
        % Enter the Exposure (Integration) time for the next measurement in milliseconds. 
        % Possible values are 6 – 6,000 (6 sec.) for Standard Mode, and 6 - 30,000 (30 sec.) for Extended Mode. 
        % See the H specifier for more information on setting Standard or Extended Modes.  
        % To set the instrument to Adaptive Exposure, send SE0 (ttttt = 0) 
        % Syntax: SEttttt[CR]  
        % Where: ttttt = exposure time in milliseconds 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        % Note: Standard and Extended modes apply only to PR-670. PR-655 exposure range is 3 to 6,000 ms 
        case "exposure_time"
            command = append("SE",string(user_input));

        % Aperture Select (PR-670 only) 
        % Select the aperture to be used for the next measurement.   
        % Syntax: SFa[CR]  
        % Where: a = aperture code 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        % Note: See Data Code 117 for details on aperture codes. 
        case "aperture"
            command = append("SF",string(user_input));

        % Speed Mode (PR-670 only) 
        % Select the Speed Mode for the next measurement. Choices are Normal, 1X Fast, 2X Fast and 4X Fast. 
        % Syntax: SGg[CR]  
        % Where: g = Gain  
        %        0 = Normal (DEFAULT),  
        %        1 = 1X for AC sources,  
        %        2 = 10X 
        %        3 = 100X 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        case "gain"
            command = append("SG",string(user_input));

        % Sensitivity Mode (PR-670 only) 
        % Select the Sensitivity Mode for the next measurement. 
        % The two available modes are Standard and Extended. 
        % In Standard Mode, the exposure time range is 6 ms to 6,000 ms (6 sec.). 
        % In Extended Mode, the upper limit is extended to 30,000 ms (30 sec.). 
        % Syntax: SHm[CR]  
        % Where: m = Sensitivity Mode  
        %        0 = Standard Mode 
        %        1 = Extended Mode 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        case "sensitivity"
            command = append("SH",string(user_input));

        % User Sync Frequency 
        % Enter the frequency (in Hertz) of the source being measured. The range is 20 to 400 Hz.  
        % This command works in unison with the SYNC Mode setting. 
        % See the S specifier for complete details on setting the SYNC Mode. 
        % Syntax: SKfff[CR] 
        % Where: fff = frequency in Hertz. Range is 20 to 400 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        case "sync_freq"
            command = append("SK",string(user_input));

        % Cycles to Average 
        % Defines the number of measurements (cycles) to average when calculating photometric and colorimetric values. 
        % The average of the spectra are used to calculate other values. The range of cycles to average is 1 to 99. The default is 1. 
        % Syntax: SNaa[CR] 
        % Where: aa = Cycles to Average  (Range 1 to 99) 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        case "cycles_to_avg"
            command = append("SN",atring(user_input));

        % CIE Observer 
        % Photometric and Colorimetric values can be calculated using either CIE 2 or 10 Standard Observer data sets. 
        % Use this specifier to choose the CIE data set for calculations for the next measurement. The default is 2 deg. 
        % Syntax: SOn[CR]  
        % Where: n = CIE Observer  
        %        2 = 2 deg. 
        %        10 = 10 deg. 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        case "observer"
            command = append("SO",string(user_input));
        
        % Primary Accessory 
        % A Primary Accessory is one that replaces the standard objective lens (typically the MS-75) 
        % during use and can be used in conjunction with an Add-on Accessory. 
        % Syntax: SPnn[CR]  
        % Where: nn = Accessory Code 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        % Note: Accessory Codes can be found by running report 116 (command D116). See the Data Codes section for specific details. 
        case "accessory"
            command = append("SP",string(user_input));

        % Sync Mode 
        % Instructs the instrument to adjust the exposure time, when using Adaptive Sensitivity mode, 
        % to the nearest even multiple of the refresh rate (frequency) of the source. 
        % Choices are No Sync, Auto Sync, and User Frequency. 
        % In Auto Sync mode, the instrument measures the frequency of the source to determine its period. 
        % The exposure time is then automatically altered so that it is an even multiple of the source period (1/frequency). 
        % User Frequency will adjust the exposure time based on a user enter frequency in Hertz as entered using the SK command. 
        % See the User Sync Frequency section for more details on defining the Sync frequency. 
        % Syntax: SQf[CR]  or  SSf[CR]
        % Where: f = Sync mode 
        %        0 = No Sync 
        %        1 = Auto Sync 
        %        3 = User Frequency 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code)
        case "sync_mode"

        % Photometric Units 
        % Select English or Metric (SI) photometric values to be reported in the applicable Data Codes. 
        % Syntax: SUn[CR]  
        % Where: n = Units type  
        %        0 = English 
        %        1 = Metric (SI) 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        case "unit_system"
            command = append("SU",string(user_input));

        % Measure Shutter Control 
        % Controls the actions of the measure shutter. When set to 0 the measure shutter will be closed after each measurement and a dark measurement will be taken. 
        % When Measure shutter control is set to 1, the measure shutter will never close and no dark measurements will be taken. 
        % It is recommended that a measurement be taken with Measure shutter control set to 0 so that a dark measurement can be captured. 
        % Syntax: SZs[CR]  
        % Where: s = Shutter Control 
        %        0 = Close after a measurement 
        %        1 = Never close (always open)  
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        case "shutter_mode"
            command = append("SZ",string(user_input));

        % Purpose: Set the display contrast . 
        % Syntax: Xnnn where nnn is the contrast in % - Range 0 to 100% 
        % Response: “Contrast set to nnn %” 
        % See the Setup Command section for complete details 
        case "contrast"
            command = append("X",string(user_input));
            if ~strcmp(camera.Terminator,"")
                camera.Terminator = "";
            end

        % Purpose: Enable Reset Command Mode 
        % Syntax: ZEnableReset 
        % Response: 00000,Reset Commands Enabled  
        case "enable_reset"
            if ~strcmp(camera.Terminator,"")
                camera.Terminator = "";
            end
            command = "ZEnableReset";

        % Reset Commands: 
        %   ZResetPreferences – Reset all Preferences values to factory default. 
        %   ZResetSetup       – Reset all Setup values to factory default.  
        % NOTE: All Reset Commands will shut down the instrument after they are executed.
        case "reset_preferences"
            if ~strcmp(camera.Terminator,"")
                camera.Terminator = "";
            end
            command = "ZResetPreferences";
        case "reset_setup"
            if ~strcmp(camera.Terminator,"")
                camera.Terminator = "";
            end
            command = "ZResetSetup";

    end

    response = writeread(camera,command);
end