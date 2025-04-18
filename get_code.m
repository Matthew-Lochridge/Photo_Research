function code = get_code(field,user_input)
    code = []; % default output
    switch field
        case 'Primary'
            switch user_input
                case 'MS-75'
                    code = 0;
            end
        case 'Addon'
            switch user_input
                case 'None'
                    code = -1;
            end
        case 'Aperture'
            switch user_input
                case '1 deg'
                    code = 0;
                case '1/2 deg'
                    code = 1;
                case '1/4 deg'
                    code = 2;
                case '1/8 deg'
                    code = 3;
            end
        case 'Smart Dark Mode'
            switch user_input
                case 'Disabled'
                    code = 0;
                case 'Enabled'
                    code = 1;
            end
        case 'Gain'
            switch user_input
                case 'Normal'
                    code = 0;
                case 'Fast'
                    code = 1;
                case '2X Fast'
                    code = 2;
                case '4X Fast'
                    code = 3;
            end
        case 'Sensitivity'
            switch user_input
                case 'Standard'
                    code = 0;
                case 'Extended'
                    code = 1;
            end
        case 'Exposure Mode'
            switch user_input
                case 'Adaptive'
                    code = 0;
            end
        case 'Shutter Mode'
            switch user_input
                case 'Close after measurement'
                    code = 0;
                case 'Always open'
                    code = 1;
            end
        case 'Sync Mode'
            switch user_input
                case 'No Sync'
                    code = 0;
                case 'Auto Sync'
                    code = 1;
                case 'User Frequency'
                    code = 2;
            end
        case 'CIE Observer'
            switch user_input
                case '2 deg'
                    code = 2;
                case '10 deg'
                    code = 10;
            end
        case 'Unit System'
            switch user_input
                case 'English'
                    code = 0;
                case 'Metric'
                    code = 1;
            end
        case 'Unit'
            switch user_input
                case 'fL' % Luminance (English)
                    code = 111;
                case 'cd/m2' % Luminance (Metric)
                    code = 111;
                case 'W/sr/m2' % Radiance
                    code = 11;
                case 'fc' % Illuminance (English)
                    code = 112;
                case 'lux' % Illuminance (Metric)
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
        case 'Data'
            switch user_input
                case 'Raw light per pixel'
                    code = 8;
                case 'Raw dark per pixel'
                    code = 9;
                case 'Spectrum'
                    code = 5;
                case 'CIE 1931 tristimulus'

                case 'CIE 1931 x, y'
                    code = 1;
                case 'CIE 1960 u, v'

                case "CIE 1976 u', v'"
                    code = 3;
            end
    end
end