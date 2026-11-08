const std = @import("std");

/// Отрендери таблицу пар ключ-значение. Владение результатом — у вызывающего.
pub fn renderTable(alloc: std.mem.Allocator, rows: []const [2][]const u8) ![]u8 {
    // TODO: реализуй меня через std.Io.Writer.Allocating
    _ = rows;
    return try alloc.dupe(u8, "");
}
