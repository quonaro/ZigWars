`cStrLen` — счётчик + `while (s[n] != 0) n += 1;`. Сентинел гарантирует, что цикл остановится.

---

Для `equalZigStr` преврати `a` в слайс через `std.mem.span(a)`, потом сравни `std.mem.eql(u8, ...)`.

---

```zig
pub fn equalZigStr(a: [*:0]const u8, b: []const u8) bool {
    return std.mem.eql(u8, std.mem.span(a), b);
}
```
