package main
import "core:math"
import la "core:math/linalg"

INF :: math.INF_F32
epsilon: f32 : 0.1

vw: f32
vh: f32
vd: f32

spheres :: []Sphere {
	{ color=red, center=Vec3{0, -1, 3}, radius=1, specular=500, reflective=0.2 },
	{ green, Vec3{-2, 0, 4}, 1, 10, 0.4 },
	{ blue, Vec3{2, 0, 4}, 1, 500, 0.3 },
	{ yellow, Vec3{0, -5001, 0}, 5000, 1000, 0.5 },
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

draw_spheres :: proc(cam: Camera, viewport_width, viewport_height, viewport_distance: f32, subsampling: int) {
	vw = viewport_width
	vh = viewport_height
	vd = viewport_distance
	
	t_min: f32 : 1
	t_max: f32 : INF
	rec_depth :: 2
	
	steps := 1 + subsampling
	
	for x := MIN_X; x < MAX_X; x += steps {
		for y := MIN_Y; y < MAX_Y; y += steps {
			direction := cam.rotation * canvas_to_viewport(x, y)
			color := trace_ray(cam.position, direction, t_min, t_max, rec_depth)

			for dx in 0..<steps {
				for dy in 0..<steps {
					px := x + dx
					py := y + dy

	                if px < MAX_X && py < MAX_Y do put_pixel(px, py, color)
	            }
			}
		}
	}
}

canvas_to_viewport :: proc(x, y: int) -> Vec3 {
	return {
		f32(x) * vw / f32(CANVAS_WIDTH),
		f32(y) * vh / f32(CANVAS_HEIGHT),
		vd,
	}
}

trace_ray :: proc(origin, direction: Vec3, t_min, t_max: f32, rec_depth: i32) -> Color {
	hit_any, closest_t, sphere := closest_intersection(origin, direction, t_min, t_max)
	
	if !hit_any do return black
	
	P := origin + closest_t * direction
	normal := la.normalize(P - sphere.center)
	illum := compute_lighting(P, normal, -direction, sphere.specular)
	local_color := scale_color(sphere.color, illum)

	r := sphere.reflective
	if r <= 0 || rec_depth <= 0 do return local_color
	R := reflect_ray(-direction, normal)
	reflected_color := trace_ray(P, R, epsilon, INF, rec_depth - 1)

	local_color = scale_color(local_color, 1 - r)
	reflected_color = scale_color(reflected_color, r)
	return local_color + reflected_color
}

closest_intersection :: proc(O, D: Vec3, t_min, t_max: f32) -> (bool, f32, Sphere) {
	hit_any := false
	closest_t := t_max
	closest_sphere: Sphere
	
	for s in spheres {
		hit, t1, t2 := ray_sphere_intersection(O, D, s.center, s.radius)
		
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
	
	return hit_any, closest_t, closest_sphere
}

is_shadowed :: proc(P, L: Vec3, t_max: f32) -> bool {
	for s in spheres {
		hit, t1, t2 := ray_sphere_intersection(P, L, s.center, s.radius)
		
		if (t1 >= epsilon && t1 <= t_max) || 
		   (t2 >= epsilon && t2 <= t_max) {
			return true
		}
	}
	
	return false
}

// V = point->cam vector
compute_lighting :: proc(point, N, V: Vec3, specular: f32) -> (illumination: f32) {
	i: f32 = 0
	V := la.normalize(V)
	
	for light in ambient_lights {
		i += light.intensity
	}

	for l in point_lights {
		L := l.position - point
		if is_shadowed(point, L, la.length(L)) do continue
		L = la.normalize(L)
		i += compute_lighting_helper(N, V, L, specular, l.intensity)
	}

	for l in directional_lights {
		L := l.direction
		if is_shadowed(point, L, INF) do continue
		L = la.normalize(L)
		i += compute_lighting_helper(N, V, L, specular, l.intensity)
	}
	
	return i
}

// N = normal, V = point->cam, L = point->light, all normalized
compute_lighting_helper :: proc(N, V, L: Vec3, s, intensity: f32) -> (illum: f32) {
	light_directness := max(0, la.dot(L, N))
	illum += intensity * light_directness
	
	if s < 0 do return
	
	R := reflect_ray(L, N) // R = reflection of light direction, ie L mirrored across normal
	R = la.normalize(R)
	light_directness = max(0, la.dot(R, V))
	shine := math.pow(light_directness, s)
	illum += intensity * shine
	
	return
}
