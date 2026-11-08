const std = @import("std");

pub const Shape = union(enum) {
    circle: f64, // радиус
    rect: struct { w: f64, h: f64 }, // стороны
    square: f64, // сторона
};

/// Площадь фигуры.
pub fn area(s: Shape) f64 {
    return switch (s) {
        .circle => |r| std.math.pi * r * r,
        .rect => |rc| rc.w * rc.h,
        .square => |a| a * a,
    };
}
