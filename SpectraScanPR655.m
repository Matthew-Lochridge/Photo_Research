classdef SpectraScanPR655 < handle

    properties
        serial_port
        timeout {mustBeNumeric}
        status_code {mustBeNumeric}
        echo_mode = 'Disabled';
        serial_number {mustBeNumeric}
        model
        software_version
        bandwidth {mustBeNumeric}
        last_exposure_time {nustBeNumeric}
        last_sync_frequency {mustBeNumeric}
        primary_lens
        addon1
        addon2
        addon3
        aperture
        unit_system
        exposure_mode
        speed_mode
        cycles_to_average {mustBeNumeric}
        CIE_observer
        dark_mode
        sync_mode
        shutter_mode
        photometry_mode
        radiometry_mode
    end

    methods
        function device = SpectraScanPR655(serial_port)
            device = serialport(serial_port, 2400, 'FlowControl', 'hardware');
            configureTerminator(device, 'CR/LF', 'CR');
            device.serial_port = serial_port;
        end

        function set_timeout(device, timeout)
            set(device, 'Timeout', timeout);
            device.timeout = timeout;
        end

        % Entering Remote Mode 
        % To enter remote mode "P" "H" "O" "T" "O" must be sent as single characters and not as a single string.
        % Response:  REMOTE MODE
        function status = connect(device)
            write(device, 'P', 'char');
            write(device, 'H', 'char');
            write(device, 'O', 'char');
            write(device, 'T', 'char');
            write(device, 'O', 'char');
            status = read(device, 12, 'char');
        end

        % Q Command
        % Purpose: Quit (Exit) Remote mode  
        % Syntax: Q 
        % Response: None 
        function disconnect(device)
            write(device, 'Q', 'char');
        end

        % I Command
        % Purpose: Return instrument status / error report 
        % Syntax: I[CR]  
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        function status = update_status(device)
            device.status_code = str2double(writeread(device, 'I'));
            status = device.read_code(device, 'Error', device.status_code);
        end

        % C Command
        % Purpose: Clears the current instrument error 
        % Syntax: C[CR] 
        % Response: None 
        function status = clear_error(device)
            device.status_code = str2double(writeread(device, 'C'));
            status = device.read_code(device, 'Error', device.status_code);
        end

        % F Command
        % Purpose: Measure frequency of light source 
        % Syntax: F[CR] 
        % Response: 0000,ff.ff Hertz (Period = nnnnn milliseconds) If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        function [source_frequency, status] = measure_source_frequency(device) 
            response = str2double(split(writeread(device, 'F'), ','));
            device.status_code = response{1};
            source_frequency = response{2};
            status = device.read_code(device, 'Error', device.status_code);
        end

        % M Command
        % Purpose: Make a Measurement with the PR-6XX 
        % Syntax: M<data code>[CR] 
        % Response: 0000,<data>[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        % Note: <data> in response code refers to the specific measurement 
        %   data set returned based on the data code sent to the instrument. 
        % Refer to the Data Code section for specific information. 
        
        % D Command
        % Purpose: Download data from the PR-6XX 
        % Syntax: D<data code>[CR] 
        % Response: 0000,<data>[CR][LF] If all OK, else NNNN[CR][LF] (NNNNN = Error code) 
        % Note: <data> in response code refers to the specific measurement data set returned 
        %   based on the data code sent to the instrument. Refer to the Data Code section for details. 
    
        % R Command
        % Purpose: Recall stored measurement data from the PR-6XX 
        % Syntax: R<data code>,<Measurement #>,<filename.ext>[CR] 
        % Response: 0000,<data>[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        % Special Syntax 1 (Recall from RAM only): 
        % Syntax: R<data code>,0[CR] Recall last written measurement 
        % Response: 0000,<data>[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        % Special Syntax 2 (Recall from RAM only): 
        % Syntax: R<data code>,+[CR] Increments the  Measurement ID (measurement number) and recalls the data. 
        % Response: 0000,<data>[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        % Note: If data code is not specified, code 1 will be sent.  
        %   If filename.ext is not specified, data returned will be that stored in the 
        %   internal memory (RAM) of the instrument instead of the SD card. 
        % <data> in response code refers to the specific measurement data set returned based on the 
        % data code sent to the instrument. Refer to the Data Code section for specific information. 

        function status = write_to_disk(device)
            device.status_code = str2double(writeread(device, 'D0'));
            status = device.read_code(device, 'Error', device.status_code);
        end

        function [Y, x, y, R, G, B, status] = get_CIE_1931(device, command)
            if strcmpi(command, 'Measure')
                response = str2double(split(writeread(device, 'M1'), ','));
            elseif strcmpi(command, 'Download')
                response = str2double(split(writeread(device, 'D1'), ','));
            end
            device.status_code = response{1};
            Y = response{3};
            x = response{4};
            y = response{5};
            response = str2double(split(writeread(device, 'D2'), ','));
            device.status_code = response{1};
            R = response{3};
            G = response{4};
            B = response{5};
            status = device.read_code(device, 'Error', device.status_code);
        end

        function [Y, u, v, status] = get_CIE_1960(device, command)
            if strcmpi(command, 'Measure')
                response = str2double(split(writeread(device, 'M7'), ','));
            elseif strcmpi(command, 'Download')
                response = str2double(split(writeread(device, 'D7'), ','));
            end
            device.status_code = response{1};
            Y = response{3};
            u = response{4};
            v = response{5};
            status = device.read_code(device, 'Error', device.status_code);
        end

        function [Y, u_prime, v_prime, status] = get_CIE_1976(device, command)
            if strcmpi(command, 'Measure')
                response = str2double(split(writeread(device, 'M6'), ','));
            elseif strcmpi(command, 'Download')
                response = str2double(split(writeread(device, 'D6'), ','));
            end
            device.status_code = response{1};
            Y = response{3};
            u_prime = response{4};
            v_prime = response{5};
            status = device.read_code(device, 'Error', device.status_code);
        end

        function [Y, CCT, Planck_locus_deviation, status] = get_CCT(device, command)
            if strcmpi(command, 'Measure')
                response = str2double(split(writeread(device, 'M4'), ','));
            elseif strcmpi(command, 'Download')
                response = str2double(split(writeread(device, 'D4'), ','));
            end
            device.status_code = response{1};
            Y = response{3};
            CCT = response{4};
            Planck_locus_deviation = response{5};
            status = device.read_code(device, 'Error', device.status_code);
        end

        function [peak_wavelength, integrated_radiometric, integrated_photon_radiometric, wavelengths, radiometric_spectrum, status] = get_radiometric_spectrum(device, command)
            if strcmpi(command, 'Measure')
                response = str2double(split(writeread(device, 'M5'), ','));
            elseif strcmpi(command, 'Download')
                response = str2double(split(writeread(device, 'D5'), ','));
            end
            device.status_code = response{1};
            peak_wavelength = response{3};
            integrated_radiometric = response{4};
            integrated_photon_radiometric = response{5};
            wavelengths = cell2mat(response{6:2:end-1});
            radiometric_spectrum = cell2mat(response{7:2:end});
            status = device.read_code(device, 'Error', device.status_code);
        end

        function [S, status] = get_scotopic_brightness(device, command)
            if strcmpi(command, 'Measure')
                response = str2double(split(writeread(device, 'M11'), ','));
            elseif strcmpi(command, 'Download')
                response = str2double(split(writeread(device, 'D11'), ','));
            end
            device.status_code = response{1};
            S = response{3};
            status = device.read_code(device, 'Error', device.status_code);
        end

        function [raw_light, status] = get_raw_light(device, command)
            if strcmpi(command, 'Measure')
                response = str2double(split(writeread(device, 'M8'), ','));
            elseif strcmpi(command, 'Download')
                response = str2double(split(writeread(device, 'D8'), ','));
            end
            device.status_code = response{1};
            raw_light = cell2mat(response{2:end});
            status = device.read_code(device, 'Error', device.status_code);
        end

        function [raw_dark, status] = get_raw_dark(device, command)
            if strcmpi(command, 'Measure')
                response = str2double(split(writeread(device, 'M9'), ','));
            elseif strcmpi(command, 'Download')
                response = str2double(split(writeread(device, 'D9'), ','));
            end
            device.status_code = response{1};
            raw_dark = cell2mat(response{2:end});
            status = device.read_code(device, 'Error', device.status_code);
        end

        function status = update_device_info(device, command)
            if strcmpi(command, 'Measure')
                response = str2double(split(writeread(device, 'M110'), ','));
            elseif strcmpi(command, 'Download')
                response = str2double(split(writeread(device, 'D110'), ','));
            end
            device.status_code = response{1};
            device.serial_number = response{2};
            response = split(writeread(device, 'D13'), ',');
            device.status_code = str2double(response{1});
            device.last_exposure_time = str2double(response{3});
            response = split(writeread(device, 'D14'), ',');
            device.status_code = str2double(response{1});
            device.last_sync_frequency = str2double(response{3}};
            response = split(writeread(device, 'D111'), ',');
            device.status_code = str2double(response{1});
            device.model = response{2};
            response = split(writeread(device, 'D114'), ',');
            device.status_code = str2double(response{1});
            device.software_version = response{2};
            response = split(writeread(device, 'D116'), ',');
            device.status_code = str2double(response{1});
            device.photometry_mode = response{end-1};
            device.radiometry_mode = response{end};
            response = str2double(split(writeread(device, 'D601'), ','));
            device.status_code = str2double(response{1});
            device.primary_lens = device.read_code(device, 'Primary', response{2});
            device.addon1 = device.read_code(device, 'Addon', response{3});
            device.addon2 = device.read_code(device, 'Addon', response{4});
            device.addon3 = device.read_code(device, 'Addon', response{5});
            device.aperture = device.read_code(device, 'Aperture', response{6});
            device.unit_system = device.read_code(device, 'Unit System', response{7});
            device.exposure_mode = device.read_code(device, 'Exposure Mode', response{8});
            device.speed_mode = device.read_code(device, 'Speed Mode', response{10});
            device.cycles_to_average = response{11};
            device.CIE_observer = device.read_code(device, 'CIE Observer', response{12});
            device.dark_mode = device.read_code(device, 'Dark Mode', response{13});
            device.sync_mode = device.read_code(device, 'Sync Mode', response{14});
            device.shutter_mode = device.read_code(device, 'Shutter Mode', response{15});
            status = device.read_code(device, 'Error', device.status_code);
        end

        % L Command
        % Purpose: Assign measurement description 
        % Syntax: L<Character String with max length of 20 characters>[CR] 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code)  
        % Note: Entry remains valid for the duration of the current Remote Mode session or until a new L command is issued. 
        % If L[CR] is issued with an empty string, the current description is returned. 
        function status = set_measurement_description(device, description)
            device.status_code = str2double(writeread(device, append('L', description)));
            status = device.read_code(device, 'Error', device.status_code);
        end

        function [description, status] = get_measurement_description(device)
            response = split(writeread(device, 'L'), ',');
            device.status_code = str2double(response{1});
            description = response{2};
            status = device.read_code(device, 'Error', device.status_code);
        end

        % B Command
        % Purpose: Set LCD backlight level  
        % Syntax: Bnn[CR] 
        %   Bnn = Backlight / Brightness level in percentage. 
        %   Range of nn = 0 to 100% 
        % Response: Backlight set to nn % 
        function status = set_backlight(device, level)
            device.status_code = str2double(writeread(device, append('B', num2str(level))));
            status = device.read_code(device, 'Error', device.status_code);
        end

        % X Command
        % Purpose: Set the display contrast . 
        % Syntax: Xnnn where nnn is the contrast in % - Range 0 to 100% 
        % Response: "Contrast set to nnn %" 
        % See the Setup Command section for complete details 
        function status = set_contrast(device, level)
            device.status_code = str2double(writeread(device, append('X', num2str(level)), 'char'));
            status = device.read_code(device, 'Error', device.status_code);
        end

        % E Command
        % Purpose: Full Duplex (Echo) ON / OFF 
        % Syntax: E[CR] 
        % Response: None 
        function status = toggle_echo(device)
            if strcmpi(device.echo_mode, 'Disabled')
                device.echo_mode = 'Enabled';
            elseif strcmpi(device.echo_mode, 'Enabled')
                device.echo_mode = 'Disabled';
            end
            device.status_code = str2double(writeread(device, 'E'));
            status = device.read_code(device, 'Error', device.status_code);
        end

        % S Commands
        % Purpose: Assign instrument and measurement set up parameters 
        % Syntax: S[specifier][CR] 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
           
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
        function status = select_addon1(device, description)
            device.status_code = str2double(writeread(device, append('SA', device.get_code(device, 'Addon', description))));
            status = device.read_code(device, 'Error', device.status_code);
        end

        function status = select_addon2(device, description)
            device.status_code = str2double(writeread(device, append('SB', device.get_code(device, 'Addon', description))));
            status = device.read_code(device, 'Error', device.status_code);
        end

        function status = select_addon3(device, description)
            device.status_code = str2double(writeread(device, append('SC', device.get_code(device, 'Addon', description))));
            status = device.read_code(device, 'Error', device.status_code);
        end
    
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
        function status = select_dark_mode(device, description)
            device.status_code = str2double(writeread(device, append('SD', device.get_code(device, 'Dark Mode', description))));
            status = device.read_code(device, 'Error', device.status_code);
        end
    
        % Select Exposure Time 
        % Enter the Exposure (Integration) time for the next measurement in milliseconds. 
        % Possible values are 6 – 6,000 (6 sec.) for Standard Mode, and 6 - 30,000 (30 sec.) for Extended Mode. 
        % See the H specifier for more information on setting Standard or Extended Modes.  
        % To set the instrument to Adaptive Exposure, send SE0 (ttttt = 0) 
        % Syntax: SEttttt[CR]  
        % Where: ttttt = exposure time in milliseconds 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        % Note: Standard and Extended modes apply only to PR-670. PR-655 exposure range is 3 to 6,000 ms 
        function status = set_exposure_time(device, exposure_time)
            device.status_code = str2double(writeread(device, append('SE', exposure_time)));
            status = device.read_code(device, 'Error', device.status_code);
        end
    
        % Aperture Select (PR-670 only) 
        % Select the aperture to be used for the next measurement.   
        % Syntax: SFa[CR]  
        % Where: a = aperture code 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        % Note: See Data Code 117 for details on aperture codes. 
        function status = select_aperture(device, description)
            device.status_code = str2double(writeread(device, append('SF', device.get_code(device, 'Aperture', description))));
            status = device.read_code(device, 'Error', device.status_code);
        end
    
        % Speed Mode (PR-670 only) 
        % Select the Speed Mode for the next measurement. Choices are Normal, 1X Fast, 2X Fast and 4X Fast. 
        % Syntax: SGg[CR]  
        % Where: g = Gain  
        %        0 = Normal (DEFAULT),  
        %        1 = 1X for AC sources,  
        %        2 = 10X 
        %        3 = 100X 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        function status = select_speed_mode(device, description)
            device.status_code = str2double(writeread(device, append('SG', device.get_code(device, 'Speed Mode', description))));
            status = device.read_code(device, 'Error', device.status_code);
        end
    
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
        function status = select_sensitivity_mode(device, description)
            device.status_code = str2double(writeread(device, append('SH', device.get_code(device, 'Sensitivity Mode', description))));
            status = device.read_code(device, 'Error', device.status_code);
        end
    
        % User Sync Frequency 
        % Enter the frequency (in Hertz) of the source being measured. The range is 20 to 400 Hz.  
        % This command works in unison with the SYNC Mode setting. 
        % See the S specifier for complete details on setting the SYNC Mode. 
        % Syntax: SKfff[CR] 
        % Where: fff = frequency in Hertz. Range is 20 to 400 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        function status = set_source_frequency(device, source_frequency)
            device.status_code = str2double(writeread(device, append('SK', source_frequency)));
            status = device.read_code(device, 'Error', device.status_code);
        end
    
        % Cycles to Average 
        % Defines the number of measurements (cycles) to average when calculating photometric and colorimetric values. 
        % The average of the spectra are used to calculate other values. The range of cycles to average is 1 to 99. The default is 1. 
        % Syntax: SNaa[CR] 
        % Where: aa = Cycles to Average  (Range 1 to 99) 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        function status = set_cycles_to_average(device, num_cycles)
            device.status_code = str2double(writeread(device, append('SN', num_cycles)));
            status = device.read_code(device, 'Error', device.status_code);
        end
    
        % CIE Observer 
        % Photometric and Colorimetric values can be calculated using either CIE 2 or 10 Standard Observer data sets. 
        % Use this specifier to choose the CIE data set for calculations for the next measurement. The default is 2 deg. 
        % Syntax: SOn[CR]  
        % Where: n = CIE Observer  
        %        2 = 2 deg. 
        %        10 = 10 deg. 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        function status = select_CIE_observer(device, description)
            device.status_code = str2double(writeread(device, append('SO', device.get_code(device, 'CIE Observer', description))));
            status = device.read_code(device, 'Error', device.status_code);
        end
        
        % Primary Accessory 
        % A Primary Accessory is one that replaces the standard objective lens (typically the MS-75) 
        % during use and can be used in conjunction with an Add-on Accessory. 
        % Syntax: SPnn[CR]  
        % Where: nn = Accessory Code 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        % Note: Accessory Codes can be found by running report 116 (command D116). See the Data Codes section for specific details. 
        function status = select_primary_lens(device, description)
            device.status_code = str2double(writeread(device, append('SP', device.get_code(device, 'Primary', description))));
            status = device.read_code(device, 'Error', device.status_code);
        end
    
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
        function status = select_sync_mode(device, description)
            device.status_code = str2double(writeread(device, append('SQ', device.get_code(device, 'Sync Mode', description))));
            status = device.read_code(device, 'Error', device.status_code);
        end
    
        % Photometric Units 
        % Select English or Metric (SI) photometric values to be reported in the applicable Data Codes. 
        % Syntax: SUn[CR]  
        % Where: n = Units type  
        %        0 = English 
        %        1 = Metric (SI) 
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        function status = select_unit_system(device, description)
            device.status_code = str2double(writeread(device, append('SU', device.get_code(device, 'Unit System', description))));
            status = device.read_code(device, 'Error', device.status_code);
        end
    
        % Measure Shutter Control 
        % Controls the actions of the measure shutter. When set to 0 the measure shutter will be closed after each measurement and a dark measurement will be taken. 
        % When Measure shutter control is set to 1, the measure shutter will never close and no dark measurements will be taken. 
        % It is recommended that a measurement be taken with Measure shutter control set to 0 so that a dark measurement can be captured. 
        % Syntax: SZs[CR]  
        % Where: s = Shutter Control 
        %        0 = Close after a measurement 
        %        1 = Never close (always open)  
        % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        function status = select_shutter_mode(device, description)
            device.status_code = str2double(writeread(device, append('SZ', device.get_code(device, 'Shutter Mode', description))));
            status = device.read_code(device, 'Error', device.status_code);
        end

        % Purpose: Enable Reset Command Mode 
        % Syntax: ZEnableReset 
        % Response: 00000,Reset Commands Enabled  
        % Reset Commands: 
        %   ZResetPreferences – Reset all Preferences values to factory default. 
        %   ZResetSetup       – Reset all Setup values to factory default.  
        % NOTE: All Reset Commands will shut down the instrument after they are executed.
        function status = enable_reset(device)
            device.status_code = str2double(writeread(device, 'ZEnableReset', 'char'));
            status = device.read_code(device, 'Error', device.status_code);
        end

        function reset_preferences(device)
            write(device, 'ZResetPreferences', 'char');
        end

        function reset_setup(device)
            write(device, 'ZResetSetup', 'char');
        end

        function code = get_code(device, field, description)
            code = []; % default output
            switch field
                case 'Primary'
                    switch description
                        case 'MS-75'
                            code = 0;
                    end
                case 'Addon'
                    switch description
                        case 'None'
                            code = -1;
                    end
                case 'Aperture'
                    switch description
                        case '1 deg'
                            code = 0;
                        case '1/2 deg'
                            code = 1;
                        case '1/4 deg'
                            code = 2;
                        case '1/8 deg'
                            code = 3;
                    end
                case 'Dark Mode'
                    switch description
                        case 'Standard'
                            code = 0;
                        case 'Smart Dark'
                            code = 1;
                    end
                case 'Speed Mode'
                    switch description
                        case 'Normal'
                            code = 0;
                        case 'Fast'
                            code = 1;
                        case '2X Fast'
                            code = 2;
                        case '4X Fast'
                            code = 3;
                    end
                case 'Sensitivity Mode'
                    switch description
                        case 'Standard'
                            code = 0;
                        case 'Extended'
                            code = 1;
                    end
                case 'Exposure Mode'
                    switch description
                        case 'Adaptive'
                            code = 0;
                        case 'User Time'
                            code = 1;
                    end
                case 'Shutter Mode'
                    switch description
                        case 'Close after measurement'
                            code = 0;
                        case 'Always open'
                            code = 1;
                    end
                case 'Sync Mode'
                    switch description
                        case 'No Sync'
                            code = 0;
                        case 'Auto Sync'
                            code = 1;
                        case 'User Frequency'
                            code = 2;
                    end
                case 'CIE Observer'
                    switch description
                        case '2 deg'
                            code = 2;
                        case '10 deg'
                            code = 10;
                    end
                case 'Unit System'
                    switch description
                        case 'Imperial'
                            code = 0;
                        case 'SI'
                            code = 1;
                    end
                case 'Unit'
                    switch description
                        case 'fL' % Luminance (Imperial)
                            code = 111;
                        case 'cd/m2' % Luminance (SI)
                            code = 111;
                        case 'W/sr/m2' % Radiance
                            code = 11;
                        case 'fc' % Illuminance (Imperial)
                            code = 112;
                        case 'lux' % Illuminance (SI)
                            code = 112;
                        case 'W/m2' % Irradiance
                            code = 12;
                        case 'mcd' % Luminous Intensity
                            code = 113;
                        case 'W/sr' % Radiant Intensity
                            code = 13;
                        case 'lumens' % Luminous Flux
                            code = 114;
                        case 'W' % Radiant Flux
                            code = 14;
                    end
            end
        end

        function description = read_code(device, field, code)
            description = ''; % default output
            switch field
                case 'Primary'
                    switch code
                        case 0
                            description = 'MS-75';
                    end
                case 'Addon'
                    switch code
                        case -1
                            description = 'None';
                    end
                case 'Aperture'
                    switch code
                        case 0
                            description = '1 deg';
                        case 1
                            description = '1/2 deg';
                        case 2
                            description = '1/4 deg';
                        case 3
                            description = '1/8 deg';
                    end
                case 'Smart Dark Mode'
                    switch code
                        case 0
                            description = 'Disabled';
                        case 1
                            description = 'Enabled';
                    end
                case 'Gain'
                    switch code
                        case 0
                            description = 'Normal';
                        case 1
                            description = 'Fast';
                        case 2
                            description = '2X Fast';
                        case 3
                            description = '4X Fast';
                    end
                case 'Sensitivity'
                    switch code
                        case 0
                            description = 'Standard';
                        case 1
                            description = 'Extended';
                    end
                case 'Exposure Mode'
                    switch code
                        case 0
                            description = 'Adaptive';
                        case 1
                            description = 'User Time';
                    end
                case 'Shutter Mode'
                    switch code
                        case 0
                            description = 'Close after measurement';
                        case 1
                            description = 'Always open';
                    end
                case 'Sync Mode'
                    switch code
                        case 0
                            description = 'No Sync';
                        case 1
                            description = 'Auto Sync';
                        case 2
                            description = 'User Frequency';
                    end
                case 'CIE Observer'
                    switch code
                        case 2
                            description = '2 deg';
                        case 10
                            description = '10 deg';
                    end
                case 'Unit System'
                    switch code
                        case 0
                            description = 'Imperial';
                        case 1
                            description = 'SI';
                    end
                case 'Unit'
                    switch code
                        case 111 % Luminance
                            if strcmpi(device.unit_system, 'Imperial')
                                description = 'fL';
                            elseif strcmpi(device.unit_system, 'SI')
                                description = 'cd/m^2';
                            end
                        case 11 % Radiance
                            description = 'W/sr/m^2';
                        case 112 % Illuminance
                            if strcmpi(device.unit_system, 'Imperial')
                                description = 'fc';
                            elseif strcmpi(device.unit_system, 'SI')
                                description = 'lux';
                            end
                        case 12 % Irradiance
                            description = 'W/m^2';
                        case 113 % Luminous Intensity
                            description = 'mcd';
                        case 13 % Radiant Intensity
                            description = 'W/sr';
                        case 114 % Luminous Flux
                            description = 'lumens';
                        case 14 % Radiant Flux
                            description = 'W';
                    end
                case 'Error'
                    switch code
                        case 0
                            description = 'No error.';
                        case -1
                            description = 'Light source not constant.';
                        case -2
                            description = 'Light overload – signal too intense.';
                        case -3
                            description = 'Cannot Sync to light source.  Light source frequency below 20 Hz, above 400 Hz, or signal too low to Sync.';
                        case -4
                            description = 'Adaptive mode error.';
                        case -8
                            description = 'Weak light – insufficient signal.';
                        case -9
                            description = 'Sync error.';
                        case -10
                            description = 'Cannot auto sync to light source.';
                        case -12
                            description = 'Adaptive mode time out. Light source not constant.';
                        case -1000
                            description = 'Illegal command.';
                        case -1001
                            description = 'Too many fields in setup command.';
                        case -1002
                            description = 'Invalid primary accesory code.';
                        case -1003
                            description = 'Invalid Addon 1 accessory code.';
                        case -1004
                            description = 'Invalid Addon 2 accessory code.';
                        case -1005
                            description = 'Accessory is not a primary accessory.';
                        case -1006
                            description = 'Accessory is not an addon accessory.';
                        case -1007
                            description = 'Accessory already selected.';
                        case -1008
                            description = 'Invalid aperture index (PR-670 only).';
                        case -1009
                            description = 'Invalid units code.\n0 = English\n1 = Metric (SI)';
                        case -1010
                            description = 'invalid exposure value.\nPR-655: 3-6000 ms\nPR-670: 6-30,000 ms';
                        case -1011
                            description = 'Invalid gain code.\n0 = Normal\n1 = 1X for AC sources\n2 = 10X\n3 = 100X';
                        case -1012
                            description = 'Invalid average cycles. Valid values are 1-99.';
                        case -1015
                            description = 'Invalid CIE observer. Valid values are 2 or 10.';
                        case -1017
                            description = 'Invalid dark measurement mode.\n0 = Disable smart dark\n1 = Enable smart dark';
                        case -1019
                            description = 'Invlid sync mode.\n0 = No sync\n1 = Auto sync\n3 = User frequency';
                        case -1021
                            description = 'Measurement title too long (> 20 characters).';
                        case -1022
                            description = 'Measurement title field empty after sending L command.';
                        case -1023
                            description = 'Invalid user sync frequency. Valid values are 20-400 Hz.';
                        case -1024
                            description = 'Invalid R command.';
                        case -1025
                            description = 'Invalid Addon 3 accessory code.';
                        case -1026
                            description = 'Invalid sensitivity mode.\n0 = Standard mode\n1 = Extended mode';
                        case -1035
                            description = 'Parameter not applicable to this instrument.';
                        case -2000
                            description = 'Requested response code does not exist, or no other D command has been sent previously.';
                        otherwise
                            description = 'Error code not recognized.';
                    end
            end
        end

    end
end