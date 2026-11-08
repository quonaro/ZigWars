const std = @import("std");

/// Копия элементов xs, для которых pred(x) == true.
/// Память из alloc, владение у вызывающего.
pub fn filterAlloc(alloc: std.mem.Allocator, xs: []const i32, pred: fn (i32) bool) ![]i32 {
    // TODO
    _ = alloc;
    _ = xs;
    _ = pred;
    return error.OutOfMemory;
}
