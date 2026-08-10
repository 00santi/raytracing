package main
import "core:math"
import la "core:math/linalg"

vw: f32
vh: f32
spheres: []Sphere : {
	{ Vec3{0, -1, 3}, 1, red },
	{ Vec3{2, 0, 4}, 1, blue },
	{ Vec3{-2, 0, 4}, 1, green },
	{ Vec3{0, -5001, 0}, 5000, yellow },
}
ambient_lights :: []AmbientLight { 
	{ 0.2 }, 
}
point_lights :: []PointLight { 
	{ 0.2, Vec3{1, 4, 4} }, 
}
directional_lights :: []DirectionalLight { 
	{ 0.6, Vec3{2, 1, 0} },
}

draw_spheres :: proc(cam: Vec3, viewport_width, viewport_height, viewport_distance: f32) {
	vw = viewport_width
	vh = viewport_height

	t_min: f32 : 1
	t_max: f32 : math.INF_F32
	
	for x in MIN_X..<MAX_X {
		for y in MIN_Y..<MAX_Y {
			direction := canvas_to_viewport(x, y, viewport_distance)
			color := trace_ray(cam, direction, t_min, t_max)
			put_pixel(x, y, color)
		}
	}
}

canvas_to_viewport :: proc(x, y: int, d: f32) -> Vec3 {
	return {
		f32(x) * vw / f32(CANVAS_WIDTH),
		f32(y) * vh / f32(CANVAS_HEIGHT),
		d,
	}
}

trace_ray :: proc(cam: Vec3, direction: Vec3, t_min, t_max: f32) -> Color {
	closest_t := t_max
	hit_any := false
	closest_sphere: Sphere

	for s in spheres {
		hit, t1, t2 := ray_sphere_intersection(cam, direction, s.center, s.radius)

		if !hit do continue

		if t1 >= t_min && t1 <= t_max && t1 < closest_t {
			closest_t = t1
			closest_sphere = s
			hit_any = true
		}

		if t2 >= t_min && t2 <= t_max && t2 < closest_t {
			closest_t = t2
			closest_sphere = s
			hit_any = true
		}
	}

	if !hit_any do return black

	P := cam + closest_t * direction
	normal := P - closest_sphere.center
	illum := compute_lighting(P, normal)
	
	return scale_color(closest_sphere.color, illum)
}

compute_lighting :: proc(point, normal: Vec3) -> (illumination: f32) {
	i: f32 = 0
	N := la.normalize(normal)
	
	for light in ambient_lights {
		i += light.intensity
	}

	for light in point_lights {
		L := light.position - point
		L = la.normalize(L)
		light_directness := max(0, la.dot(L, N))
		i += light.intensity * light_directness
	}

	for light in directional_lights {
		L := light.direction
		L = la.normalize(L)
		light_directness := max(0, la.dot(L, N))
		i += light.intensity * light_directness
	}
	
	return i
}
