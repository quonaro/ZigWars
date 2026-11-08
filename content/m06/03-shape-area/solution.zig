const std = @import("std");

pub const Shape = union(enum) {
    circle: f64, // радиус
    rect: struct { w: f64, h: f64 }, // стороны
    square: f64, // сторона
};

/// Площадь фигуры.
pub fn area(s: Shape) f64 {
    // TODO: switch (s) с захватом payload через |v|
    _ = s;
    return 0;
}
