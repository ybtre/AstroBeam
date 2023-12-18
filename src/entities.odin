package game 

import rl "vendor:raylib"

Sprite :: struct {
    src: rl.Rectangle,
    color: rl.Color,

    center: rl.Vector2,
}

Entity_Type :: enum {
    ENT_PLAYER,
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
    entity      : Entity,
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
