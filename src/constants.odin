package game 

import rl "vendor:raylib"

C_PLAYER     :: rl.Color{ 235, 162, 84, 255}
C_CURSOR     :: rl.Color{ 209, 191, 176, 255 }
C_TEXT       :: rl.Color{ 99, 47, 109, 255}
C_BTN_HOVER  :: rl.Color{ 200, 200, 200, 255 }
C_BACKGROUND :: rl.Color{ 9, 9, 19, 255 }
C_GRID       :: rl.Color{ 39, 39, 49, 255 }
C_TILE       :: rl.Color{ 51, 73, 76, 255 }
C_BEAM_COLOR :: rl.Color{ 107, 62, 117, 225 }

SCREEN : rl.Vector2 : { 720, 720 }
project_name :: "Astro Beam"

SCALE                   := 4
PLAYER_SCALE            := 6
