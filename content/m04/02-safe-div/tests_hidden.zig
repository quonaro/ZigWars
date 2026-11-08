const std = @import("std");
const sol = @import("solution.zig");

test "свойство a = q*b + r" {
    const cases = [_]struct { a: i32, b: i32 }{
        .{ .a = 10, .b = 3 },
        .{ .a = -10, .b = 3 },
        .{ .a = 10, .b = -3 },
        .{ .a = -10, .b = -3 },
        .{ .a = 7, .b = 7 },
        .{ .a = 1, .b = 2 },
        .{ .a = std.math.maxInt(i32), .b = 2 },
        .{ .a = std.math.minInt(i32), .b = 1 },
        .{ .a = std.math.minInt(i32), .b = -2 },
        .{ .a = 1_000_000, .b = 999 },
        .{ .a = -999_999, .b = 1000 },
    };
    for (cases) |c| {
        const q = sol.safeDiv(c.a, c.b) orelse return error.TestUnexpectedResult;
        const a64: i64 = c.a;
        const b64: i64 = c.b;
        const r = a64 - @as(i64, q) * b64;
        try std.testing.expect(@abs(r) < @abs(b64));
        try std.testing.expect(r == 0 or (r > 0) == (a64 > 0));
    }
}

test "единичные делители" {
    try std.testing.expectEqual(@as(?i32, 999), sol.safeDiv(999, 1));
    try std.testing.expectEqual(@as(?i32, -999), sol.safeDiv(999, -1));
    try std.testing.expectEqual(@as(?i32, 0), sol.safeDiv(1, -1_000_000));
    try std.testing.expectEqual(@as(?i32, 1), sol.safeDiv(-5, -5));
}

test "нулевой делитель на разных числителях" {
    try std.testing.expect(sol.safeDiv(0, 0) == null);
    try std.testing.expect(sol.safeDiv(std.math.minInt(i32), 0) == null);
    try std.testing.expect(sol.safeDiv(std.math.maxInt(i32), 0) == null);
}
