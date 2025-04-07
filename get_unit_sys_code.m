function unit_sys_code = get_unit_sys_code(unit_sys)
    switch unit_sys
        case "English"
            unit_sys_code = 0;
        case "SI"
            unit_sys_code = 1;
    end
end