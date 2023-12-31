package game 

import rl "vendor:raylib"

player          : Player_Entity
player_beam     : Player_Beam

//asteroid        : Asteroid_Entity
asteroids       : [64]Asteroid_Entity
asteroids_count : int

Sprite :: struct {
    src: rl.Rectangle,
    color: rl.Color,

    center: rl.Vector2,
}

Entity_Type :: enum {
    ENT_PLAYER,
    ENT_ASTEROID_S,
    ENT_ASTEROID_M,
    ENT_ASTEROID_L,
}

Entity :: struct {
    active      : bool,
    type        : Entity_Type,
    id          : int,
    rec         : rl.Rectangle,
    rot         : f32,
    spr         : Sprite,
}

Player_Entity :: struct {
    is_moving   : bool,
    speed       : f32,
    velocity    : f32,
    rot_speed   : f32,
    entity      : Entity,
}

Asteroid_Entity :: struct {
    is_carried  : bool,
    is_shot     : bool,
    speed       : f32,
    velocity    : f32,
    shot_dir    : rl.Vector2,
    rot_speed   : f32,
    entity      : Entity,
}

Player_Beam :: struct {
    active      : bool,
    forward     : rl.Vector2,
    radius      : f32,
    dist_offset : f32,
    color       : rl.Color,
    spr         : Sprite,
}

Background :: struct {
    active      : bool,
    rec         : rl.Rectangle,
    spr         : Sprite,
}

Cursor :: struct {
    spr: Sprite,
}

Button :: struct {
    rec: rl.Rectangle,
    spr: Sprite,
    is_highlighted: bool,
    is_pressed: bool,
}
