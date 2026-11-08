Каркас — `switch (@typeInfo(T))` с тегами `.int`, `.float`, `.bool`, `.pointer`, `else`. Строки собирай `std.fmt.comptimePrint("...", .{...})`.

---

В `.int` у `info` есть `signedness` (`.signed`/`.unsigned`) и `bits`. В `.pointer` — `size` (`.slice` отличает `[]T` от `*T`) и `child`.

---

```zig
.int => |info| switch (info.signedness) {
    .signed => std.fmt.comptimePrint("знаковое целое, {d} бит", .{info.bits}),
    .unsigned => std.fmt.comptimePrint("беззнаковое целое, {d} бит", .{info.bits}),
},
```
