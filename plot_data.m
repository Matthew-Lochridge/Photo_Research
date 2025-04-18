function [fig,ax] = plot_data(data,specifier)
    figure();
    switch specifier
        case 'Raw light per pixel'
            plot(1:data.num_pix,data.raw_light);
            xlabel('Pixel');
            ylabel('Amplitude');
        case 'Raw dark per pixel'
            plot(1:data.num_pix,data.raw_dark);
            xlabel('Pixel');
            ylabel('Amplitude');
        case 'Spectrum'
            plot(data.wl,data.wl_magnitude);
            xlabel('Wavelength (nm)');
            ylabel('Amplitude');
        case 'CIE tristimulus'

        case 'CIE 1931 x, y'
            plotChromaticity;
            hold on
            plot(data.x,data.y,'*k');
            hold off
        case 'CIE 1960 u, v'

        case "CIE 1976 u', v'"
            plotChromaticity('ColorSpace','uv');
            hold on
            plot(data.u_prime,data.v_prime,'*k');
            hold off
    end
    title(specifier);
    fig = gcf;
    ax = gca;
end