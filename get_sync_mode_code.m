function sync_mode_code = get_sync_mode_code(sync_mode)
    switch sync_mode
        case "None"
            sync_mode_code = 0;
        case "Auto Sync"
            sync_mode_code = 1;
        case "User Sync"
            sync_mode_code = 2;
    end
end