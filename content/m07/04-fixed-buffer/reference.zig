const std = @import("std");

/// Склеить a и b в начало buf. Если не влезает — error.OutOfMemory.
/// Возвращённый срез живёт внутри buf.
pub fn concatFixed(buf: []u8, a: []const u8, b: []const u8) ![]u8 {
    var fba = std.heap.FixedBufferAllocator.init(buf);
    return std.mem.concat(fba.allocator(), u8, &.{ a, b });
}
