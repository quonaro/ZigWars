const std = @import("std");

pub const Mode = enum { debug, release };

pub const Config = struct {
    name: []const u8,
    version: []const u8 = "0.0.0",
    mode: Mode = .debug,
};

/// Разбери ZON-текст в Config через std.zon.parse.fromSlice.
/// arena используется и для временных выделений, и для результата.
pub fn parseZon(arena: std.mem.Allocator, text: [:0]const u8) !Config {
    // TODO: реализуй меня через std.zon.parse.fromSlice
    _ = arena;
    _ = text;
    return .{ .name = "" };
}
