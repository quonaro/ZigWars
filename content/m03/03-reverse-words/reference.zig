const std = @import("std");

/// Переворачивает порядок слов. Результат выделен через alloc — освободи сам.
pub fn reverseWords(alloc: std.mem.Allocator, s: []const u8) ![]u8 {
    var words: std.ArrayList([]const u8) = .empty;
    defer words.deinit(alloc);

    var it = std.mem.tokenizeScalar(u8, s, ' ');
    while (it.next()) |word| {
        try words.append(alloc, word);
    }

    std.mem.reverse([]const u8, words.items);
    return std.mem.join(alloc, " ", words.items);
}
