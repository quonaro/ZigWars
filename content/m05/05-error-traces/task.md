## Задание

Прочитай файл целиком и верни его размер в байтах:

```zig
pub fn processFile(path: []const u8) !usize
```

Используй новый API 0.17:

```zig
const io = std.testing.io;
const cwd = std.Io.Dir.cwd();
const data = try cwd.readFileAlloc(io, path, std.testing.allocator, .limited(1 << 16));
```

Ошибки чтения **пробрасывай** `try` — не глотай. Не забудь `defer std.testing.allocator.free(data);` — иначе testing allocator ругнётся на утечку.

### Примеры

| Файл | Результат |
|------|-----------|
| существующий, `"hello"` | `5` |
| существующий, пустой | `0` |
| не существует | `error.FileNotFound` |

Лимит `.limited(1 << 16)` — 64 КиБ, для тестов хватает.
