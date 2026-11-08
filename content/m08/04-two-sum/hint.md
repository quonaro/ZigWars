Идёшь слева направо, для `xs[i]` ищешь `target - xs[i]` среди уже виденных значений — значит, мапа «значение → индекс».

---

`seen.get(target - x)` вернёт `?usize`. Если нашёл `j` — пара `.{j, i}` готова (j обязательно раньше i). Не нашёл — `try seen.put(x, i)` и дальше.

---

```zig
var seen = std.AutoHashMap(i32, usize).init(alloc);
defer seen.deinit();
for (xs, 0..) |x, i| {
    if (seen.get(target - x)) |j| return .{ j, i };
    try seen.put(x, i);
}
return null;
```
