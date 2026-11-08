const std = @import("std");

/// Читает файл целиком и возвращает размер в байтах.
/// Ошибки (нет файла, нет прав, переполнение лимита) пробрасываются наверх.
pub fn processFile(path: []const u8) !usize {
    // TODO: std.Io.Dir.cwd().readFileAlloc(std.testing.io, path,
    //       std.testing.allocator, .limited(1 << 16)) + defer free
    _ = path;
    return 0;
}
