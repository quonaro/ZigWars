# Error return trace и работа с файлами в 0.17

## Что за trace

Запусти `zig test` на коде с `try`, где файл не существует, — увидишь **error return trace**:

```text
error: FileNotFound
error return trace:
  processFile
      ^-- try cwd.readFileAlloc(...) вернул ошибку здесь
  test "несуществующий файл"
      ^-- и пробросился сюда
```

Это карта пути ошибки: каждый `try`/`return error.X` на пути от места рождения до теста. Отличается от stack trace паники — panic показывает *стек вызовов*, error trace показывает *маршрут значения-ошибки*. Паника = баг, ошибка в trace = ожидаемый сбой, который кто-то не поймал.

Trace бесплатен для успешного пути, платится только на ошибках, и отключён в ReleaseFast/ReleaseSmall.

## `std.Io` в 0.17

С 0.17 файловый API живёт в `std.Io` (не `std.fs`/`std.io`) и требует **io-объект первым аргументом**:

```zig
const io = std.testing.io;          // Io для тестов
const cwd = std.Io.Dir.cwd();       // текущая директория
```

`std.testing.io` — готовый `Io` для тестов. В продакшн-коде `pub fn main(init: std.process.Init) !void` даёт `init.io` — но в тестах просто бери `std.testing.io`.

## Чтение файла целиком

```zig
const data = try cwd.readFileAlloc(io, path, alloc, .limited(1 << 16));
defer alloc.free(data);
```

- `path` — строка, может быть абсолютной;
- `alloc` — куда аллоцировать буфер (в тестах `std.testing.allocator` — он ещё и утечки ловит);
- `.limited(n)` — лимит на размер: больше n байт — ошибка, защита от «случайно прочитать 50 ГБ».

## Проброс ошибок

`readFileAlloc` умеет падать по-разному: `FileNotFound`, `AccessDenied`, `OutOfMemory`, превышение лимита. Если твоей функции нечего с этим делать — `try`, и ошибка со своим trace уйдёт выше.

```zig
pub fn processFile(path: []const u8) !usize {
    const data = try std.Io.Dir.cwd().readFileAlloc(
        std.testing.io, path, std.testing.allocator, .limited(1 << 16),
    );
    defer std.testing.allocator.free(data);
    return data.len;
}
```

Голый `!usize` — inferred error set: компилятор сам соберёт все возможные ошибки `readFileAlloc`.

## `try` или `catch`?

- `try` — «не моя зона ответственности»: файл не нашёлся — пусть решает вызывающий (он знает контекст: конфиг? критично?).
- `catch` — «я знаю запасной план»: нет кеша — пересчитать, нет конфига — дефолты.

Правило: чем ниже по стеку, тем чаще `try`; решения о fallback принимают у границ (UI, main, request handler).

## `expectError` в тестах

```zig
try std.testing.expectError(error.FileNotFound, sol.processFile("/no/such"));
```

Проверяет, что выражение вернуло именно эту ошибку: другая ошибка или успех — тест красный. Так тестируем пути отказа, не поднимая паники.

## Что почитать

- [Langref 0.17.1 — Error Return Traces](https://ziglang.org/documentation/0.17.1/#Error-Return-Traces)
- [Langref 0.17.1 — Errors](https://ziglang.org/documentation/0.17.1/#Errors)
- [Langref 0.17.1 — defer](https://ziglang.org/documentation/0.17.1/#defer)
