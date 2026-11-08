const std = @import("std");

/// Прочитай src, переведи ASCII a-z в верхний регистр, запиши в dst.
pub fn copyUpper(io: std.Io, alloc: std.mem.Allocator, src: []const u8, dst: []const u8) !void {
    const cwd = std.Io.Dir.cwd();
    const data = try cwd.readFileAlloc(io, src, alloc, .limited(1 << 20));
    defer alloc.free(data);
    for (data) |*c| {
        if (c.* >= 'a' and c.* <= 'z') c.* -= 32;
    }
    var f = try cwd.createFile(io, dst, .{});
    defer f.close(io);
    try f.writeStreamingAll(io, data);
}
