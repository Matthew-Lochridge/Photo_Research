function gain_code = get_gain_code(gain)
    switch gain
        case 'Normal'
            gain_code = 0;
        case '1X Fast'
            gain_code = 1;
        case '2X Fast'
            gain_code = 2;
        case '4X Fast'
            gain_code = 3;
    end
end

