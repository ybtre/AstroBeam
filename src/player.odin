package game

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

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
    player_beam.dist_offset = 70
    player_beam.color = C_BEAM_COLOR

    s.src = Rectangle{ 0, 80, 16, 16 }
    s.color = Color{ 255, 255, 255, 100 }
    player_beam.spr = s
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


render_player :: proc() 
{
    using rl

    DrawTexturePro(TEX_SPRITESHEET, player.entity.spr.src, player.entity.rec, player.entity.spr.center, player.entity.rot, player.entity.spr.color)

    DrawTexturePro(TEX_SPRITESHEET, player_beam.spr.src, Rectangle{player_beam.forward.x, player_beam.forward.y, f32(16 * PLAYER_SCALE), f32(16 * PLAYER_SCALE)}, player_beam.spr.center, 0, player_beam.spr.color)
    //NOTE: for debug hitbox
    //DrawCircleV(player_beam.forward, player_beam.radius, player_beam.color)

    //NOTE: https://stackoverflow.com/questions/18851761/convert-an-angle-in-degrees-to-a-vector
}
