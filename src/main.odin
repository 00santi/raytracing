package main
import rl "vendor:raylib"

pixels: []Color

main :: proc() {
	pixels = make([]Color, CANVAS_WIDTH * CANVAS_HEIGHT)
	texture := init()

	camera := Vec3{0, 0, 0}
    viewport_width: f32 = 1
    viewport_height: f32 = 1
    viewport_distance: f32 = 1
	for !rl.WindowShouldClose() {
		draw_spheres(camera, viewport_width, viewport_height, viewport_distance)
	    render(texture)
	}
}
