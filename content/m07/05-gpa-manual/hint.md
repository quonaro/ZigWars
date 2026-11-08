Два прохода: первым циклом посчитай, сколько элементов удовлетворяют `pred`, потом `alloc.alloc(i32, n)` и вторым циклом запиши их.

---

Второй индекс-писатель: `var w: usize = 0;` — увеличивай только когда записал элемент.

---

```zig
var n: usize = 0;
for (xs) |x| if (pred(x)) n += 1;
const out = try alloc.alloc(i32, n);
var w: usize = 0;
for (xs) |x| if (pred(x)) {
    out[w] = x;
    w += 1;
};
return out;
```
