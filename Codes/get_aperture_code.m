function aperture_code = get_aperture_code(aperture_name)
    switch aperture_name
        case '1 deg'
            aperture_code = 0;
        case '1/2 deg'
            aperture_code = 1;
        case '1/4 deg'
            aperture_code = 2;
        case '1/8 deg'
            aperture_code = 3;
    end
end