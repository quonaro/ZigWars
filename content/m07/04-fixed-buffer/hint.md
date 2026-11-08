`std.heap.FixedBufferAllocator.init(buf)` принимает срез `[]u8` и даёт `.allocator()`. Дальше любая аллоцирующая функция умеет писать в твой буфер.

---

```zig
var fba = std.heap.FixedBufferAllocator.init(buf);
return std.mem.concat(fba.allocator(), u8, &.{ a, b });
```

Или вручную: проверка длины + два `@memcpy` + `return buf[0..a.len + b.len];`
