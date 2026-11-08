Для `startsWithZ` загляни в `std.mem` — там есть готовая проверка префикса. Для `lastChar` сначала проверь `s.len == 0`, иначе `s[s.len - 1]` — выход за границу.

---

`std.mem.startsWith(u8, s, "Z")` сам проверяет длину и сравнивает байты — короче, чем `s.len > 0 and s[0] == 'Z'`.

---

```zig
pub fn lastChar(s: []const u8) ?u8 {
    if (s.len == 0) return null;
    return s[s.len - 1];
}
```
