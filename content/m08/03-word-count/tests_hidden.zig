const std = @import("std");
const sol = @import("solution.zig");

const A = std.testing.allocator;

test "разделители только из трёх байтов" {
    // ';' и ',' — НЕ разделители
    try std.testing.expectEqual(@as(usize, 1), try sol.wordCount(A, "foo,bar"));
    try std.testing.expectEqual(@as(usize, 1), try sol.wordCount(A, "a;b"));
    // а '\r' — тоже не разделитель по контракту
    try std.testing.expectEqual(@as(usize, 1), try sol.wordCount(A, "x\ry"));
}

test "разделители по краям и подряд" {
    try std.testing.expectEqual(@as(usize, 1), try sol.wordCount(A, "  word  "));
    try std.testing.expectEqual(@as(usize, 2), try sol.wordCount(A, "\t\ta\t\t\n\nb\n\n"));
    try std.testing.expectEqual(@as(usize, 0), try sol.wordCount(A, "\t\n \t\n"));
}

test "длинное повторяющееся слово" {
    var buf: std.ArrayList(u8) = .empty;
    defer buf.deinit(A);
    // одно и то же слово из 500 букв трижды, через разные разделители
    for (0..3) |i| {
        try buf.appendNTimes(A, 'x', 500);
        try buf.appendSlice(A, if (i == 0) " " else if (i == 1) "\n" else "\t");
    }
    try std.testing.expectEqual(@as(usize, 1), try sol.wordCount(A, buf.items));
}

test "много разных слов" {
    var aw: std.Io.Writer.Allocating = .init(A);
    defer aw.deinit();
    // 30 разных слов w0..w29, каждое повторено дважды
    for (0..30) |i| {
        try aw.writer.print("w{d} w{d} ", .{ i, i });
    }
    try std.testing.expectEqual(@as(usize, 30), try sol.wordCount(A, aw.written()));
}
