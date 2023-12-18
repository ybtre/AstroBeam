package game


import rl "vendor:raylib"
import "core:fmt"

medium := rl.Rectangle{f32((SCREEN.x /2 - 40)), f32((SCREEN.y /2 - 30)), 100, 40}

update_main_menu :: proc() {
    using rl
        // 0 - SMALL 1 - MEDIUM 2 - LARGE

    if CheckCollisionRecs(medium, rl.Rectangle{f32(GetMouseX()), f32(GetMouseY()), 2, 2})
    {
        if IsMouseButtonPressed(MouseButton.LEFT)
        {
            init_gameplay()
            current_screen = .GAMEPLAY
        }
    }
  
}

render_main_menu :: proc(){
    using rl

    render_background()

    DrawText("Astro Beam", i32(SCREEN.x / 2 - 150), i32(SCREEN.y / 2 - 250), 60, C_TEXT)
    // DrawText("PRESS SPACE TO PLAY", i32(SCREEN.x / 2 - 250), i32(SCREEN.y / 2), 40, C_TEXT)

    DrawText(TextFormat("START"), i32(medium.x + 10), i32(medium.y + 10), 20, RED)
    DrawRectangleLinesEx(medium, 5, DARKGRAY) 

    src := Rectangle{48, 96, 80, 48}
    dest := Rectangle{SCREEN.x/2 - 150, SCREEN.y /2 + 50, src.width * 4, src.height * 4}
}
