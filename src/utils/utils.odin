package utils 

import "core:math"
import rl "vendor:raylib"

update_sprite_dest :: proc(NEW_POS: rl.Vector2, DEST: rl.Rectangle) -> rl.Rectangle {
    return { NEW_POS.x, NEW_POS.y, DEST.width, DEST.height }
}

// Add two vectors (v1 + v2)
vec2_add :: proc( V1, V2 : rl.Vector2) -> rl.Vector2
{
    using rl 

    result := Vector2{ V1.x + V2.x, V1.y + V2.y }

    return result
}

vec2_subtract :: proc(V1, V2 : rl.Vector2) -> rl.Vector2
{
    using rl

    result := Vector2{ V1.x - V2.x, V1.y - V2.y }

    return result
}

// Normalize provided vector
vec2_normalize :: proc(V : rl.Vector2) -> rl.Vector2
{
    using rl

    result : Vector2
    length := math.sqrt_f32((V.x * V.x) + (V.y * V.y))

    if (length > 0)
    {
        ilength := 1.0/length
        result.x = V.x * ilength
        result.y = V.y * ilength
    }

    return result
}

vec2_move_towards :: proc(V, TARGET : rl.Vector2, MAX_DIST : f32) -> rl.Vector2 {
    result : rl.Vector2

    dx := TARGET.x - V.x
    dy := TARGET.y - V.y
    value := (dx * dx) + (dy * dy)

    if value == 0 || MAX_DIST >= 0 && (value <= MAX_DIST * MAX_DIST)
    {
        return TARGET
    }

    dist := math.sqrt_f32(value)

    result.x = V.x + dx / dist * MAX_DIST
    result.y = V.y + dy / dist * MAX_DIST

    return result
}