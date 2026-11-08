`comptimeSquare` — однострочник: параметр уже помечен `comptime`, осталось вернуть произведение.

---

Для факториала заведи `comptime var result: u64 = 1` и `comptime var i: u32 = 2`, затем `inline while (i <= n)` — обычный `while` не может писать в `comptime var`.

---

```zig
pub fn comptimeFactorial(comptime n: u32) u64 {
    comptime var result: u64 = 1;
    comptime var i: u32 = 2;
    inline while (i <= n) : (i += 1) result *= i;
    return result;
}
```
