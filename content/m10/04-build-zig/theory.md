# build.zig — сборка это тоже код

В Zig нет Makefile, CMakeLists или JSON-конфига для сборки. Есть `build.zig` — обычная Zig-программа, которую компилирует и запускает `zig build`. Она объявляет цели: бинарники, библиотеки, тесты, шаги установки.

```zig
// build.zig (минимальный каркас)
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "app",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    b.installArtifact(exe);
}
```

`b.standardTargetOptions` и `b.standardOptimizeOption` создают флаги командной строки `-Dtarget=…`, `-Doptimize=…`. Команды `zig build`, `zig build test`, `zig build run` — это развёртывание шагов (`b.step`), которые объявил `build`.

## `zig init` — стандартный скелет

```
$ zig init
info: created build.zig
info: created build.zig.zon
info: created src/main.zig
info: created src/root.zig
```

- `src/main.zig` — точка входа бинарника.
- `src/root.zig` — корень библиотеки (если проект библиотечный).
- `build.zig.zon` — манифест пакета.

## build.zig.zon — данные вместо кода

`build.zig.zon` — это **ZON**: «Zig Object Notation», родной формат данных Zig. Синтаксис почти идентичен литералам Zig-структур:

```zig
.{
    .name = .myproject,
    .version = "0.1.0",
    .minimum_zig_version = "0.17.0",
    .dependencies = .{
        .some_lib = .{
            .url = "https://github.com/user/lib/archive/v1.tar.gz",
            .hash = "1220abcd…",
        },
    },
    .paths = .{ "src", "build.zig", "LICENSE" },
}
```

Зависимости подтягиваются `zig fetch <url>` — он скачает тарбол, посчитает хэш и обновит `build.zig.zon`. После этого `b.dependency("some_lib", .{})` в `build.zig` даст доступ к артефактам пакета.

## `std.zon.parse` — разбираем ZON сами

ZON можно парсить из программы: `std.zon.parse.fromSlice` заполняет Zig-структуру по тексту. API 0.17 принимает options-структуру с двумя аллокаторами: `gpa` (временные выделения при парсинге) и `arena` (куда пойдут результат и диагностика):

```zig
var arena_inst = std.heap.ArenaAllocator.init(gpa);
defer arena_inst.deinit();
var diag: std.zon.parse.Diagnostics = undefined;
const cfg = try std.zon.parse.fromSlice(Config, .{
    .gpa = gpa,
    .arena = arena_inst.allocator(),
    .source = text,           // [:0]const u8 — sentinel-terminated!
    .diagnostics = &diag,
});
```

Особенности:

- `source` — `[:0]const u8`: литерал строки подходит, а `[]const u8` из файла — допиши `0` в конец (`alloc.dupeZ`).
- Поля структуры с значениями по умолчанию можно опускать в тексте — подставятся дефолты.
- `ignore_unknown_fields = true` — игнорировать лишние поля.
- Ошибки — `error.ParseZon`, детали в `diagnostics`.

## Зачем это знать?

Понимать `build.zig` нужно в любом нетривиальном проекте: тесты, шаги, кросс-компиляция. ZON — это и манифест, и удобный конфиг-формат для своих приложений (вместо JSON).

## Что почитать

- [Zig Build System](https://ziglang.org/learn/build-system/)
- [std.Build](https://ziglang.org/documentation/0.17.1/std/#std.Build)
- [std.zon.parse](https://ziglang.org/documentation/0.17.1/std/#std.zon.parse)
