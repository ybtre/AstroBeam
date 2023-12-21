package game

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

update_collisions :: proc() 
{
    using fmt
    using rl

    a : ^Asteroid_Entity
    b : ^Asteroid_Entity
    for i in 0..<asteroids_count
    {
        a = &asteroids[i]
        if a.entity.active
        {
            if a.entity.type == .ENT_ASTEROID_S
            {
                if CheckCollisionCircleRec(player_beam.forward, player_beam.radius, a.entity.rec)
                {
                    if IsKeyPressed(KeyboardKey.SPACE)
                    {
                        if !a.is_carried
                        {
                            a.is_carried = true
                        }
                        else 
                        {
                            a.is_carried = false
                            shoot_asteroid(a)
                        }
                    }
                }
            }
        }

        for j in 0..<asteroids_count
        {
            b = &asteroids[j]

            if (b.entity.active) && (a != b)
            {
                if CheckCollisionRecs(a.entity.rec, b.entity.rec)
                {
                    fmt.println("HIIIT")
                    a.entity.active = false
                    b.entity.active = false
                }
            }
        }
    }
}
