package game 

import "core:fmt"
import "core:strings"
import "core:math"
import rl "vendor:raylib"


entity_pool   : [512]Entity
entity_count  : int           = 2

cam           : rl.Camera2D
cam_start_off : rl.Vector2

small_asteroid : Asteroid_Entity
large_asteroid :Asteroid_Entity

init_gameplay :: proc() {
    using rl

    cam.target = Vector2{ SCREEN.x / 2, SCREEN.y / 2 }
    cam.offset = Vector2{ SCREEN.x / 2, SCREEN.y / 2 } 
    cam_start_off = cam.offset
    cam.rotation = 0
    cam.zoom = 1

    init_player()

    asteroids[asteroids_count] = init_asteroid(Vector2{150, 200}, .ENT_ASTEROID_S)
    asteroids_count += 1
    asteroids[asteroids_count] = init_asteroid(Vector2{500, 600}, .ENT_ASTEROID_M)
    asteroids_count += 1
    asteroids[asteroids_count] = init_asteroid(Vector2{500, 200}, .ENT_ASTEROID_L)
    asteroids_count += 1
}


update_gameplay :: proc() {
    using rl

    if IsKeyPressed(KeyboardKey.P){
        is_paused = !is_paused
    }

    if !is_paused
    {   
        update_player()

        update_collisions()
    
        update_asteroids()
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
               render_grid()
            }
            {// entities
                render_ent_of_type(.ENT_PLAYER, false) 
                render_ent_of_type(.ENT_ASTEROID_S, false) 
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

    switch TYPE
    {
        case .ENT_PLAYER:
        {
            render_player()
        }
        case .ENT_ASTEROID_L:
        case .ENT_ASTEROID_M:
        case .ENT_ASTEROID_S:
        {
            render_asteroids()
        }
    }
}

render_grid :: proc()
{
    using rl 

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
