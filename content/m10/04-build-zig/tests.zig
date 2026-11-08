const std = @import("std");
const sol = @import("solution.zig");

test "полный конфиг" {
    var arena_inst = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_inst.deinit();
    const cfg = try sol.parseZon(arena_inst.allocator(),
        \\.{
        \\    .name = "zigwars",
        \\    .version = "0.1.0",
        \\    .mode = .release,
        \\}
    );
    try std.testing.expectEqualStrings("zigwars", cfg.name);
    try std.testing.expectEqualStrings("0.1.0", cfg.version);
    try std.testing.expectEqual(sol.Mode.release, cfg.mode);
}

test "значения по умолчанию" {
    var arena_inst = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_inst.deinit();
    const cfg = try sol.parseZon(arena_inst.allocator(), ".{ .name = \"app\" }");
    try std.testing.expectEqualStrings("app", cfg.name);
    try std.testing.expectEqualStrings("0.0.0", cfg.version);
    try std.testing.expectEqual(sol.Mode.debug, cfg.mode);
}

test "enum из литерала" {
    var arena_inst = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_inst.deinit();
    const cfg = try sol.parseZon(arena_inst.allocator(), ".{ .name = \"x\", .mode = .release }");
    try std.testing.expectEqual(sol.Mode.release, cfg.mode);
}

test "ошибка парсинга" {
    var arena_inst = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_inst.deinit();
    try std.testing.expectError(
        error.ParseZon,
        sol.parseZon(arena_inst.allocator(), ".{ .name = }"),
    );
}

test "build.zig.zon-подобный текст" {
    var arena_inst = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_inst.deinit();
    const cfg = try sol.parseZon(arena_inst.allocator(),
        \\.{
        \\    .name = "myproject",
        \\    .version = "1.2.3",
        \\}
    );
    try std.testing.expectEqualStrings("myproject", cfg.name);
    try std.testing.expectEqualStrings("1.2.3", cfg.version);
    try std.testing.expectEqual(sol.Mode.debug, cfg.mode);
}
