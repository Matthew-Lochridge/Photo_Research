function unit_sys = get_unit_sys(unit_sys_code)
    switch unit_sys_code
        case 0
            unit_sys = "English";
        case 1
            unit_sys = "SI";
    end
end