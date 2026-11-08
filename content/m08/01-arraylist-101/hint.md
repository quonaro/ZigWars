`var list: std.ArrayList(u64) = .empty;` — инициализация. `try list.append(alloc, v)` — добавить. `try list.toOwnedSlice(alloc)` — отдать буфер наружу.

---

`i` из `for (0..n)` имеет тип `usize`. Чтобы получить `u64`: `const x: u64 = @intCast(i);`, потом `x * x`.

---

```zig
var list: std.ArrayList(u64) = .empty;
defer list.deinit(alloc);
for (0..n) |i| {
    const x: u64 = @intCast(i);
    try list.append(alloc, x * x);
}
return list.toOwnedSlice(alloc);
```
