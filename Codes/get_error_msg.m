function error_msg = get_error_msg(error_code)
    switch error_code

        case -1
            error_msg = "Light source not constant.";

        case -2
            error_msg = "Light overload – signal too intense.";

        case -3
            error_msg = "Cannot Sync to light source.  Light source frequency below 20 Hz, above 400 Hz, or signal too low to Sync.";

        case -4
            error_msg = "Adaptive mode error.";

        case -8
            error_msg = "Weak light – insufficient signal.";
            
        case -9
            error_msg = "Sync error.";
            
        case -10
            error_msg = "Cannot auto sync to light source.";
            
        case -12
            error_msg = "Adaptive mode time out. Light source not constant.";
            
        case -1000
            error_msg = "Illegal command.";
            
        case -1001
            error_msg = "Too many fields in setup command.";
            
        case -1002
            error_msg = "Invalid primary accesory code.";
            
        case -1003
            error_msg = "Invalid Addon 1 accessory code.";
            
        case -1004
            error_msg = "Invalid Addon 2 accessory code.";
            
        case -1005
            error_msg = "Accessory is not a primary accessory.";
            
        case -1006
            error_msg = "Accessory is not an addon accessory.";
            
        case -1007
            error_msg = "Accessory already selected.";
            
        case -1008
            error_msg = "Invalid aperture index (PR-670 only).";
            
        case -1009
            error_msg = "Invalid units code.\n0 = English\n1 = Metric (SI)";
            
        case -1010
            error_msg = "invalid exposure value.\nPR-655: 3-6000 ms\nPR-670: 6-30,000 ms";
            
        case -1011
            error_msg = "Invalid gain code.\n0 = Normal\n1 = 1X for AC sources\n2 = 10X\n3 = 100X";
            
        case -1012
            error_msg = "Invalid average cycles. Valid values are 1-99.";
            
        case -1015
            error_msg = "Invalid CIE observer. Valid values are 2 or 10.";
            
        case -1017
            error_msg = "Invalid dark measurement mode.\n0 = Disable smart dark\n1 = Enable smart dark";
            
        case -1019
            error_msg = "Invlid sync mode.\n0 = No sync\n1 = Auto sync\n3 = User frequency";
            
        case -1021
            error_msg = "Measurement title too long (> 20 characters).";
            
        case -1022
            error_msg = "Measurement title field empty after sending L command.";
            
        case -1023
            error_msg = "Invalid user sync frequency. Valid values are 20-400 Hz.";
            
        case -1024
            error_msg = "Invalid R command.";
            
        case -1025
            error_msg = "Invalid Addon 3 accessory code.";
            
        case -1026
            error_msg = "Invalid sensitivity mode.\n0 = Standard mode\n1 = Extended mode";
            
        case -1035
            error_msg = "Parameter not applicable to this instrument.";
            
        case -2000
            error_msg = "Requested response code does not exist, or no other D command has been sent previously.";

    end
end