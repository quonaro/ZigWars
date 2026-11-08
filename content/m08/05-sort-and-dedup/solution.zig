const std = @import("std");

/// Копия xs: отсортированная по возрастанию, без дубликатов.
/// Свежий срез из alloc — владение у вызывающего.
pub fn uniqueSorted(alloc: std.mem.Allocator, xs: []const i32) ![]i32 {
    // TODO
    _ = alloc;
    _ = xs;
    return error.OutOfMemory;
}
