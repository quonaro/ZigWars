Сигнатура уже `!usize` — просто пробрасывай ошибки `readFileAlloc` через `try`.

---

`const data = try std.Io.Dir.cwd().readFileAlloc(std.testing.io, path, std.testing.allocator, .limited(1 << 16));`

---

После чтения `defer std.testing.allocator.free(data);` — и верни `data.len`.
