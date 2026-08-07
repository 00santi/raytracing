package main

Color :: struct {
    r, g, b, a: u8
}

Vec3 :: [3]f32

Sphere :: struct {
    center: Vec3,
    radius: f32,
    color: Color,
}
