package main

import "core:math"
import la "core:math/linalg"

ray_sphere_intersection :: proc(origin, direction, center: Vec3, radius: f32) -> (bool, f32, f32) {
	oc := origin - center
	
	a := la.dot(direction, direction)
	b := 2 * la.dot(oc, direction)
	c := la.dot(oc, oc) - (radius * radius)

	discr := (b * b) - (4 * a * c)
	if discr < 0 do return false, 0, 0
	t1 := (-b - math.sqrt(discr)) / (2 * a)
	t2 := (-b + math.sqrt(discr)) / (2 * a)
	
	return true, t1, t2
}
