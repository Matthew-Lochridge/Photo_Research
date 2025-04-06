function unit = get_unit(unit_code,unit_sys_code)
    switch unit_code
    
        case 111 % Luminance
            switch unit_sys_code
                case 0 % English
                    unit = "fL";
                case 1 % Metric
                    unit = "cd/m2";
            end

        case 11 % Radiance
            if unit_sys_code == 1
                unit = "W/sr/m2";
            end

        case 112 % Illuminance
            switch unit_sys_code
                case 0 % English
                    unit = "fc";
                case 1 % Metric
                    unit = "lux";
            end

        case 12 % Irradiance
            if unit_sys_code == 1
                unit = "W/m2";
            end

        case 113 % Luminous Intensity
            if unit_sys_code == 1
                unit = "mcd";
            end

        case 13 % Radiant Intensity
            if unit_sys_code == 1
                unit = "W/sr";
            end

        case 114 % Luminous Flux
            if unit_sys_code == 1
                unit = "lumens";
            end

        case 14 % Radiant Flux
            if unit_sys_code == 1
                unit = "W";
            end

    end
end