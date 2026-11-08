const std = @import("std");
const sol = @import("solution.zig");
const Dir = sol.Dir;

test "повороты вправо" {
    try std.testing.expectEqual(Dir.east, sol.turn(.north, .right));
    try std.testing.expectEqual(Dir.south, sol.turn(.east, .right));
    try std.testing.expectEqual(Dir.west, sol.turn(.south, .right));
    try std.testing.expectEqual(Dir.north, sol.turn(.west, .right));
}

test "повороты влево" {
    try std.testing.expectEqual(Dir.west, sol.turn(.north, .left));
    try std.testing.expectEqual(Dir.east, sol.turn(.south, .left));
    try std.testing.expectEqual(Dir.south, sol.turn(.west, .left));
}

test "лево и право взаимно обратны" {
    for ([_]Dir{ .north, .east, .south, .west }) |d| {
        try std.testing.expectEqual(d, sol.turn(sol.turn(d, .left), .right));
        try std.testing.expectEqual(d, sol.turn(sol.turn(d, .right), .left));
    }
}

test "градусы" {
    try std.testing.expectEqual(0, sol.toDegrees(.north));
    try std.testing.expectEqual(90, sol.toDegrees(.east));
    try std.testing.expectEqual(180, sol.toDegrees(.south));
    try std.testing.expectEqual(270, sol.toDegrees(.west));
}

test "градусы согласованы с поворотом вправо" {
    const d: Dir = .east;
    try std.testing.expectEqual(@mod(sol.toDegrees(d) + 90, 360), sol.toDegrees(sol.turn(d, .right)));
}
