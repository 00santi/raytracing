package main
import "core:fmt"
import rl "vendor:raylib"
import la "core:math/linalg"

pixels: []Color

main :: proc() {
	pixels = make([]Color, CANVAS_WIDTH * CANVAS_HEIGHT)
	texture := init()
	
	for !rl.WindowShouldClose() {
	    clear(black)
	    put_pixel(0, 0, red)
		main2()
	    render(texture)
	}
}
