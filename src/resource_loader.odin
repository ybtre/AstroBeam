package game

import rl "vendor:raylib"

TEX_SPRITESHEET 	: rl.Texture2D

SRC_TILE_WHITE  				:: rl.Rectangle{ 35, 100, 34, 34 }

SRC_WHITE_PAWN		:: rl.Rectangle{ 0, 48, 32, 48 }

load_spritesheet :: proc() {
	using rl

	TEX_SPRITESHEET = rl.LoadTexture("../assets/spritesheet.png")
}

unload_spritesheet :: proc() {
	using rl

	UnloadTexture(TEX_SPRITESHEET)
}
