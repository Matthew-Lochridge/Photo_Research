function sensitivity_code = get_sensitivity_code(sensitivity)
    switch sensitivity
        case "Standard"
            sensitivity_code = 0;
        case "Extended"
            sensitivity_code = 1;
    end
end