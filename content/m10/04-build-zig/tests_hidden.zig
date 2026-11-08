const std = @import("std");
const sol = @import("solution.zig");

fn parse(text: [:0]const u8) !sol.Config {
    var arena_inst = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_inst.deinit();
    return sol.parseZon(arena_inst.allocator(), text);
}

test "неполный конфиг — микс полей" {
    var arena_inst = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_inst.deinit();
    const cfg = try sol.parseZon(arena_inst.allocator(), ".{ .name = \"svc\", .version = \"2.0\" }");
    try std.testing.expectEqualStrings("svc", cfg.name);
    try std.testing.expectEqualStrings("2.0", cfg.version);
    try std.testing.expectEqual(sol.Mode.debug, cfg.mode);

    const cfg2 = try sol.parseZon(arena_inst.allocator(), ".{ .name = \"svc\", .version = \"9.9\", .mode = .debug }");
    try std.testing.expectEqualStrings("9.9", cfg2.version);
    try std.testing.expectEqual(sol.Mode.debug, cfg2.mode);
}

test "имя — произвольная строка" {
    var arena_inst = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_inst.deinit();
    const cfg = try sol.parseZon(arena_inst.allocator(), ".{ .name = \"my-app_v2.0\" }");
    try std.testing.expectEqualStrings("my-app_v2.0", cfg.name);
}

test "мусор после объекта — ошибка" {
    var arena_inst = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_inst.deinit();
    try std.testing.expectError(
        error.ParseZon,
        sol.parseZon(arena_inst.allocator(), ".{ .name = \"x\" } garbage"),
    );
}

test "незнакомое поле — ошибка" {
    var arena_inst = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_inst.deinit();
    try std.testing.expectError(
        error.ParseZon,
        sol.parseZon(arena_inst.allocator(), ".{ .name = \"x\", .unknown = 1 }"),
    );
}

test "невалидный ZON — разные входы" {
    var arena_inst = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_inst.deinit();
    const a = arena_inst.allocator();
    try std.testing.expectError(error.ParseZon, sol.parseZon(a, ""));
    try std.testing.expectError(error.ParseZon, sol.parseZon(a, ".{ }"));
    try std.testing.expectError(error.ParseZon, sol.parseZon(a, ".{ .mode = .nope, .name = \"x\" }"));
    try std.testing.expectError(error.ParseZon, sol.parseZon(a, ".{ .name = 42 }"));
}
