const std = @import("std");

pub const Dir = enum { north, east, south, west };

/// Поворот на 90°: .left — против часовой, .right — по часовой.
pub fn turn(d: Dir, side: enum { left, right }) Dir {
    const i: u8 = @intFromEnum(d);
    const j: u8 = switch (side) {
        .right => @mod(i + 1, 4),
        .left => @mod(i + 3, 4),
    };
    return @enumFromInt(j);
}

/// Направление в градусах: north=0, east=90, south=180, west=270.
pub fn toDegrees(d: Dir) u16 {
    return switch (d) {
        .north => 0,
        .east => 90,
        .south => 180,
        .west => 270,
    };
}
