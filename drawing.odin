package main
import "core:fmt"
import "core:math"
import rl "vendor:raylib"
import la "core:math/linalg"

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

main2 :: proc() {
	cam := Vec3{0, 0, 0}
	distance :: 1 // from cam to viewport
	t_min: f32 : 1
	t_max: f32 : math.INF_F32
	
	for x in MIN_X..<MAX_X {
		for y in MIN_Y..<MAX_Y {
			direction := canvas_to_viewport(x, y, distance)
			color := trace_ray(cam, direction, t_min, t_max)
			put_pixel(x, y, color)
		}
	}
}

canvas_to_viewport :: proc(x, y, d: int) -> Vec3 {
	return {f32(x) * f32(VIEWPORT_WIDTH) / f32(CANVAS_WIDTH), 
			f32(y) * f32(VIEWPORT_HEIGHT) / f32(CANVAS_HEIGHT), 
			f32(d)}
}

spheres: [3]Sphere : {
	{ Vec3{0, -1, 3}, 1, Color{255, 0, 0, 255} },
	{ Vec3{2, 0, 4}, 1, Color{0, 0, 255, 255} },
	{ Vec3{-2, 0, 4}, 1, Color{0, 255, 0, 255} },
}

trace_ray :: proc(cam: Vec3, direction: Vec3, t_min, t_max: f32) -> Color {
	closest_t := t_max
	hit_any := false
	closest_sphere: Sphere

	for s in spheres {
		hit, t1, t2 := ray_sphere_intersection(cam, direction, s.center, s.radius)
		if !hit do continue

		hit_any = true

		if t1 > t_min && t1 < t_max && t1 < closest_t {
			closest_t = t1
			closest_sphere = s
		}

		if t2 > t_min && t2 < t_max && t2 < closest_t {
			closest_t = t2
			closest_sphere = s
		}
	}
	if !hit_any do return black

	return closest_sphere.color
}
