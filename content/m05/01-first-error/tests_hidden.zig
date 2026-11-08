const std = @import("std");
const sol = @import("solution.zig");

test "таблица результатов" {
    const cases = [_]struct { a: i32, b: i32, want: i32 }{
        .{ .a = 100, .b = 10, .want = 10 },
        .{ .a = -100, .b = 10, .want = -10 },
        .{ .a = 1_000_000, .b = -3, .want = -333_333 },
        .{ .a = std.math.minInt(i32), .b = 1, .want = std.math.minInt(i32) },
        .{ .a = std.math.maxInt(i32), .b = -2, .want = -1_073_741_823 },
    };
    for (cases) |c| {
        try std.testing.expectEqual(c.want, try sol.divide(c.a, c.b));
    }
}

test "ошибка не зависит от числителя" {
    const nums = [_]i32{ 0, 1, -1, std.math.minInt(i32), std.math.maxInt(i32) };
    for (nums) |a| {
        try std.testing.expectError(error.DivisionByZero, sol.divide(a, 0));
    }
}

test "if error payload" {
    if (sol.divide(9, 3)) |q| {
        try std.testing.expectEqual(@as(i32, 3), q);
    } else |_| {
        return error.TestUnexpectedResult;
    }
    if (sol.divide(9, 0)) |_| {
        return error.TestUnexpectedResult;
    } else |err| {
        try std.testing.expectEqual(error.DivisionByZero, err);
    }
}
