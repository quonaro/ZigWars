const std = @import("std");

pub const Point = struct {
    x: f64,
    y: f64,

    /// Сложение векторов: возвращает новую точку, self не меняется.
    pub fn add(self: Point, other: Point) Point {
        // TODO: верни Point с суммой координат
        _ = other;
        return self;
    }
};

/// Евклидово расстояние между точками a и b.
pub fn distance(a: Point, b: Point) f64 {
    // TODO: sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
    _ = a;
    _ = b;
    return 0;
}
