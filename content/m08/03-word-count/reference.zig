const std = @import("std");

/// Количество уникальных слов в s (разделители: пробел, таб, \n).
pub fn wordCount(alloc: std.mem.Allocator, s: []const u8) !usize {
    var set = std.StringHashMap(void).init(alloc);
    defer set.deinit();
    var it = std.mem.tokenizeAny(u8, s, " \t\n");
    while (it.next()) |word| {
        try set.put(word, {});
    }
    return set.count();
}
