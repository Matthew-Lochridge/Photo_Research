function sync_mode = get_sync_mode(sync_mode_code)
    switch sync_mode_code
        case 0
            sync_mode = 'None';
        case 1
            sync_mode = 'Auto Sync';
        case 2
            sync_mode = 'User Sync';
    end
end