const std = @import("std");

pub const Point = struct {
    x: f64,
    y: f64,

    /// Сложение векторов: возвращает новую точку, self не меняется.
    pub fn add(self: Point, other: Point) Point {
        return .{ .x = self.x + other.x, .y = self.y + other.y };
    }
};

/// Евклидово расстояние между точками a и b.
pub fn distance(a: Point, b: Point) f64 {
    const dx = a.x - b.x;
    const dy = a.y - b.y;
    return @sqrt(dx * dx + dy * dy);
}
