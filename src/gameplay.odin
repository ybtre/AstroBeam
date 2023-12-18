package game 

import "core:fmt"
import "core:strings"
import "core:math"
import rl "vendor:raylib"


entity_pool     : [512]Entity
entity_count    : int           = 2

cam             : rl.Camera2D
cam_start_off   : rl.Vector2

player          : Player_Entity

init_gameplay :: proc() {
    using rl

    cam.target = Vector2{ SCREEN.x / 2, SCREEN.y / 2 }
    cam.offset = Vector2{ SCREEN.x / 2, SCREEN.y / 2 } 
    cam_start_off = cam.offset
    cam.rotation = 0
    cam.zoom = 1

    init_player()
}

init_player :: proc() 
{
    using rl

    player.is_moving = false
    player.speed = 2
    player.velocity = 0

    e : Entity
    e.active = true
    e.type = .ENT_PLAYER
    e.id = 0
    e.rec = Rectangle{ SCREEN.x / 2, SCREEN.y / 2, f32(16 * PLAYER_SCALE), f32(16 * PLAYER_SCALE) }
    e.rot = 0

    s : Sprite
    s.src = Rectangle{ 0, 0, 16, 16 }
    s.color = WHITE
    s.center = Vector2{ 0, 0 }

    e.spr = s
    player.entity = e
}

update_gameplay :: proc() {
    using rl

    if rl.IsKeyPressed(rl.KeyboardKey.P){
        is_paused = !is_paused
    }

    if !is_paused
    {   
        update_check_mouse_collision()
        //update_board()
    }
    else 
    {
        pause_blink_counter += 1
    }
}

render_gameplay :: proc() {
    using rl

    BeginMode2D(cam)
	{
        render_background()
        
        { //tiles
            {//grid
                debug_grid :: true
                if debug_grid
                {
                    for x := 0; x < 11; x += 1 {
                        for y := 0; y < 11; y += 1
                        {
                            DrawRectangleLinesEx(Rectangle{f32((x * 16 * SCALE) + 10), f32((y * 16 * SCALE) + 10), 16 * f32(SCALE), 16 * f32(SCALE)}, 1, C_GRID) 
                        }
                    }
                }
            }

            {// entities
                render_ent_of_type(.ENT_PLAYER, false) 
            }
        }
    }
    EndMode2D()

    if is_paused && ((pause_blink_counter / 30) % 2 == 0)
    {
        DrawText("GAME PAUSED", i32(SCREEN.x / 2 - 290), i32(SCREEN.y / 2 - 50), 80, rl.RED)
    } 

    {// UI
    }
}

render_ent_of_type :: proc(TYPE : Entity_Type, DEBUG : bool) 
{
    using rl
    using fmt

    e : Entity

    for i := 0; i < entity_count; i+= 1
    {
        e = entity_pool[i]
        
        if e.type == TYPE
        {

            if e.active
            {
              
            }
        }
    }

    if TYPE == .ENT_PLAYER
    {
        DrawTexturePro(TEX_SPRITESHEET, player.entity.spr.src, player.entity.rec, player.entity.spr.center, player.entity.rot, player.entity.spr.color)
    }
}

shake_screen :: proc(CAM : ^rl.Camera2D, INTENSITY : f32)
{
    using rl
    
    shaking := false

    if shaking 
    {
		cam.offset = Vector2{ math.sin_f32(f32(GetTime() * 90)) * INTENSITY, math.sin_f32(f32(GetTime() * 180)) * INTENSITY }
		cam.offset.x += cam_start_off.x
		cam.offset.y += cam_start_off.y
	}
	else {
		cam.offset = cam_start_off
	}
}
