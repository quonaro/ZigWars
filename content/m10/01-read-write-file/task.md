## Задание

Реализуй `copyUpper` — прочитай текстовый файл, переведи ASCII-буквы в верхний регистр, запиши в другой файл.

```zig
pub fn copyUpper(io: std.Io, alloc: std.mem.Allocator, src: []const u8, dst: []const u8) !void
```

### Правила

- Читай `src` целиком через `cwd.readFileAlloc` (лимит `.limited(1 << 20)`), память освобождай `alloc.free`.
- Заглавными делай **только** латиницу `a`–`z` (вычти `32` или `std.ascii.toUpper`). Цифры, пробелы, русский текст, UTF-8 байты — не трогай.
- Записывай результат в `dst` через `cwd.createFile` + `f.writeStreamingAll`. Не забудь `f.close(io)`.
- Любые ошибки (нет файла, нет прав) — пробрасывай через `try`.

### Пример

`/tmp/in.txt` содержит `Hello Zig 0.17!` → после вызова `/tmp/out.txt` содержит `HELLO ZIG 0.17!`.

### Полезный API (уже проверен на 0.17)

```zig
const cwd = std.Io.Dir.cwd();
var f = try cwd.createFile(io, path, .{});
try f.writeStreamingAll(io, data);
f.close(io);
const data = try cwd.readFileAlloc(io, path, alloc, .limited(1 << 20));
try cwd.deleteFile(io, path);
```
