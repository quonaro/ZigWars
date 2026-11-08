`std.StringHashMap(void)` — множество строк. `put(word, {})` добавляет; повторный `put` того же слова ничего не меняет. Ответ — `map.count()`.

---

Слова даёт `std.mem.tokenizeAny(u8, s, " \t\n")` — итерируй `while (it.next()) |word|`.

---

```zig
var set = std.StringHashMap(void).init(alloc);
defer set.deinit();
var it = std.mem.tokenizeAny(u8, s, " \t\n");
while (it.next()) |w| try set.put(w, {});
return set.count();
```
