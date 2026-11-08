const std = @import("std");
const sol = @import("solution.zig");

test "нечётная длина" {
    var xs = [_]i32{ 1, 2, 3 };
    sol.reverseInPlace(&xs);
    try std.testing.expectEqualSlices(i32, &.{ 3, 2, 1 }, &xs);
}

test "чётная длина" {
    var xs = [_]i32{ 1, 2, 3, 4 };
    sol.reverseInPlace(&xs);
    try std.testing.expectEqualSlices(i32, &.{ 4, 3, 2, 1 }, &xs);
}

test "один элемент" {
    var xs = [_]i32{42};
    sol.reverseInPlace(&xs);
    try std.testing.expectEqualSlices(i32, &.{42}, &xs);
}

test "пустой слайс" {
    var xs = [_]i32{};
    sol.reverseInPlace(&xs);
    try std.testing.expectEqual(@as(usize, 0), xs.len);
}

test "отрицательные и повторы" {
    var xs = [_]i32{ -1, 0, 0, 5, -9 };
    sol.reverseInPlace(&xs);
    try std.testing.expectEqualSlices(i32, &.{ -9, 5, 0, 0, -1 }, &xs);
}

test "двойной разворот возвращает исходник" {
    var xs = [_]i32{ 7, 1, 4, 9, 2 };
    const orig = [_]i32{ 7, 1, 4, 9, 2 };
    sol.reverseInPlace(&xs);
    sol.reverseInPlace(&xs);
    try std.testing.expectEqualSlices(i32, &orig, &xs);
}
