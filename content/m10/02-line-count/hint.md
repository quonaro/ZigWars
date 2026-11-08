Прочитай файл в `data`, освободи через `defer alloc.free(data)`. Базовое число строк — `std.mem.count(u8, data, "\n")`.

---

Плюс один нужен, только если `data.len > 0` и последний байт `data[data.len - 1] != '\n'`.

---

```zig
if (data.len == 0) return 0;
var lines = std.mem.count(u8, data, "\n");
if (data[data.len - 1] != '\n') lines += 1;
return lines;
```
