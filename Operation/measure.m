function response = measure(camera,specifier,user_input)

    if ~strcmp(camera.Terminator,"CR")
        configureTerminator(camera,"CR");
    end

    switch specifier

        % Purpose: Measure frequency of light source 
        % Syntax: F[CR] 
        % Response: 0000,ff.ff Hertz (Period = nnnnn milliseconds) If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        case "source_freq"
            command = "F";
    
        % Purpose: Make a Measurement with the PR-6XX 
        % Syntax: M<data code>[CR] 
        % Response: 0000,<data>[CR][LF] If all OK, else NNNN[CR][LF] (NNNN = Error code) 
        % Note: <data> in response code refers to the specific measurement 
        %   data set returned based on the data code sent to the instrument. 
        % Refer to the Data Code section for specific information. 
        case "data_code"
            command = append("M",string(user_input));
    
    end

    response = writeread(camera,command);
end

