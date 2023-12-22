package game

import "core:fmt"
import "core:math"
import rl "vendor:raylib"
import "utils"

init_asteroid :: proc(SPAWN_AT : rl.Vector2, TYPE : Entity_Type) -> Asteroid_Entity
{
    using rl

    asteroid : Asteroid_Entity

    asteroid.is_carried = false
    asteroid.is_shot = false
    asteroid.speed = 2
    asteroid.velocity = 20
    asteroid.rot_speed = 4

    e : Entity
    e.active = true
    e.type = TYPE
    e.id = 1
    e.rot = 0

    s : Sprite
    s.color = WHITE
    if e.type == .ENT_ASTEROID_S
    {
        e.rec = Rectangle{ SPAWN_AT.x, SPAWN_AT.y, f32(8 * SCALE), f32(8 * SCALE) }
        s.src = Rectangle{ 0, 32, 8, 8 }
    }
    else if e.type == .ENT_ASTEROID_M
    {
        e.rec = Rectangle{ SPAWN_AT.x, SPAWN_AT.y, f32(16 * SCALE), f32(16 * SCALE) }
        s.src = Rectangle{ 16, 32, 16, 16 }
    }
    else if e.type == .ENT_ASTEROID_L
    {
        e.rec = Rectangle{ SPAWN_AT.x, SPAWN_AT.y, f32(24 * SCALE), f32(24 * SCALE) }
        s.src = Rectangle{ 0, 48, 24, 24 }
    }
    s.center = Vector2{ f32(int(s.src.width / 2) * SCALE), f32(int(s.src.height / 2) * SCALE) }

    e.spr = s
    asteroid.entity = e

    return asteroid
}

init_all_asteroids :: proc()
{
    using rl

    asteroids[asteroids_count] = init_asteroid(Vector2{150, 200}, .ENT_ASTEROID_S)
    asteroids_count += 1
    asteroids[asteroids_count] = init_asteroid(Vector2{150, 600}, .ENT_ASTEROID_S)
    asteroids_count += 1
    asteroids[asteroids_count] = init_asteroid(Vector2{500, 600}, .ENT_ASTEROID_M)
    asteroids_count += 1
    asteroids[asteroids_count] = init_asteroid(Vector2{500, 200}, .ENT_ASTEROID_L)
    asteroids_count += 1
}

update_asteroids :: proc()
{
    using rl
    
    a : ^Asteroid_Entity
    for i in 0..<asteroids_count
    {
            a = &asteroids[i]

            if a.is_carried
            {
                rot_radians := player.entity.rot * DEG2RAD
                asteroid_forward := Vector2{}
                dist_offset := player_beam.dist_offset

                //NOTE: https://www.reddit.com/r/gamedev/comments/bje7vd/how_to_calculate_an_objects_normalized_forward/
                tmp_pos := Vector2{player.entity.rec.x, player.entity.rec.y}
                asteroid_forward.x = tmp_pos.x + dist_offset * math.sin_f32(rot_radians)
                asteroid_forward.y = tmp_pos.y - dist_offset * math.cos_f32(rot_radians)

                a.entity.rec.x = asteroid_forward.x
                a.entity.rec.y = asteroid_forward.y
            }

            if a.is_shot
            {
                a.entity.rec.x += a.shot_dir.x * a.velocity
                a.entity.rec.y += a.shot_dir.y * a.velocity
        }
    }
}

render_asteroids :: proc() 
{
    using rl

    a : ^Asteroid_Entity
    
    for i in 0..<asteroids_count
    {
        a = &asteroids[i]

        if a.entity.active
        {
            DrawTexturePro(
                TEX_SPRITESHEET,
                a.entity.spr.src,
                a.entity.rec,
                a.entity.spr.center, 
                a.entity.rot,
                a.entity.spr.color)

                        
            dir_dist := utils.vec2_subtract(
                Vector2{a.entity.rec.x, a.entity.rec.y}, 
                Vector2{player.entity.rec.x, player.entity.rec.y})
            dir := utils.vec2_normalize(dir_dist)

            pos := utils.vec2_add(Vector2{player.entity.rec.x, player.entity.rec.y}, dir * 120)
            if a.entity.type == .ENT_ASTEROID_S && a.is_carried
            {
                steps := 6
                for i in 0..<steps
                {
                    DrawCircleV(pos, 5 / f32(1 + f32(i) * f32(.2)), C_BEAM_COLOR)
                    pos = utils.vec2_add(Vector2{player.entity.rec.x, player.entity.rec.y}, dir * f32(120 + (i * 15)))
                }
            }
        }    
    }
}

shoot_asteroid :: proc(A : ^Asteroid_Entity)
{
    using rl 

    dir_dist := utils.vec2_subtract(
        Vector2{A.entity.rec.x, A.entity.rec.y}, 
        Vector2{player.entity.rec.x, player.entity.rec.y})
    dir := utils.vec2_normalize(dir_dist)

    pos := utils.vec2_add(Vector2{player.entity.rec.x, player.entity.rec.y}, dir)
    DrawCircleV(pos, 20, RED)
    
    A.shot_dir = dir
    A.is_shot = true
}
