function aperture = get_aperture(aperture_code)
    switch aperture_code
        case 0
            aperture = "1 deg";
        case 1
            aperture = "1/2 deg";
        case 2
            aperture = "1/4 deg";
        case 3
            aperture = "1/8 deg";
    end
end