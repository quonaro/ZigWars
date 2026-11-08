## Задание

Реализуй `concatFixed` — склейку двух строк в предоставленный буфер.

```zig
pub fn concatFixed(buf: []u8, a: []const u8, b: []const u8) ![]u8
```

### Правила

- Пиши в начало `buf` и верни `buf[0..a.len + b.len]`.
- Если данных больше, чем помещается в `buf` — верни `error.OutOfMemory` (так же отвечает `FixedBufferAllocator`).
- Можно решить через `std.heap.FixedBufferAllocator` + `std.mem.concat`, а можно вручную через `@memcpy` — оба варианта принимаются, главное контракт.

### Примеры

| `buf` | `a` | `b` | Результат |
|-------|-----|-----|-----------|
| `[64]u8` | `"foo"` | `"bar"` | `"foobar"` |
| `[5]u8` | `"abc"` | `"def"` | `error.OutOfMemory` |
| `[8]u8` | `""` | `"x"` | `"x"` |
