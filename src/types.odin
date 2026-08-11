package main

Color :: [4]u8

Vec3 :: [3]f32

Sphere :: struct {
	color: Color,
	center: Vec3,
	radius: f32,
	specular: f32, // -1 for matte
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
