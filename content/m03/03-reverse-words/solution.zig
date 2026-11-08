const std = @import("std");

/// Переворачивает порядок слов. Результат выделен через alloc — освободи сам.
pub fn reverseWords(alloc: std.mem.Allocator, s: []const u8) ![]u8 {
    // TODO
    _ = alloc;
    _ = s;
    return error.OutOfMemory;
}
