package main
import rl "vendor:raylib"

init :: proc() -> rl.Texture {
	rl.InitWindow(CANVAS_WIDTH, CANVAS_HEIGHT, "Odin Renderer")
	if CANVAS_WIDTH >= 1900 || CANVAS_HEIGHT >= 1000 do rl.ToggleFullscreen()
	image := rl.GenImageColor(CANVAS_WIDTH, CANVAS_HEIGHT, rl.BLANK)
	texture := rl.LoadTextureFromImage(image)
	rl.UnloadImage(image)
	return texture
}
