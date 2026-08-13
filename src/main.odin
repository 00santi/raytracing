package main
import rl "vendor:raylib"
import "core:math"

pixels: []Color
speed :: 0.1
sens :: 0.01
yaw: f32 = 1
pitch: f32 = 1
max_pitch :: math.PI / 2

main :: proc() {
	pixels = make([]Color, CANVAS_WIDTH * CANVAS_HEIGHT)
	texture := init()

	camera := Camera{ Vec3{0, 0, 0}, 1 } // 1 = identity matrix
    viewport_width: f32 = 1
    viewport_height: f32 = 1
    viewport_distance: f32 = 1

    subsampling :: 2 // 0 for no subsampling
    
	for !rl.WindowShouldClose() {
		if rl.IsKeyDown(.A) do camera.position.x -= speed;
		if rl.IsKeyDown(.D) do camera.position.x += speed;
		if rl.IsKeyDown(.W) do camera.position.z += speed;
		if rl.IsKeyDown(.S) do camera.position.z -= speed;
		if rl.IsKeyDown(.SPACE) do camera.position.y += speed;
		if rl.IsKeyDown(.LEFT_CONTROL) do camera.position.y -= speed;

		/*mouse := rl.GetMouseDelta()
		if mouse.x != 0 {
			yaw += mouse.x * sens
		}
		
		if mouse.y != 0 {
			pitch += mouse.y * sens
		}

		pitch = clamp(pitch, -max_pitch, max_pitch)
		camera.rotation = get_rotation_matrix(yaw, pitch)*/
		
		draw_spheres(camera, viewport_width, viewport_height, viewport_distance, subsampling)
	    render(texture)
	}
}
