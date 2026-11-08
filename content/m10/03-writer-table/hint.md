`var aw: std.Io.Writer.Allocating = .init(alloc);` — запись через `aw.writer.writeAll(...)` и `aw.writer.print("{s}", .{x})`. В конце `return try aw.toOwnedSlice();`.

---

Сначала посчитай `w0 = max` длину ключа `r[0].len` по всем строкам. Затем для каждой строки: `writeAll(r[0])` + `w0 - r[0].len` пробелов + `print(" | {s}\n", .{r[1]})`.

---

```zig
var aw: std.Io.Writer.Allocating = .init(alloc);
defer aw.deinit();
// ... писать в aw.writer
return try aw.toOwnedSlice();
```
