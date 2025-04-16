function [data, error_code] = send_command(camera,data,command,data_code,measurement_id,file_name,input_setting)

    error_code = []; % default output

    if strcmp(command,'Q')
    % Q Command
    % Purpose: Quit (Exit) Remote mode  
    % Syntax: Q 
    % Response: None 

        write(camera,command,'char');
    
    elseif contains('CEFI',command)
    % C Command
    % Purpose: Clears the current instrument error 
    % Syntax: C[CR] 
    % Response: None 

    % E Command
    % Purpose: Full Duplex (Echo) ON / OFF 
    % Syntax: E[CR] 
    % Response: None 

    % F Command
    % Purpose: Measure frequency of light source 
    % Syntax: F[CR] 
    % Response: 0000,ff.ff Hertz (Period = nnnnn milliseconds) If all OK, else NNNN[CR][LF] (NNNN = Error code) 

    % I Command
    % Purpose: Return instrument status / error report 
    % Syntax: I[CR]  
    % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 

        response = split(writeread(camera,command),',');
        error_code = str2double(response{1});
        if strcmp(command,'F')
            data.source_freq = response{2};
        end

    elseif contains('DMR',command) && ~isempty(data_code)
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

        command_string = append(command,num2str(data_code));
        if strcmp(command,'R')
            if ~isempty(measurement_id)
                command_string = append(command_string,',',num2str(measurement_id));
            end
            if ~isempty(file_name)
                command_string = append(command_string,',',file_name);
            end
        end

        switch data_code

            case 0 % status (Write to disk most recent, unsaved, measurement)
                
                if contains('DM',command)
                    error_code = str2double(writeread(camera,command_string));
                end

            case 1 % status, units, Photometric brightness, CIE 1931 x,y
                % Output Format: qqqqq,UUUU,Y.YYYe+ee,x.xxxx,y.yyyy CRLF
                % where: qqqqq = error code
                %        UUUU = unit code
                %        Y.YYY = Photometric brightness (e.g. Luminance or Illuminance etc.)
                %        ee = exponent
                %        x.xxxx = CIE 1931 x 
                %        y.yyyy = CIE 1931 y
                % Output Example:
                %   00000,0,1.865e+01,0.4035,0.4202

                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.unit_sys_code = str2double(response{2});
                data.Y = str2double(response{3});
                data.x = str2double(response{4});
                data.y = str2double(response{5});
    
            case 2 % status, units, CIE 1931 Tristimulus Values
            % Output Format: qqqqq,UUUU,X.XXXe+ee,Y.YYYe+ee,Z.ZZZe+ee CRLF
            % where: qqqqq = error code
            %        UUUU = unit code
            %        X.XXX = CIE 1931 Tristimulus X (Red)
            %        ee = exponent
            %        Y.YYY = CIE 1931 Tristimulus Y (Green)
            %        Z.ZZZ = CIE 1931 Z (Blue)
            % Output Example:
            %   00000,0,6.136e+01,1.865e+01,2.681e+01
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.unit_sys_code = str2double(response{2});
                data.X = str2double(response{3});
                data.Y = str2double(response{4});
                data.Z = str2double(response{5});
    
            case 3 % status, units, Photometric brightness, CIE 1976 u’, v’
            % Output Format: qqqqq,U,Y.YYYe+ee,u’.u’u’u’,v’.v’v’v’ CRLF
            % where: qqqqq = error code
            %        UUUU = unit code
            %        Y.YYY = Photometric brightness (e.g. Luminance or Illuminance etc.)
            %        ee = exponent
            %        u’.u'u'u' = CIE 1976 u’
            %        v’.v'v'v' = CIE 1976 v’
            % Output Example:
            %   00000,0,1.865e+01,0.2231,0.5227
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.unit_sys_code = str2double(response{2});
                data.Y = str2double(response{3});
                data.u_prime = str2double(response{4});
                data.v_prime = str2double(response{5});
    
            case 4 % status, units, Photometric brightness, Correlated Color Temperature, Deviation from Planck's Locus in 1960 u,v units
            % Output Format: qqqqq,U,Y.YYYe+ee,CCCCC,d.dddd CRLF
            % where: qqqqq = error code
            %        UUUU = unit code
            %        Y.YYY = Photometric brightness (e.g. Luminance or Illuminance etc.)
            %        ee = exponent
            %        CCCCC = Correlated Color Temperature in Kelvins
            %        d.dddd = CIE 1960 deviation from Planck’s Black Body Radiator locus
            % Output Example
            %   00000,0,1.865e+01,3757,0.0129
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.unit_sys_code = str2double(response{2});
                data.Y = str2double(response{3});
                data.CCT = str2double(response{4});
                data.locus_deviation = str2double(response{5});
    
            case 5 % status, units, Peak Wavelength, Integrated Power, Integrated Photon, WL, Spectral Data at each WL
            % Output Format: qqqqq,UUUU,w.wwwe+eee,i.iiie-ee,p.pppe+ee CRLF
            % where: qqqqq = error code
            %        UUUU = unit code
            %        w.www = peak wavelength
            %        ee = exponent
            %        i.iii = integrated radiometric value (sum of all spectral data times WL increment)
            %        p.ppp = integrated photon radiometric value
            %        wl,spectral dataCRLF
            %        wl,spectral dataCRLF
            %        wl,spectral dataCRLF
            % Output Example:
            %   00000,0,0.000e+000,1.827e-01,5.147e+01
            %   380,1.627e- 
            %   382,9.910e-07 
            %   384,5.356e-06 
            %   386,5.725e-06 
            %   388,8.989e-06 
            %   390,1.127e-05
    
                data = send_command(camera,data,'D',120,[],[],[]);
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.unit_sys_code = str2double(response{2});
                data.wl_peak = str2double(response{3});
                data.integrated_power = str2double(response{4});
                data.integrated_photon = str2double(response{5});
                data.wl = [];
                data.wl_magnitude = [];
                for index = 1:data.num_wl
                    spectrum = split(readline(camera),',');
                    data.wl(index) = str2double(spectrum(1));
                    data.wl_magnitude(index) = str2double(spectrum(2));
                end
    
            case 6 % status, units, Photometric brightness, CIE 1931 x, y, CIE 1976 u’, v'
            % Output Format: qqqqq,UUUU,Y.YYYe+ee,x.xxxx,y.yyyy,u’.u’u’u’u’,v’.v’v’v’v’ CRLF
            % where: qqqqq = error code
            %        UUUU = unit code
            %        Y.YYY = Photometric brightness (e.g. Luminance or Illuminance etc.)
            %        ee = exponent
            %        x.xxxx = CIE 1931 x
            %        y.yyyy = CIE 1931 y
            %        u’.u'u'u'u' = CIE 1976 u’
            %        v’.v'v'v'v' = CIE 1976 v'
            % Output Example: 
            %   00000,0,2.041e+01,0.4089,0.4151,0.2283,0.5215
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.unit_sys_code = str2double(response{2});
                data.Y = str2double(response{3});
                data.x = str2double(response{4});
                data.y = str2double(response{5});
                data.u_prime = str2double(response{6});
                data.v_prime = str2double(response{7});
    
            case 7 % status, units, Photometric brightness, CIE 1960 x, y
            % Output Format: qqqqq,UUUU,Y.YYYe+ee,u.uuuu,v.vvvv CRLF
            % where: qqqqq = error code
            %        UUUU = unit code
            %        Y.YYY = Photometric brightness (e.g. Luminance or Illuminance etc.)
            %        ee = exponent 
            %        u.uuuu = CIE 1976 u 
            %        v.vvvv = CIE 1976 v
            % Output Example:
            %   00000,0,2.646e+03,0.2081,0.3519
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.unit_sys_code = str2double(response{2});
                data.Y = str2double(response{3});
                data.u = str2double(response{4});
                data.v = str2double(response{5});
    
            case 8 % status, Raw (uncorrected) light per pixel
            % Output Format: qqqqq, CRLF, lllll CRLF, lllll CRLF, lllll CRLF …………………
            % where: qqqqq = error code
            %        lllll = Raw signal (light) data (variable length from 1 to 5 digits) for all detector pixels from 0 to 255.
            % Output Example:
            %   00000, 
            %   3475 
            %   3426 
            %   3477 
            %   3451 
            %   3483 
            %   3459 
    
                data = send_command(camera,data,'D',120,[],[],[]);
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.raw_pixel_light = [];
                for index = 1:data.num_pix % loop over all pixels
                    data.raw_pixel_light(index) = str2double(readline(camera));
                end
            
            case 9 % status, Raw (uncorrected) Dark Current per pixel
            % Output Format: qqqqq, CRLF, ddddd CRLF, ddddd CRLF, ddddd CRLF
            % where: qqqqq = error code
            %        ddddd = Raw signal (dark current) data (variable length from 1 to 5 digits) for all detector pixels from 0 to 255.
            % Output Example:
            %   00000, 
            %   120 
            %   135 
            %   122 
            %   130 
            %   131 
            %   123 
    
                data = send_command(camera,data,'D',120,[],[],[]);
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.raw_pixel_dark = [];
                for index = 1:data.num_pix % loop over all pixels
                    data.raw_pixel_dark(index) = str2double(readline(camera));
                end
    
            case 11 % status, units, Scotopic Brightness
            % Output Format: qqqqq,UUUU,S.SSSe+ee CRLF
            % where: qqqqq = error code
            %        UUUU = unit code
            %        S.SSS = scotopic luminance
            %        ee = exponent
            % Output Example:
            %   00000,0,3.668e+01
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.unit_sys_code = str2double(response{2});
                data.S = str2double(response{3});
    
            case 12 % status, units, Photometric brightness, CIE 1931 x, y, CIE 1960u, v
            % Output Format: qqqqq,UUUU,Y.YYYe+ee,x.xxxx,y.yyyy,u.uuuu,v.vvvv CRLF
            % where: qqqqq = error code
            %        UUUU = unit code
            %        Y.YYY = Photometric brightness (e.g. Luminance or Illuminance etc.) 
            %        ee = exponent
            %        x.xxxx = CIE 1931 x
            %        y.yyyy = CIE 1931 y
            %        u.uuuu = CIE 1960 u
            %        v.vvvv = CIE 1960 v
            % Output Example:
            %   00000,0,2.041e+01,0.4089,0.4151,0.2283,0.3477
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.unit_sys_code = str2double(response{2});
                data.Y = str2double(response{3});
                data.x = str2double(response{4});
                data.y = str2double(response{5});
                data.u = str2double(response{6});
                data.v = str2double(response{7});
    
            case 13 % status, Gain description, exposure time in milliseconds
            % Output Format: qqqqq,Gain description,nnnnnn msec CRLF
            % where: qqqqq = error code
            %        Gain Description = Gain used. Possibilities are: Normal, Fast, 2X Fast and 4X Fast.
            %        nnnnnn = Last exposure time in milliseconds
            % Output Example: 
            %   00000,Fast,16500 msec
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.gain = response{2};
                data.exposure_time = response{3};
    
            case 14 % status, Sync mode description, sync period in milliseconds
            % Output Format: qqqqq,Sync mode description,nnnnnn Hertz CRLF
            % where: qqqqq = error code
            %        Sync mode description = Sync mode in use. Possibilities are: Auto Sync, User Sync, None.
            %        nnnnnn = Sync Frequency in Hertz
            % Output Example:
            %   00000,User Sync,120.00 Hertz
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.sync_mode = response{2};
                data.sync_freq = response{3};
    
            case 110 % status, Instrument Serial Number
            % Output Format: qqqqq,ssssssss CRLF
            % where: qqqqq = error code
            %        ssssssss = Instrument Serial Number
            % Output Example: 
            %   00000,67065106
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.serial_num = response{2};
    
            case 111 % status, Instrument Name
            % Output Format: qqqqq,mmmmmm CRLF
            % where: qqqqq = error code
            %        mmmmmm = Instrument Model
            % Output Example:
            %   00000,PR-655
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.model = response{2};
    
            case 112 % status, Number of Accessories, Number of Apertures
            % Output Format: qqqqq,ac,ap CRLF
            % where: qqqqq = error code
            %        ac = number of calibrated accessories
            %        ap = number of calibrated apertures
            % Output Example:
            % 00000,1,4
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.num_accessories = str2double(response{2});
                data.num_apertures = str2double(response{3});
    
            case 114 % status, Software Version
            % Output Format: qqqqq,vvvvv CRLF
            % where: qqqqq = error code
            %        vvvvv = Software version
            % Output Example:
            % 00000,2.22D
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.software_version = response{2};
    
            case 116 % status, Accessory List
            % Output Format: qqqqq,nn,ss,tt,pp,rr CRLF
            % where: qqqqq = error code
            %        nn = ID number of accessory
            %        ss = Accessory name (variable length)
            %        tt = Accessory type – Possibilities are: Primary or Addon
            %        pp = Photometry Mode – Possibilities are: Luminance, Illuminance, Luminous Intensity, or Luminous Flux
            %        rr = Radiometry Mode – Possibilities are: Radiance Irradiance Radiant Intensity or Radiant Flux
            % Output Example:
            %   00000,0,MS-75,Primary,Luminance,Radiance
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.accessory.id = str2double(response{2});
                data.accessory.name = response{3};
                data.accessory.type = response{4};
                data.photometry_mode = response{5};
                data.radiometry_mode = response{6};
    
            case 117 % status, Aperture List
            % Output Format: qqqqq,nn,ss,bw CRLF
            % where: qqqqq = error code
            %        nn  = ID number of aperture
            %        ss  = Aperture Name
            %        bw = Effective Bandwidth
            % Output Example:
            %   00000,0,1 deg,0.00
            %   00000,1,1/2 deg,0.00
            %   00000,2,1/4 deg,0.00
            %   00000,3,1/8 deg,0.00

                data = send_command(camera,data,'D',112,[],[],[]);
                writeline(camera,command_string);
                data.aperture = {};
                for index = 1:data.num_apertures
                    response = split(readline(camera),',');
                    data.aperture{index} = struct();
                    error_code = str2double(response{1});
                    data.aperture{index}.id = str2double(response{2});
                    data.aperture{index}.name = response{3};
                    data.aperture{index}.bw_eff = str2double(response{4});
                end
    
            case 120 % status, Hardware configuration
            % Output Format: qqqqq,pp,bw,bb,ee,ii,nrp,frp,lrp CRLF
            % where: qqqqq = error code
            %        pp = Number of spectral data points
            %        bw = Bandwidth of instrument
            %        bb = Starting WL
            %        ee = Ending WL
            %        ii = WL Increment
            %        nrp = Number of detector elements pixels
            %        frp = First useable raw pixel number
            %        lrp = Last useable raw pixel number
            % Output Example:
            %   00000,201,0.00,380,780,2,256,7,247
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.num_wl = str2double(response{2});
                data.bw = str2double(response{3});
                data.wl_start = str2double(response{4});
                data.wl_stop = str2double(response{5});
                data.wl_step = str2double(response{6});
                data.num_pix = str2double(response{7});
                data.pix_start = str2double(response{8});
                data.pix_stop = str2double(response{9});
    
            case 401 % status, Number of stored measurements in RAM
            % Output Format: qqqqq CRLF
            % where: qqqqq - Number of stored measurements in RAM
            % Output Example:
            %   6
    
                response = split(writeread(camera,command_string),',');
                data.RAM.num_measurements = str2double(response{1});
    
            case 402 % status, Directory of stored measurements in RAM
            % Output Format: qqqqq,dt,tm CRLF
            % where: qqqqq - ID of measurement
            %        dt = Date
            %        tm = Time
            % Output Example:
            %   1,01-30-2007 13:48:26
            %   2,01-30-2007 13:49:09
            %   3,01-30-2007 13:51:03
    
                data = send_command(camera,data,'D',401,[],[],[]);
                writeline(camera,command_string);
                data.RAM.measurements = {};
                for index = 1:data.RAM.num_measurements
                    data.RAM.measurements{index} = struct();
                    response = split(readlines(camera),',');
                    data.RAM.measurements{index}.id = str2double(response(1));
                    date_time = split(response(2),' ');
                    data.RAM.measurements{index}.date = date_time(1);
                    data.RAM.measurements{index}.time = date_time(2);
                end
    
            case 411 % status, List of files in SD Card and number of stored measurements per file
            % Output Format: filename.ext,qqqqq CRLF
            % where: filename.ext = Filename with extension
            %        qqqq = Number of stored measurements in file
            % Output Example:
            %   MK.mea, 1
            %   TSTSAMP.mea, 2
    
                writeline(camera,command_string);
                data.file = {};
                index = 1;
                response = split(readline(camera),',');
                while ~isempty(response)
                    data.file{index}.name = response{1};
                    data.file{index}.num_measurements = str2double(response{2});
                    response = readline(camera);
                    index = index + 1;
                end
    
            case 412 % filename ,status, Directory of stored measurements in file 'filename' in SD card
            % Syntax: D412, ffffffff.eee 
            % where: ffffffff = filename of stored measurement file (DOS file naming convention)
            %        eee = filename extension
            % Output Format: qqqqq,dt,tm CRLF
            % where: qqqqqq = ID of measurement
            %        dt  = Date
            %        tm = Time
            % Output Example:
                
                response = split(writeread(camera,command_string),',');
                data.file.measurements.id = str2double(response{1});
                data.file.measurements.date = response{2};
                data.file.measurements.time = response{3};
    
            case 502 % status, Current System Timing & Environment Info
    
    
    
            case 503 % status, Stored System Timing & Environment Info
    
    
    
            case 601 % status, Current Setup Report – comma delimited
            % Output Format: qqqqq,<Primary Lens>,<Addon1>,<Addon2>,<Addon3>,<Aperture>,<Units>,<Exposure Mode>,<Exposure Time (see note)>,
            %                <Gain>,<Cycles>,<CIE Observer>,<DarkMode>,<SyncMode>,<CaptureMode>,<SyncPeriod> CRLF 
            % Note: The exposure time reported in 601 and 602 (following) reports 0 if the instrument is set in Adaptive Exposure mode. 
            %       To view the exposure time for the last measurement when the instrument is in Adaptive Exposure mode, send the D13 command.
            % Output Example:
            %   00000,0,-1,-1,-1,0,0,0,0,0,1,2,0,0,0,60.00
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.primary = read_code('Primary',str2double(response{2}));
                data.addon{1} = read_code('Addon',str2double(response{3}));
                data.addon{2} = read_code('Addon',str2double(response{4}));
                data.addon{3} = read_code('Addon',str2double(response{5}));
                data.aperture = read_code('Aperture',str2double(response{6}));
                data.unit_sys = read_code('Unit System',str2double(response{7}));
                data.exposure_mode = read_code('Exposure Mode',str2double(response{8}));
                if str2double(response{9}) > 0
                    data.exposure_time = str2double(response{9});
                else
                    data = send_command(camera,data,'D',13,[],[],[]);
                end
                data.gain = read_code('Gain',str2double(response{10}));
                data.cycles = str2double(response{11});
                data.observer = read_code('CIE Observer',str2double(response{12}));
                data.dark_mode = read_code('Smart Dark Mode',str2double(response{13}));
                data.sync_mode = read_code('Sync Mode',str2double(response{14}));
                data.sensitivity = read_code('Sensitivity',str2double(response{15}));
                data.sync_freq = str2double(response{16});
    
            case 602 % status, Current Setup Report, Verbose
            % Output Format: Current set report with text labels.
            % Dark mode values: for reports [601] and [602]
            %   0 Disable Smart Dark
            %   1 Enable Smart Dark
            % Output Example:
            %   00000,MS-75,None,None,None,1 deg,English,Adaptive,0 msec,Normal,1 cycles,2 deg,No Smart Dark,No Sync,Standard Sensitivity,60.00 Hertz
                
                response = split(writeread(camera,command_string),',');
                error_code = str2double(response{1});
                data.primary = response{2};
                data.addon{1} = response{3};
                data.addon{2} = response{4};
                data.addon{3} = response{5};
                data.aperture = response{6};
                data.unit_sys = response{7};
                data.exposure_mode = response{8};
                data.exposure_time = response{9};
                data.gain = response{10};
                data.cycles = response{11};
                data.observer = response{12};
                data.dark_mode = response{13};
                data.sync_mode = response{14};
                data.sensitivity = response{15};
                data.sync_freq = response{16};
        end

    elseif contains('BL',command) && ~isempty(input_setting)
    % B Command
    % Purpose: Set LCD backlight level  
    % Syntax: Bnn[CR] 
    %   Bnn = Backlight / Brightness level in percentage. 
    %   Range of nn = 0 to 100% 
    % Response: Backlight set to nn % 

    % L Command
    % Purpose: Assign measurement description 
    % Syntax: L<Character String with max length of 20 characters>[CR] 
    % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code)  
    % Note: Entry remains valid for the duration of the current Remote Mode session or until a new L command is issued. 
    % If L[CR] is issued with an empty string, the current description is returned. 

        command_string = append(command,num2str(input_setting));
        error_code = str2double(writeread(camera,command_string));

    elseif strcmp(command,'X') && ~isempty(input_setting)
    % X Command
    % Purpose: Set the display contrast . 
    % Syntax: Xnnn where nnn is the contrast in % - Range 0 to 100% 
    % Response: “Contrast set to nnn %” 
    % See the Setup Command section for complete details 

        command_string = append(command,num2str(input_setting));
        write(camera,command_string,'char');
        error_code = str2double(readline(camera));

    elseif (contains('BL',command) || contains(command,'S')) && ~isempty(input_setting)
    % B Command
    % Purpose: Set LCD backlight level  
    % Syntax: Bnn[CR] 
    %   Bnn = Backlight / Brightness level in percentage. 
    %   Range of nn = 0 to 100% 
    % Response: Backlight set to nn % 

    % L Command
    % Purpose: Assign measurement description 
    % Syntax: L<Character String with max length of 20 characters>[CR] 
    % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code)  
    % Note: Entry remains valid for the duration of the current Remote Mode session or until a new L command is issued. 
    % If L[CR] is issued with an empty string, the current description is returned. 

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

    % Select Exposure Time 
    % Enter the Exposure (Integration) time for the next measurement in milliseconds. 
    % Possible values are 6 – 6,000 (6 sec.) for Standard Mode, and 6 - 30,000 (30 sec.) for Extended Mode. 
    % See the H specifier for more information on setting Standard or Extended Modes.  
    % To set the instrument to Adaptive Exposure, send SE0 (ttttt = 0) 
    % Syntax: SEttttt[CR]  
    % Where: ttttt = exposure time in milliseconds 
    % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    % Note: Standard and Extended modes apply only to PR-670. PR-655 exposure range is 3 to 6,000 ms 

    % Aperture Select (PR-670 only) 
    % Select the aperture to be used for the next measurement.   
    % Syntax: SFa[CR]  
    % Where: a = aperture code 
    % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    % Note: See Data Code 117 for details on aperture codes. 

    % Speed Mode (PR-670 only) 
    % Select the Speed Mode for the next measurement. Choices are Normal, 1X Fast, 2X Fast and 4X Fast. 
    % Syntax: SGg[CR]  
    % Where: g = Gain  
    %        0 = Normal (DEFAULT),  
    %        1 = 1X for AC sources,  
    %        2 = 10X 
    %        3 = 100X 
    % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 

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

    % User Sync Frequency 
    % Enter the frequency (in Hertz) of the source being measured. The range is 20 to 400 Hz.  
    % This command works in unison with the SYNC Mode setting. 
    % See the S specifier for complete details on setting the SYNC Mode. 
    % Syntax: SKfff[CR] 
    % Where: fff = frequency in Hertz. Range is 20 to 400 
    % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 

    % Cycles to Average 
    % Defines the number of measurements (cycles) to average when calculating photometric and colorimetric values. 
    % The average of the spectra are used to calculate other values. The range of cycles to average is 1 to 99. The default is 1. 
    % Syntax: SNaa[CR] 
    % Where: aa = Cycles to Average  (Range 1 to 99) 
    % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 

    % CIE Observer 
    % Photometric and Colorimetric values can be calculated using either CIE 2 or 10 Standard Observer data sets. 
    % Use this specifier to choose the CIE data set for calculations for the next measurement. The default is 2 deg. 
    % Syntax: SOn[CR]  
    % Where: n = CIE Observer  
    %        2 = 2 deg. 
    %        10 = 10 deg. 
    % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    
    % Primary Accessory 
    % A Primary Accessory is one that replaces the standard objective lens (typically the MS-75) 
    % during use and can be used in conjunction with an Add-on Accessory. 
    % Syntax: SPnn[CR]  
    % Where: nn = Accessory Code 
    % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
    % Note: Accessory Codes can be found by running report 116 (command D116). See the Data Codes section for specific details. 

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

    % Photometric Units 
    % Select English or Metric (SI) photometric values to be reported in the applicable Data Codes. 
    % Syntax: SUn[CR]  
    % Where: n = Units type  
    %        0 = English 
    %        1 = Metric (SI) 
    % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 

    % Measure Shutter Control 
    % Controls the actions of the measure shutter. When set to 0 the measure shutter will be closed after each measurement and a dark measurement will be taken. 
    % When Measure shutter control is set to 1, the measure shutter will never close and no dark measurements will be taken. 
    % It is recommended that a measurement be taken with Measure shutter control set to 0 so that a dark measurement can be captured. 
    % Syntax: SZs[CR]  
    % Where: s = Shutter Control 
    %        0 = Close after a measurement 
    %        1 = Never close (always open)  
    % Response: 0000[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 

        command_string = append(command,num2str(input_setting));
        error_code = str2double(writeread(camera,command_string));

    elseif strcmp(command,'Z') && ~isempty(input_setting)
        % Purpose: Enable Reset Command Mode 
        % Syntax: ZEnableReset 
        % Response: 00000,Reset Commands Enabled  
        % Reset Commands: 
        %   ZResetPreferences – Reset all Preferences values to factory default. 
        %   ZResetSetup       – Reset all Setup values to factory default.  
        % NOTE: All Reset Commands will shut down the instrument after they are executed.

        command_string = append(command,input_setting);
        write(camera,command_string,'char');
        if strcmp(input_setting,'EnableReset')
            response = split(readline(camera),',');
            error_code = response{1};
        end
    end
end