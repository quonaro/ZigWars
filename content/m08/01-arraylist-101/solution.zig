const std = @import("std");

/// [0, 1, 4, ..., (n-1)^2] как []u64, собранный через ArrayList.
pub fn squares(alloc: std.mem.Allocator, n: usize) ![]u64 {
    // TODO
    _ = alloc;
    _ = n;
    return error.OutOfMemory;
}
