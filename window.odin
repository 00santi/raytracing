package main
import rl "vendor:raylib"

init :: proc() -> rl.Texture {
	rl.InitWindow(CANVAS_WIDTH, CANVAS_HEIGHT, "Odin Renderer")
	image := rl.GenImageColor(CANVAS_WIDTH, CANVAS_HEIGHT, rl.BLANK)
	texture := rl.LoadTextureFromImage(image)
	rl.UnloadImage(image)

	return texture
}
