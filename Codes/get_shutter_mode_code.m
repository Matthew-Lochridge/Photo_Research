function shutter_mode_code = get_shutter_mode_code(shutter_mode)
    switch shutter_mode
        case "Close after measurement"
            shutter_mode_code = 0;
        case "Always open"
            shutter_mode_code = 1;
    end
end