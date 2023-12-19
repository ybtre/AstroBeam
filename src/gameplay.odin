package game 

import "core:fmt"
import "core:strings"
import "core:math"
import rl "vendor:raylib"


entity_pool     : [512]Entity
entity_count    : int           = 2

cam             : rl.Camera2D
cam_start_off   : rl.Vector2

test_point      : rl.Vector2 

init_gameplay :: proc() {
    using rl

    cam.target = Vector2{ SCREEN.x / 2, SCREEN.y / 2 }
    cam.offset = Vector2{ SCREEN.x / 2, SCREEN.y / 2 } 
    cam_start_off = cam.offset
    cam.rotation = 0
    cam.zoom = 1

    test_point = Vector2{ 20, 20 }

    init_player()

    init_asteroid()
}

init_player :: proc() 
{
    using rl

    player.is_moving = false
    player.speed = 2
    player.velocity = 0
    player.rot_speed = 4

    e : Entity
    e.active = true
    e.type = .ENT_PLAYER
    e.id = 0
    e.rec = Rectangle{ SCREEN.x / 2, SCREEN.y / 2, f32(16 * PLAYER_SCALE), f32(16 * PLAYER_SCALE) }
    e.rot = 0

    s : Sprite
    s.src = Rectangle{ 0, 0, 16, 16 }
    s.color = WHITE
    s.center = Vector2{ f32(8 * PLAYER_SCALE), f32(8 * PLAYER_SCALE) }

    e.spr = s
    player.entity = e

    player_beam.active = true
    player_beam.rec = Rectangle{e.rec.x - e.rec.width/3, e.rec.y - 100, e.rec.width/1.5, e.rec.height/1.5}
    player_beam.origin = Vector2{player.entity.rec.x - 330, player.entity.rec.y - 230}
    player_beam.rot = e.rot
    player_beam.color = PURPLE
}

init_asteroid :: proc()
{
    using rl

    asteroid.is_moving = false
    asteroid.speed = 2
    asteroid.velocity = 0
    asteroid.rot_speed = 4

    e : Entity
    e.active = true
    e.type = .ENT_ASTEROID
    e.id = 1
    e.rec = Rectangle{ 150, 200, f32(8 * SCALE), f32(8 * SCALE) }
    e.rot = 0

    s : Sprite
    s.src = Rectangle{ 0, 32, 8, 8 }
    s.color = WHITE
    s.center = Vector2{ f32(4 * SCALE), f32(4 * SCALE) }

    e.spr = s
    asteroid.entity = e
}

update_gameplay :: proc() {
    using rl

    if rl.IsKeyPressed(rl.KeyboardKey.P){
        is_paused = !is_paused
    }


    update_player()

    update_collisions()

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

update_player :: proc() 
{
    using rl

    player.velocity = 0

    player.velocity = player.speed

    if IsKeyDown(KeyboardKey.A) {
        player.entity.rot -= player.rot_speed
    }
    if IsKeyDown(KeyboardKey.D) {
        player.entity.rot += player.rot_speed
    }

    player_beam.rec = player.entity.rec
    player_beam.rec.width /= 1.5
    player_beam.rec.height /= 1.2

    //https://stackoverflow.com/questions/1695090/easy-trig-move-an-object-in-a-position
    player.entity.rec.x += math.sin_f32(player.entity.rot * DEG2RAD) * player.velocity
    player.entity.rec.y -= math.cos_f32(player.entity.rot * DEG2RAD) * player.velocity

    player_beam.rot = player.entity.rot
}

update_collisions :: proc() 
{
    using fmt
    using rl

    if CheckCollisionRecs(player_beam.rec, asteroid.entity.rec)
    {
        //shake_screen(&cam, 10)
        println("collision")
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
                render_ent_of_type(.ENT_ASTEROID, false) 
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

    switch TYPE
    {
        case .ENT_PLAYER:
        {
            render_player()
        }
        case .ENT_ASTEROID:
        {
            render_asteroid()
        }
    }
}

render_player :: proc() 
{
    using rl

    DrawTexturePro(TEX_SPRITESHEET, player.entity.spr.src, player.entity.rec, player.entity.spr.center, player.entity.rot, player.entity.spr.color)
    DrawRectanglePro(player_beam.rec, player_beam.origin, player_beam.rot, player_beam.color)
    //TODO: NOTE: need to calculate beam rec manuially, drawrectanglepro only moves the rec visually, but not the actual rec for update purposes
    //NOTE: https://stackoverflow.com/questions/18851761/convert-an-angle-in-degrees-to-a-vector
    DrawRectangleLinesEx(player_beam.rec, 5, rl.RED)
}

render_asteroid :: proc() 
{
    using rl

    DrawTexturePro(TEX_SPRITESHEET, asteroid.entity.spr.src, asteroid.entity.rec, asteroid.entity.spr.center, asteroid.entity.rot, asteroid.entity.spr.color)
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
