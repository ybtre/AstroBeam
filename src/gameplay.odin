package game 

import "core:fmt"
import "core:strings"
import "core:math"
import rl "vendor:raylib"


entity_pool   : [512]Entity
entity_count  : int           = 2

cam           : rl.Camera2D
cam_start_off : rl.Vector2

init_gameplay :: proc() {
    using rl

    cam.target = Vector2{ SCREEN.x / 2, SCREEN.y / 2 }
    cam.offset = Vector2{ SCREEN.x / 2, SCREEN.y / 2 } 
    cam_start_off = cam.offset
    cam.rotation = 0
    cam.zoom = 1

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
    player_beam.forward = Vector2{0, 0}
    player_beam.radius = 40
    player_beam.dist_offset = 80
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

    if IsKeyPressed(KeyboardKey.P){
        is_paused = !is_paused
    }


    update_player()

    update_collisions()

    if asteroid.is_moving
    {
        rot_radians := player.entity.rot * DEG2RAD
        asteroid_forward := Vector2{}
        dist_offset := player_beam.dist_offset

        //NOTE: https://www.reddit.com/r/gamedev/comments/bje7vd/how_to_calculate_an_objects_normalized_forward/
        tmp_pos := Vector2{player.entity.rec.x, player.entity.rec.y}
        asteroid_forward.x = tmp_pos.x + dist_offset * math.sin_f32(rot_radians)
        asteroid_forward.y = tmp_pos.y - dist_offset * math.cos_f32(rot_radians)

        asteroid.entity.rec.x = asteroid_forward.x
        asteroid.entity.rec.y = asteroid_forward.y
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
    
    rot_radians := player.entity.rot * DEG2RAD
    //NOTE:https://stackoverflow.com/questions/1695090/easy-trig-move-an-object-in-a-position
    player.entity.rec.x += math.sin_f32(rot_radians) * player.velocity
    player.entity.rec.y -= math.cos_f32(rot_radians) * player.velocity

    //NOTE: https://www.reddit.com/r/gamedev/comments/bje7vd/how_to_calculate_an_objects_normalized_forward/
    tmp_pos := Vector2{player.entity.rec.x, player.entity.rec.y}
    player_beam.forward.x = tmp_pos.x + player_beam.dist_offset * math.sin_f32(rot_radians)
    player_beam.forward.y = tmp_pos.y - player_beam.dist_offset * math.cos_f32(rot_radians)
}

update_collisions :: proc() 
{
    using fmt
    using rl

    if asteroid.entity.active
    {
        if CheckCollisionCircleRec(player_beam.forward, player_beam.radius, asteroid.entity.rec)
        {
            if IsKeyPressed(KeyboardKey.SPACE)
            {
                if !asteroid.is_moving
                {
                    asteroid.is_moving = true
                }
            }
        }
    }
    
    if asteroid.is_moving
    {
        if IsKeyPressed(KeyboardKey.E)
        {
            asteroid.is_moving = false
        }
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

    DrawCircleV(player_beam.forward, player_beam.radius, player_beam.color)

    //NOTE: https://stackoverflow.com/questions/18851761/convert-an-angle-in-degrees-to-a-vector
}

render_asteroid :: proc() 
{
    using rl

    if asteroid.entity.active
    {
        DrawTexturePro(TEX_SPRITESHEET, asteroid.entity.spr.src, asteroid.entity.rec, asteroid.entity.spr.center, asteroid.entity.rot, asteroid.entity.spr.color)
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
