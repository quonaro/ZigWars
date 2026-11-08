const std = @import("std");

/// Вернуть копию среза, выделенную из alloc. Вызывающий владеет результатом.
pub fn dupSlice(alloc: std.mem.Allocator, xs: []const i32) ![]i32 {
    // TODO
    _ = alloc;
    _ = xs;
    return error.OutOfMemory;
}
