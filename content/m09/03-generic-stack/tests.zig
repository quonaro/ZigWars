const std = @import("std");
const sol = @import("solution.zig");

test "стек целых — LIFO" {
    const alloc = std.testing.allocator;
    var s: sol.Stack(i32) = .{};
    defer s.items.deinit(alloc);

    try s.push(alloc, 10);
    try s.push(alloc, 20);
    try s.push(alloc, 30);
    try std.testing.expectEqual(30, s.pop().?);
    try std.testing.expectEqual(20, s.pop().?);
    try s.push(alloc, 40);
    try std.testing.expectEqual(40, s.pop().?);
    try std.testing.expectEqual(10, s.pop().?);
}

test "пустой стек" {
    const alloc = std.testing.allocator;
    var s: sol.Stack(u8) = .{};
    defer s.items.deinit(alloc);

    try std.testing.expect(s.isEmpty());
    try std.testing.expectEqual(@as(?u8, null), s.pop());
    try s.push(alloc, 5);
    try std.testing.expect(!s.isEmpty());
}

test "стек строк — другой тип, та же функция" {
    const alloc = std.testing.allocator;
    var s: sol.Stack([]const u8) = .{};
    defer s.items.deinit(alloc);

    try s.push(alloc, "zig");
    try s.push(alloc, "wars");
    try std.testing.expectEqualStrings("wars", s.pop().?);
    try std.testing.expectEqualStrings("zig", s.pop().?);
}

test "разные инстанцирования — разные типы" {
    // Stack(i32) и Stack(u8) — разные типы; компилятор это проверяет.
    const S32 = sol.Stack(i32);
    const S8 = sol.Stack(u8);
    try std.testing.expect(S32 != S8);
    try std.testing.expect(S32 == sol.Stack(i32)); // кэш инстанцирований
}
