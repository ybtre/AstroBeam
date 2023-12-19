package game 

score := 0

current_screen : SCREENS = .MAIN_MENU

is_paused := false
pause_blink_counter := 0

gameplay_time_total : f32 = 0.0
gameplay_time_current := 0.0

SCREENS :: enum {
    MAIN_MENU,
    GAMEPLAY,
    GAME_OVER,
}

setup_game_overlord :: proc(){
    current_screen = .MAIN_MENU
    current_screen = .GAMEPLAY
    init_gameplay()

    is_paused = false
}

reset_game :: proc(){
    is_paused = false
}
