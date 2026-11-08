Поле `items` уже есть. `push` — это `try self.items.append(alloc, item);` (аллокатор первым аргументом).

---

`pop` делегируй методу `ArrayList`: `self.items.pop()` уже возвращает `?T`. Для `isEmpty` проверь `self.items.items.len`.

---

```zig
pub fn pop(self: *@This()) ?T {
    return self.items.pop();
}
```
