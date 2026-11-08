const std = @import("std");

/// [0, 1, 4, ..., (n-1)^2] как []u64, собранный через ArrayList.
pub fn squares(alloc: std.mem.Allocator, n: usize) ![]u64 {
    var list: std.ArrayList(u64) = .empty;
    defer list.deinit(alloc);
    for (0..n) |i| {
        const x: u64 = @intCast(i);
        try list.append(alloc, x * x);
    }
    return list.toOwnedSlice(alloc);
}
