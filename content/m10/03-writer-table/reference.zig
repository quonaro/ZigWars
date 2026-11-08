const std = @import("std");

/// Отрендери таблицу пар ключ-значение. Владение результатом — у вызывающего.
pub fn renderTable(alloc: std.mem.Allocator, rows: []const [2][]const u8) ![]u8 {
    var aw: std.Io.Writer.Allocating = .init(alloc);
    defer aw.deinit();

    var w0: usize = 0;
    for (rows) |r| w0 = @max(w0, r[0].len);

    for (rows) |r| {
        try aw.writer.writeAll(r[0]);
        var pad: usize = w0 - r[0].len;
        while (pad > 0) : (pad -= 1) try aw.writer.writeAll(" ");
        try aw.writer.print(" | {s}\n", .{r[1]});
    }
    return try aw.toOwnedSlice();
}
