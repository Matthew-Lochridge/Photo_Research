function data_struct = parse_data(data_struct,data_code,data_string)

    data_cell = split(data_string,',');

    switch data_code
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
            
            data_struct.error_code = data_cell{1};
            data_struct.unit_code = data_cell{2};
            data_struct.Y = data_cell{3};
            data_struct.x = data_cell{4};
            data_struct.y = data_cell{5};

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
            
            data_struct.error_code = data_cell{1};
            data_struct.unit_code = data_cell{2};
            data_struct.X = data_cell{3};
            data_struct.Y = data_cell{4};
            data_struct.Z = data_cell{5};

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
            
            data_struct.error_code = data_cell{1};
            data_struct.unit_code = data_cell{2};
            data_struct.Y = data_cell{3};
            data_struct.u_prime = data_cell{4};
            data_struct.v_prime = data_cell{5};

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
            
            data_struct.error_code = data_cell{1};
            data_struct.unit_code = data_cell{2};
            data_struct.Y = data_cell{3};
            data_struct.CCT = data_cell{4};
            data_struct.locus_dev = data_cell{5};

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
            
            data_struct.error_code = data_cell{1};
            data_struct.unit_code = data_cell{2};
            data_struct.Y = data_cell{3};
            data_struct.x = data_cell{4};
            data_struct.y = data_cell{5};
            data_struct.u_prime = data_cell{6};
            data_struct.v_prime = data_cell{7};

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
            
            data_struct.error_code = data_cell{1};
            data_struct.unit_code = data_cell{2};
            data_struct.Y = data_cell{3};
            data_struct.u = data_cell{4};
            data_struct.v = data_cell{5};

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



        case 11 % status, units, Scotopic Brightness
        % Output Format: qqqqq,UUUU,S.SSSe+ee CRLF
        % where: qqqqq = error code
        %        UUUU = unit code
        %        S.SSS = scotopic luminance
        %        ee = exponent
        % Output Example:
        %   00000,0,3.668e+01
            
            data_struct.error_code = data_cell{1};
            data_struct.unit_code = data_cell{2};
            data_struct.S = data_cell{3};

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
            
            data_struct.error_code = data_cell{1};
            data_struct.unit_code = data_cell{2};
            data_struct.Y = data_cell{3};
            data_struct.x = data_cell{4};
            data_struct.y = data_cell{5};
            data_struct.u = data_cell{6};
            data_struct.v = data_cell{7};

        case 13 % status, Gain description, exposure time in milliseconds
        % Output Format: qqqqq,Gain description,nnnnnn msec CRLF
        % where: qqqqq = error code
        %        Gain Description = Gain used. Possibilities are: Normal, Fast, 2X Fast and 4X Fast.
        %        nnnnnn = Last exposure time in milliseconds
        % Output Example: 
        %   00000,Fast,16500 msec
            
            data_struct.error_code = data_cell{1};
            data_struct.gain = data_cell{2};
            data_struct.exposure_time = data_cell{3};

        case 14 % status, Sync mode description, sync period in milliseconds
        % Output Format: qqqqq,Sync mode description,nnnnnn Hertz CRLF
        % where: qqqqq = error code
        %        Sync mode description = Sync mode in use. Possibilities are: Auto Sync, User Sync, None.
        %        nnnnnn = Sync Frequency in Hertz
        % Output Example:
        %   00000,User Sync,120.00 Hertz
            
            data_struct.error_code = data_cell{1};
            data_struct.sync_mode = data_cell{2};
            data_struct.sync_freq = data_cell{3};

        case 110 % status, Instrument Serial Number
        % Output Format: qqqqq,ssssssss CRLF
        % where: qqqqq = error code
        %        ssssssss = Instrument Serial Number
        % Output Example: 
        %   00000,67065106
            
            data_struct.error_code = data_cell{1};
            data_struct.serial_num = data_cell{2};

        case 111 % status, Instrument Name
        % Output Format: qqqqq,mmmmmm CRLF
        % where: qqqqq = error code
        %        mmmmmm = Instrument Model
        % Output Example:
        %   00000,PR-655
            
            data_struct.error_code = data_cell{1};
            data_struct.model = data_cell{2};

        case 112 % status, Number of Accessories, Number of Apertures
        % Output Format: qqqqq,ac,ap CRLF
        % where: qqqqq = error code
        %        ac = number of calibrated accessories
        %        ap = number of calibrated apertures
        % Output Example:
        % 00000,1,4
            
            data_struct.error_code = data_cell{1};
            data_struct.num_accessories = data_cell{2};
            data_struct.num_apertures = data_cell{3};

        case 114 % status, Software Version
        % Output Format: qqqqq,vvvvv CRLF
        % where: qqqqq = error code
        %        vvvvv = Software version
        % Output Example:
        % 00000,2.22D
            
            data_struct.error_code = data_cell{1};
            data_struct.software_version = data_cell{2};

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
            
            data_struct.error_code = data_cell{1};
            data_struct.accessory_id = data_cell{2};
            data_struct.accessory_name = data_cell{3};
            data_struct.accessory_type = data_cell{4};
            data_struct.photometry_mode = data_cell{5};
            data_struct.radiometry_mode = data_cell{6};

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

            data_struct.error_code = data_cell{1};
            data_struct.aperture_id = data_cell{2};
            data_struct.aperture_name = data_cell{3};
            data_struct.effective_bw = data_cell{4};

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
            
            data_struct.error_code = data_cell{1};
            data_struct.num_points = data_cell{2};
            data_struct.bandwidth = data_cell{3};
            data_struct.wl_start = data_cell{4};
            data_struct.wl_stop = data_cell{5};
            data_struct.wl_step = data_cell{6};
            data_struct.num_pixels = data_cell{7};
            data_struct.pix_start = data_cell{8};
            data_struct.pix_stop = data_cell{9};

        case 401 % status, Number of stored measurements in RAM
        % Output Format: qqqqq CRLF
        % where: qqqqq - Number of stored measurements in RAM
        % Output Example:
        %   6

            data_struct.num_stored_measurements = data_cell{1};

        case 402 % status, Directory of stored measurements in RAM
        % Output Format: qqqqq,dt,tm CRLF
        % where: qqqqq - ID of measurement
        %        dt = Date
        %        tm = Time
        % Output Example:
        %   1,01-30-2007 13:48:26
        %   2,01-30-2007 13:49:09
        %   3,01-30-2007 13:51:03



        case 411 % status, List of files in SD Card and number of stored measurements per file
        % Output Format: filename.ext,qqqqq CRLF
        % where: filename.ext = Filename with extension
        %        qqqq = Number of stored measurements in file
        % Output Example:
        %   MK.mea, 1
        %   TSTSAMP.mea, 2



        case 412 % filename ,status, Directory of stored measurements in file 'filename' in SD card
        % Syntax: D412, ffffffff.eee 
        % where: ffffffff = filename of stored measurement file (DOS file naming convention)
        %        eee = filename extension
        % Output Format: qqqqq,dt,tm CRLF
        % where: qqqqqq = ID of measurement
        %        dt  = Date
        %        tm = Time
        % Output Example:
            
            data_struct.measurement_id = data_cell{1};
            data_struct.measurement_date = data_cell{2};
            data_struct.measurement_time = data_cell{3};

        case 502 % status, Current System Timing & Environment Info



        case 503 % status, Stored System Timing & Environment Info



        case 601 % status, Current Setup Report – comma delimited
        % Output Format: qqqqq,<Primary Lens>,<Addon1>,<Addon2>,<Addon3>,<Aperture>,<Units>,<Exposure Mode>,<Exposure Time (see note)>,
        %                <Gain>,<Cycles>,<CIE Observer>,<DarkMode>,<SyncMode>,<CaptureMode>,<SyncPeriod> CRLF 
        % Note: The exposure time reported in 601 and 602 (following) reports 0 if the instrument is set in Adaptive Exposure mode. 
        %       To view the exposure time for the last measurement when the instrument is in Adaptive Exposure mode, send the D13 command.
        % Output Example:
        %   00000,0,-1,-1,-1,0,0,0,0,0,1,2,0,0,0,60.00
            
            data_struct.error_code = data_cell{1};
            data_struct.primary_lens_code = data_cell{2};
            data_struct.addon_1_code = data_cell{3};
            data_struct.addon_2_code = data_cell{4};
            data_struct.addon_3_code = data_cell{5};
            data_struct.aperture_code = data_cell{6};
            data_struct.unit_sys_code = data_cell{7};
            data_struct.exposure_mode_code = data_cell{8};
            data_struct.exposure_time = data_cell{9};
            data_struct.gain_code = data_cell{10};
            data_struct.cycles_num = data_cell{11};
            data_struct.observer_code = data_cell{12};
            data_struct.dark_mode_code = data_cell{13};
            data_struct.sync_mode_code = data_cell{14};
            data_struct.capture_mode_code = data_cell{15};
            data_struct.sync_freq_num = data_cell{16};

        case 602 % status, Current Setup Report, Verbose
        % Output Format: Current set report with text labels.
        % Dark mode values: for reports [601] and [602]
        %   0 Disable Smart Dark
        %   1 Enable Smart Dark
        % Output Example:
        %   00000,MS-75,None,None,None,1 deg,English,Adaptive,0 msec,Normal,1 cycles,2 deg,No Smart Dark,No Sync,Standard Sensitivity,60.00 Hertz
            
            data_struct.error_code = data_cell{1};
            data_struct.primary_lens = data_cell{2};
            data_struct.addon_1 = data_cell{3};
            data_struct.addon_2 = data_cell{4};
            data_struct.addon_3 = data_cell{5};
            data_struct.aperture = data_cell{6};
            data_struct.unit_sys = data_cell{7};
            data_struct.exposure_mode = data_cell{8};
            data_struct.exposure_time = data_cell{9};
            data_struct.gain = data_cell{10};
            data_struct.cycles = data_cell{11};
            data_struct.observer = data_cell{12};
            data_struct.dark_mode = data_cell{13};
            data_struct.sync_mode = data_cell{14};
            data_struct.capture_mode = data_cell{15};
            data_struct.sync_freq = data_cell{16};

    end
end