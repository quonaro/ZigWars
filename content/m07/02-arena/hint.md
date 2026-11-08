Нужно выделить срез из `n` элементов типа `usize` и заполнить его. Метод — `arena_alloc.alloc(usize, n)`.

---

`for (xs, 0..) |*x, i|` итерируется по элементам с индексом; `x.* = ...` пишет в элемент.

---

```zig
const xs = try arena_alloc.alloc(usize, n);
for (xs, 0..) |*x, i| x.* = i * i;
return xs;
```
