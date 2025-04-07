function shutter_mode = get_shutter_mode(shutter_mode_code)
    switch shutter_mode_code
        case 0
            shutter_mode = "Close after measurement";
        case 1
            shutter_mode = "Always open";
    end
end