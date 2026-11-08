const std = @import("std");
const sol = @import("solution.zig");

test "экстремумы i32" {
    try std.testing.expectEqual(@as(i64, -1), sol.sumSlice(&.{ std.math.maxInt(i32), std.math.minInt(i32) }));
    try std.testing.expectEqual(@as(i64, 0), sol.sumSlice(&.{ std.math.minInt(i32), std.math.maxInt(i32), 1 }));
    try std.testing.expectEqual(@as(i64, -4_294_967_296), sol.sumSlice(&.{ std.math.minInt(i32), std.math.minInt(i32) }));
}

test "много элементов без переполнения i32" {
    const buf: [10]i32 = @splat(2_000_000_000);
    try std.testing.expectEqual(@as(i64, 20_000_000_000), sol.sumSlice(&buf));
    const buf2: [10]i32 = @splat(-2_000_000_000);
    try std.testing.expectEqual(@as(i64, -20_000_000_000), sol.sumSlice(&buf2));
}

test "чередование знаков" {
    var buf: [200]i32 = undefined;
    var want: i64 = 0;
    for (&buf, 0..) |*x, i| {
        x.* = if (@rem(@as(i64, @intCast(i)), 2) == 0) 1 else -1;
        want += x.*;
    }
    try std.testing.expectEqual(@as(i64, 0), sol.sumSlice(&buf));
    try std.testing.expectEqual(want, sol.sumSlice(&buf));
}

test "кусок большого слайса" {
    var buf: [50]i32 = undefined;
    for (&buf, 0..) |*x, i| {
        const v: i64 = @as(i64, @intCast(i)) * @as(i64, @intCast(i)) - 40;
        x.* = @intCast(v);
    }
    var want: i64 = 0;
    for (buf[10..30]) |x| want += x;
    try std.testing.expectEqual(want, sol.sumSlice(buf[10..30]));
}
