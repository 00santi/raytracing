package main
import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 800
HEIGHT :: 600
MIN_X :: -WIDTH / 2
MIN_Y :: -HEIGHT / 2
MAX_X :: WIDTH / 2
MAX_Y :: HEIGHT / 2

Color :: struct {
    r, g, b, a: u8,
}

red :: Color{255, 0, 0, 255}

pixels: []Color

put_pixel :: proc(x, y: int, color: Color) {
    if x < MIN_X || x >= MAX_X || y < MIN_Y || y >= MAX_Y {
    	fmt.println("out of bounds")
    	return
    }
    
    x := MAX_X + x
    y := MAX_Y - y - 1
    pixels[y * WIDTH + x] = color
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

main :: proc() {
	pixels = make([]Color, WIDTH * HEIGHT)
	texture := init()
	
	for !rl.WindowShouldClose() {
	    clear(Color{110, 110, 110, 255})
	    put_pixel(0, 0, red)
	    render(texture)
	}
}
