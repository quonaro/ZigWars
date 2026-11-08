const std = @import("std");

/// Срез квадратов [0, 1, 4, ..., (n-1)^2], выделенный из arena_alloc.
pub fn buildLookup(arena_alloc: std.mem.Allocator, n: usize) ![]usize {
    // TODO
    _ = arena_alloc;
    _ = n;
    return error.OutOfMemory;
}
