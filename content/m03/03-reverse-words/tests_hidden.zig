const std = @import("std");
const sol = @import("solution.zig");

test "таб — это не разделитель" {
    const r = try sol.reverseWords(std.testing.allocator, "a\tb c");
    defer std.testing.allocator.free(r);
    try std.testing.expectEqualStrings("c a\tb", r);
}

test "только пробелы" {
    const r = try sol.reverseWords(std.testing.allocator, "     ");
    defer std.testing.allocator.free(r);
    try std.testing.expectEqualStrings("", r);
}

test "длинная цепочка слов" {
    const alloc = std.testing.allocator;
    var input: std.ArrayList(u8) = .empty;
    defer input.deinit(alloc);
    var expected: std.ArrayList(u8) = .empty;
    defer expected.deinit(alloc);
    var i: usize = 1;
    while (i <= 30) : (i += 1) {
        const piece = try alloc.print("{d}", .{i});
        defer alloc.free(piece);
        if (i > 1) try input.append(alloc, ' ');
        try input.appendSlice(alloc, piece);
    }
    var j: usize = 30;
    while (j >= 1) : (j -= 1) {
        const piece = try alloc.print("{d}", .{j});
        defer alloc.free(piece);
        if (j != 30) try expected.append(alloc, ' ');
        try expected.appendSlice(alloc, piece);
    }
    const r = try sol.reverseWords(alloc, input.items);
    defer alloc.free(r);
    try std.testing.expectEqualStrings(expected.items, r);
}

test "одиночные пробелы по краям" {
    const r = try sol.reverseWords(std.testing.allocator, " mid ");
    defer std.testing.allocator.free(r);
    try std.testing.expectEqualStrings("mid", r);
}
