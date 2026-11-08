const std = @import("std");

pub const Dir = enum { north, east, south, west };

/// Поворот на 90°: .left — против часовой, .right — по часовой.
pub fn turn(d: Dir, side: enum { left, right }) Dir {
    // TODO
    _ = side;
    return d;
}

/// Направление в градусах: north=0, east=90, south=180, west=270.
pub fn toDegrees(d: Dir) u16 {
    // TODO: switch по всем четырём направлениям
    _ = d;
    return 0;
}
