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

scale_color :: proc(c: Color, intensity: f32) -> Color {
	r := u8( clamp(f32(c.r) * intensity, 0, 255) )
	g := u8( clamp(f32(c.g) * intensity, 0, 255) )
	b := u8( clamp(f32(c.b) * intensity, 0, 255) )
	return Color{ r, g, b, c.a }
}

reflect_ray :: proc(L, N: Vec3) -> Vec3 {
	return 2 * N * la.dot(N, L) - L
}

get_rotation_matrix :: proc(yaw, pitch: f32) -> Mat3 {
	cp := math.cos(pitch)
    sp := math.sin(pitch)
    cy := math.cos(yaw)
    sy := math.sin(yaw)
    return Mat3 {
        cy,  0,   sy,
        0,  cp, -sp,
        -sy,  sp,  cp * cy,
    }
}
