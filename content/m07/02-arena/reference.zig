const std = @import("std");

/// Срез квадратов [0, 1, 4, ..., (n-1)^2], выделенный из arena_alloc.
pub fn buildLookup(arena_alloc: std.mem.Allocator, n: usize) ![]usize {
    const xs = try arena_alloc.alloc(usize, n);
    for (xs, 0..) |*x, i| {
        x.* = i * i;
    }
    return xs;
}
