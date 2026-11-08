const std = @import("std");

fn lessThan(_: void, a: i32, b: i32) bool {
    return a < b;
}

/// Копия xs: отсортированная по возрастанию, без дубликатов.
/// Свежий срез из alloc — владение у вызывающего.
pub fn uniqueSorted(alloc: std.mem.Allocator, xs: []const i32) ![]i32 {
    const dup = try alloc.dupe(i32, xs);
    errdefer alloc.free(dup);

    std.mem.sort(i32, dup, {}, lessThan);

    var w: usize = 0;
    for (dup) |v| {
        if (w == 0 or dup[w - 1] != v) {
            dup[w] = v;
            w += 1;
        }
    }

    if (alloc.realloc(dup, w)) |shrunk| {
        return shrunk;
    } else |_| {
        // shrink не вышел — сделаем копию ровного размера
        const out = try alloc.dupe(i32, dup[0..w]);
        alloc.free(dup);
        return out;
    }
}
