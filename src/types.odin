package main

Color :: [4]u8
Vec3 :: [3]f32
Mat3 :: matrix[3, 3]f32

Sphere :: struct {
	color: Color,
	center: Vec3,
	radius: f32,
	specular: f32, // -1 for matte
	reflective: f32, // between 0 and 1
}

AmbientLight :: struct {
	intensity: f32,
}

PointLight :: struct {
	intensity: f32,
	position: Vec3,
}

DirectionalLight :: struct {
	intensity: f32,
	direction: Vec3,
}

Camera :: struct {
	position: Vec3,
	rotation: Mat3,
}
