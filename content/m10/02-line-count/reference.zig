const std = @import("std");

/// Число строк в файле: count('\n') + 1, если не пуст и не кончается на '\n'.
pub fn countLines(io: std.Io, alloc: std.mem.Allocator, path: []const u8) !usize {
    const cwd = std.Io.Dir.cwd();
    const data = try cwd.readFileAlloc(io, path, alloc, .limited(1 << 20));
    defer alloc.free(data);
    if (data.len == 0) return 0;
    var lines = std.mem.count(u8, data, "\n");
    if (data[data.len - 1] != '\n') lines += 1;
    return lines;
}
