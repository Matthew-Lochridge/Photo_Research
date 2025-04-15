function output = read_code(field,code)
    output = ''; % default output
    switch field

        case 'Accessory'

        case 'Addon'

        case 'Aperture'
            switch code
                case 0
                    output = '1 deg';
                case 1
                    output = '1/2 deg';
                case 2
                    output = '1/4 deg';
                case 3
                    output = '1/8 deg';
            end

        case 'Smart Dark Mode'
            switch code
                case 0
                    output = 'Disabled';
                case 1
                    output = 'Enabled';
            end

        case 'Gain'
            switch code
                case 0
                    output = 'Normal';
                case 1
                    output = '1X Fast';
                case 2
                    output = '2X Fast';
                case 3
                    output = '4X Fast';
            end

        case 'Sensitivity'
            switch code
                case 0
                    output = 'Standard';
                case 1
                    output = 'Extended';
            end

        case 'Shutter Mode'
            switch code
                case 0
                    output = 'Close after measurement';
                case 1
                    output = 'Always open';
            end

        case 'Sync Mode'
            switch code
                case 0
                    output = 'No Sync';
                case 1
                    output = 'Auto Sync';
                case 2
                    output = 'User Frequency';
            end

        case 'CIE Observer'
            switch code
                case 2
                    output = '2 deg';
                case 10
                    output = '10 deg';
            end

        case 'Unit System'
            switch code
                case 0
                    output = 'English';
                case 1
                    output = 'Metric';
            end

        case 'Unit'
            switch code

            end

        case 'Error'
            switch code
                case 0
                    output = 'No error.';
        
                case -1
                    output = 'Light source not constant.';
        
                case -2
                    output = 'Light overload – signal too intense.';
        
                case -3
                    output = 'Cannot Sync to light source.  Light source frequency below 20 Hz, above 400 Hz, or signal too low to Sync.';
        
                case -4
                    output = 'Adaptive mode error.';
        
                case -8
                    output = 'Weak light – insufficient signal.';
                    
                case -9
                    output = 'Sync error.';
                    
                case -10
                    output = 'Cannot auto sync to light source.';
                    
                case -12
                    output = 'Adaptive mode time out. Light source not constant.';
                    
                case -1000
                    output = 'Illegal command.';
                    
                case -1001
                    output = 'Too many fields in setup command.';
                    
                case -1002
                    output = 'Invalid primary accesory code.';
                    
                case -1003
                    output = 'Invalid Addon 1 accessory code.';
                    
                case -1004
                    output = 'Invalid Addon 2 accessory code.';
                    
                case -1005
                    output = 'Accessory is not a primary accessory.';
                    
                case -1006
                    output = 'Accessory is not an addon accessory.';
                    
                case -1007
                    output = 'Accessory already selected.';
                    
                case -1008
                    output = 'Invalid aperture index (PR-670 only).';
                    
                case -1009
                    output = 'Invalid units code.\n0 = English\n1 = Metric (SI)';
                    
                case -1010
                    output = 'invalid exposure value.\nPR-655: 3-6000 ms\nPR-670: 6-30,000 ms';
                    
                case -1011
                    output = 'Invalid gain code.\n0 = Normal\n1 = 1X for AC sources\n2 = 10X\n3 = 100X';
                    
                case -1012
                    output = 'Invalid average cycles. Valid values are 1-99.';
                    
                case -1015
                    output = 'Invalid CIE observer. Valid values are 2 or 10.';
                    
                case -1017
                    output = 'Invalid dark measurement mode.\n0 = Disable smart dark\n1 = Enable smart dark';
                    
                case -1019
                    output = 'Invlid sync mode.\n0 = No sync\n1 = Auto sync\n3 = User frequency';
                    
                case -1021
                    output = 'Measurement title too long (> 20 characters).';
                    
                case -1022
                    output = 'Measurement title field empty after sending L command.';
                    
                case -1023
                    output = 'Invalid user sync frequency. Valid values are 20-400 Hz.';
                    
                case -1024
                    output = 'Invalid R command.';
                    
                case -1025
                    output = 'Invalid Addon 3 accessory code.';
                    
                case -1026
                    output = 'Invalid sensitivity mode.\n0 = Standard mode\n1 = Extended mode';
                    
                case -1035
                    output = 'Parameter not applicable to this instrument.';
                    
                case -2000
                    output = 'Requested response code does not exist, or no other D command has been sent previously.';
            end



    end
end