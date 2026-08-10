package main
import "core:fmt"
import rl "vendor:raylib"

put_pixel :: proc(x, y: int, color: Color) {
	if x < MIN_X || x >= MAX_X || y < MIN_Y || y >= MAX_Y {
		fmt.println("out of bounds")
    	return
    }
    
    x := MAX_X + x
    y := MAX_Y - y - 1
    pixels[y * CANVAS_WIDTH + x] = color
}

clear :: proc(color: Color) {
	for &c in pixels {
		c = color
	}
}

render :: proc(texture: rl.Texture) {
	rl.UpdateTexture(texture, &pixels[0])
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	rl.DrawTexture(texture, 0, 0, rl.WHITE)
	rl.EndDrawing()
}
