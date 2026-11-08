const std = @import("std");
const sol = @import("solution.zig");

const A = std.testing.allocator;

test "много элементов — рост и длинный прогон" {
    var s: sol.Stack(u32) = .{};
    defer s.items.deinit(A);

    for (0..500) |i| try s.push(A, @intCast(i));
    try std.testing.expect(!s.isEmpty());
    var i: usize = 500;
    while (i > 0) {
        i -= 1;
        try std.testing.expectEqual(@as(u32, @intCast(i)), s.pop().?);
    }
    try std.testing.expect(s.isEmpty());
    try std.testing.expectEqual(@as(?u32, null), s.pop());
}

test "push после полного опустошения" {
    var s: sol.Stack(i32) = .{};
    defer s.items.deinit(A);

    try s.push(A, 1);
    _ = s.pop();
    try std.testing.expect(s.isEmpty());
    try s.push(A, 99);
    try std.testing.expect(!s.isEmpty());
    try std.testing.expectEqual(99, s.pop().?);
}

test "два стека независимы" {
    var a: sol.Stack(i32) = .{};
    defer a.items.deinit(A);
    var b: sol.Stack(i32) = .{};
    defer b.items.deinit(A);

    try a.push(A, 1);
    try a.push(A, 2);
    try b.push(A, -9);
    try std.testing.expectEqual(-9, b.pop().?);
    try std.testing.expect(b.isEmpty());
    try std.testing.expectEqual(2, a.pop().?);
}

test "стек структур и булев тип" {
    const P = struct { x: i32, ok: bool };
    var sp: sol.Stack(P) = .{};
    defer sp.items.deinit(A);
    try sp.push(A, .{ .x = 1, .ok = true });
    try std.testing.expect(sp.pop().?.ok);

    var sb: sol.Stack(bool) = .{};
    defer sb.items.deinit(A);
    try sb.push(A, false);
    try sb.push(A, true);
    try std.testing.expectEqual(true, sb.pop().?);
    try std.testing.expectEqual(false, sb.pop().?);
}
