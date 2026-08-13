package main
import rl "vendor:raylib"

pixels: []Color
speed :: 0.1

main :: proc() {
	pixels = make([]Color, CANVAS_WIDTH * CANVAS_HEIGHT)
	texture := init()

	camera := Camera{ Vec3{0, 0, 0}, 1 } // 1 = identity matrix
    viewport_width: f32 = 1
    viewport_height: f32 = 1
    viewport_distance: f32 = 1
    
	for !rl.WindowShouldClose() {
		if rl.IsKeyDown(.A) do camera.position.x -= speed;
		if rl.IsKeyDown(.D) do camera.position.x += speed;
		if rl.IsKeyDown(.W) do camera.position.z += speed;
		if rl.IsKeyDown(.S) do camera.position.z -= speed;
		if rl.IsKeyDown(.SPACE) do camera.position.y += speed;
		if rl.IsKeyDown(.LEFT_CONTROL) do camera.position.y -= speed;
		draw_spheres(camera, viewport_width, viewport_height, viewport_distance)
	    render(texture)
	}
}
