const std = @import("std");

pub const Mode = enum { debug, release };

pub const Config = struct {
    name: []const u8,
    version: []const u8 = "0.0.0",
    mode: Mode = .debug,
};

/// Разбери ZON-текст в Config через std.zon.parse.fromSlice.
pub fn parseZon(arena: std.mem.Allocator, text: [:0]const u8) !Config {
    var diagnostics: std.zon.parse.Diagnostics = undefined;
    return std.zon.parse.fromSlice(Config, .{
        .gpa = arena,
        .arena = arena,
        .source = text,
        .diagnostics = &diagnostics,
    });
}
