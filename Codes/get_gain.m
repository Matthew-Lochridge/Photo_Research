function gain = get_gain(gain_code)
    switch gain_code
        case 0
            gain = "Normal";
        case 1
            gain = "1X Fast";
        case 2
            gain = "2X Fast";
        case 3
            gain = "4X Fast";
    end
end

