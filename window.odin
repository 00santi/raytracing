package main
import rl "vendor:raylib"

init :: proc() -> rl.Texture {
	rl.InitWindow(WIDTH, HEIGHT, "Odin Renderer")
	image := rl.GenImageColor(WIDTH, HEIGHT, rl.BLANK)
	texture := rl.LoadTextureFromImage(image)
	rl.UnloadImage(image)

	return texture
}
