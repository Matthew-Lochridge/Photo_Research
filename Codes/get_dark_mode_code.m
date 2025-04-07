function dark_mode_code = get_dark_mode_code(dark_mode)
    switch dark_mode
        case "Disabled"
            dark_mode_code = 0;
        case "Enabled"
            dark_mode_code = 1;
    end
end