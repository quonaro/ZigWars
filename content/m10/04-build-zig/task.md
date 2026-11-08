## Задание

Реализуй `parseZon` — разбор ZON-подобного текста в структуру `Config` через `std.zon.parse.fromSlice`.

```zig
pub const Mode = enum { debug, release };

pub const Config = struct {
    name: []const u8,
    version: []const u8 = "0.0.0",
    mode: Mode = .debug,
};

pub fn parseZon(arena: std.mem.Allocator, text: [:0]const u8) !Config
```

### Правила

- Используй `std.zon.parse.fromSlice(Config, .{ ... })` — не пиши ручной парсер.
- В `options` передай `gpa = arena` и `arena = arena` (тест создаёт `ArenaAllocator` и освобождает всё сразу — тебе не нужно `deinit` внутри функции).
- `diagnostics` — `var diag: std.zon.parse.Diagnostics = undefined;` внутри функции, передай `&diag`.
- `source` — `text` (уже `[:0]const u8`).
- Ошибку парсинга пробрасывай (`error.ParseZon` — обычный `try`).

### Примеры

```zig
parseZon(arena, ".{ .name = \"app\" }")               // .{ .name = "app", .version = "0.0.0", .mode = .debug }
parseZon(arena, ".{ .name = \"x\", .mode = .release }") // mode = release
parseZon(arena, ".{ .name = }")                        // error.ParseZon
```

### Подсказка по enum

Enum-литералы в ZON пишутся как `.release` — `fromSlice` сам смаппит в `Mode.release`.
