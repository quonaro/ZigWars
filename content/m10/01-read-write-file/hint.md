Читай через `cwd.readFileAlloc(io, src, alloc, .limited(1 << 20))` — вернёт `[]u8`, который нужно освободить. Регистр: `if (c >= 'a' and c <= 'z') c -= 32;` — итерируй `for (data) |*c|`, чтобы менять байты на месте.

---

Запись: `var f = try cwd.createFile(io, dst, .{}); defer f.close(io); try f.writeStreamingAll(io, data);`

---

```zig
const data = try cwd.readFileAlloc(io, src, alloc, .limited(1 << 20));
defer alloc.free(data);
for (data) |*c| {
    if (c.* >= 'a' and c.* <= 'z') c.* -= 32;
}
```
