const std = @import("std");

/// Читает файл целиком и возвращает размер в байтах.
/// Ошибки (нет файла, нет прав, переполнение лимита) пробрасываются наверх.
pub fn processFile(path: []const u8) !usize {
    const io = std.testing.io;
    const data = try std.Io.Dir.cwd().readFileAlloc(
        io,
        path,
        std.testing.allocator,
        .limited(1 << 16),
    );
    defer std.testing.allocator.free(data);
    return data.len;
}
