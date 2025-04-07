function dark_mode = get_dark_mode(dark_mode_code)
    switch dark_mode_code
        case 0
            dark_mode = 'Disabled';
        case 1
            dark_mode = 'Enabled';
    end
end