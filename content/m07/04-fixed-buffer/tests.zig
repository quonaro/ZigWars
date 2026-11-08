const std = @import("std");
const sol = @import("solution.zig");

test "простая склейка" {
    var buf: [64]u8 = undefined;
    const got = try sol.concatFixed(&buf, "foo", "bar");
    try std.testing.expectEqualStrings("foobar", got);
}

test "не влезает — OutOfMemory" {
    var buf: [5]u8 = undefined;
    try std.testing.expectError(error.OutOfMemory, sol.concatFixed(&buf, "abc", "def"));
}

test "ровно впритык" {
    var buf: [6]u8 = undefined;
    const got = try sol.concatFixed(&buf, "abc", "def");
    try std.testing.expectEqualStrings("abcdef", got);
}

test "пустые куски" {
    var buf: [8]u8 = undefined;
    try std.testing.expectEqualStrings("x", try sol.concatFixed(&buf, "", "x"));
    try std.testing.expectEqualStrings("y", try sol.concatFixed(&buf, "y", ""));
    try std.testing.expectEqualStrings("", try sol.concatFixed(&buf, "", ""));
}

test "результат указывает в buf" {
    var buf: [32]u8 = undefined;
    const got = try sol.concatFixed(&buf, "12", "34");
    try std.testing.expectEqual(@intFromPtr(&buf[0]), @intFromPtr(got.ptr));
}
