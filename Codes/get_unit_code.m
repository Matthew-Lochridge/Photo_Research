function [unit_code, unit_sys_code] = get_unit_code(unit)
    switch unit

        case "fL" % Luminance (English)
            unit_code = 111;
            unit_sys_code = 0;
    
        case "cd/m2" % Luminance (Metric)
            unit_code = 111;
            unit_sys_code = 1;

        case "W/sr/m2" % Radiance
            unit_code = 11;
            unit_sys_code = 1;

        case "fc" % Illuminance
            unit_code = 112;
            unit_sys_code = 0;

        case "lux" % Illuminance
            unit_code = 112;
            unit_sys_code = 1;

        case "W/m2" % Irradiance
            unit_code = 12;
            unit_sys_code = 1;

        case "mcd" % Luminous Intensity
            unit_code = 113;
            unit_sys_code = 1;

        case "W/sr" % Radiant Intensity
            unit_code = 13;
            unit_sys_code = 1;

        case "lumens" % Luminous Flux
            unit_code = 114;
            unit_sys_code = 1;

        case "W" % Radiant Flux
            unit_code = 14;
            unit_sys_code = 1;

    end
end