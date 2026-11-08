const std = @import("std");

/// Копия элементов xs, для которых pred(x) == true.
/// Память из alloc, владение у вызывающего.
pub fn filterAlloc(alloc: std.mem.Allocator, xs: []const i32, pred: fn (i32) bool) ![]i32 {
    var n: usize = 0;
    for (xs) |x| {
        if (pred(x)) n += 1;
    }
    const out = try alloc.alloc(i32, n);
    var w: usize = 0;
    for (xs) |x| {
        if (pred(x)) {
            out[w] = x;
            w += 1;
        }
    }
    return out;
}
