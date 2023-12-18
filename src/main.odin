package game

import "core:strings"
import "core:fmt"
import rl "vendor:raylib" 

main :: proc() {
    using rl

	SetRandomSeed(42)
	
	name := strings.clone_to_cstring(project_name)
	xxx : i32 = i32(SCREEN.x)
	yyy : i32 = i32(SCREEN.y)
	InitWindow(xxx, yyy, name)

    InitAudioDevice()
    // bg_music := LoadMusicStream("../assets/bg_music.wav")
    // bg_music.looping = true


	setup_window()

	setup_game()

	is_running: bool = true
	for is_running && !WindowShouldClose()
    {
        // UpdateMusicStream(bg_music)

        // PlayMusicStream(bg_music)

		{// UPDATE
			// update_engine()
			update_screens()
		}

		{// RENDER
			// render_engine()
			render_screens()
		}
	}

	clear_and_shutdown()

	CloseWindow()
}

setup_window :: proc(){
    using rl

	SetTargetFPS(60)

	icon: Image = LoadImage("../assets/icons/window_icon.png")

	ImageFormat(&icon, PixelFormat.UNCOMPRESSED_R8G8B8A8)

	SetWindowIcon(icon)

	UnloadImage(icon)
}

setup_game :: proc()
{
    load_spritesheet()
    // setup_sprite_sources()

    setup_game_overlord()

    setup_background()

    //init_gameplay()
    //setup_board()
    // setup_buttons()
    // set_btn_pos(&buttons[0], rl.Vector2{ 400, 700})
    // set_btn_pos(&buttons[1], rl.Vector2{ 600, 700})
    // set_btn_pos(&buttons[2], rl.Vector2{ 800, 700})
}

update_screens :: proc()
{
    switch current_screen {
        case .MAIN_MENU:
            update_main_menu()
        case .GAMEPLAY:
            update_gameplay()
        case .GAME_OVER:
    }
}

render_screens :: proc()
{
    rl.BeginDrawing()
    rl.ClearBackground(C_BACKGROUND)

    {// RENDER
        switch current_screen {
            case .MAIN_MENU:
                render_main_menu()
            case .GAMEPLAY:
                render_gameplay()
            case .GAME_OVER:
        }
        // background.render()
        // game_map.render(game_atlas)
        // cursor.render()
    }
    rl.DrawFPS(0, 0)

    rl.EndDrawing()
}

clear_and_shutdown :: proc()
{
	unload_spritesheet()
}
