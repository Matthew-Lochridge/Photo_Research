function data = measure(camera,specifier,user_input)

    data = struct();

    switch specifier

        % Purpose: Measure frequency of light source 
        % Syntax: F[CR] 
        % Response: 0000,ff.ff Hertz (Period = nnnnn milliseconds) If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        case 'source_freq'
            line = split(writeread(camera,'F'),',');
            data.error_code = str2num(line{1});
            data.source_freq = line{2};
    
        % Purpose: Make a Measurement with the PR-6XX 
        % Syntax: M<data code>[CR] 
        % Response: 0000,<data>[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        % Note: <data> in response code refers to the specific measurement 
        %   data set returned based on the data code sent to the instrument. 
        % Refer to the Data Code section for specific information. 
        case 'data_code'

            switch user_input

                case 5
                    data = parse_data(data,120,measure(camera,'data_code',120));
                    data = parse_data(data,5,download(camera,data,5));
                    data.wl = [];
                    data.wl_magnitude = [];
                    for n = 1:data.num_points
                        spectrum = split(readline(camera),',');
                        data.wl(n) = str2num(spectrum(1));
                        data.wl_magnitude(n) = str2num(spectrum(2));
                    end
    
                case 8
                    data.error_code = str2num(writeread(camera,8));
                    data.raw_pixel_light = [];
                    for n = 1:256 % loop over all pixels
                        data.raw_pixel_light(n) = str2num(readline(camera));
                    end
    
                case 9
                    data.error_code = str2num(writeread(camera,9));
                    data.raw_pixel_dark = [];
                    for n = 1:256 % loop over all pixels
                        data.raw_pixel_dark(n) = str2num(readline(camera));
                    end
    
                case 117
                    data = parse_data(data,112,measure(camera,'data_code',112));
                    data.aperture = {};
                    for n = 1:data.num_apertures
                        data.aperture{n} = struct();
                        aperture = split(readline(camera),',');
                        data.error_code = str2num(aperture{1});
                        data.aperture{n}.id = str2num(aperture{2});
                        data.aperture{n}.name = aperture{3};
                        data.aperture{n}.bw_eff = str2num(aperture{4});
                    end
    
                case 402
                    data = parse_data(data,401,measure(camera,'data_code',401));
                    data.measurement = {};
                    for n = 1:data.num_measurements
                        data.measurement{n} = struct();
                        measurement = split(download(camera,data,402),',');
                        data.measurement{n}.id = str2num(measurement(1));
                        measurement = split(measurement(2),' ');
                        data.measurement{n}.date = measurement(1);
                        data.measurement{n}.time = measurement(2);
                    end
    
                otherwise
                    command = append('M',num2str(user_input));
                    data = parse_data(data,user_input,writeread(camera,command));
            end
    end
end