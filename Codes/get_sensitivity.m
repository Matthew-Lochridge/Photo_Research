function sensitivity = get_sensitivity(sensitivity_code)
    switch sensitivity_code
        case 0
            sensitivity = "Standard";
        case 1
            sensitivity = "Extended";
    end
end