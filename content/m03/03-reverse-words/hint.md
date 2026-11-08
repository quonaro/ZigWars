План: собрать слова в список → перевернуть список → склеить через пробел. Разбивай `std.mem.tokenizeScalar(u8, s, ' ')` — он сам пропускает повторные пробелы.

---

```zig
var words: std.ArrayList([]const u8) = .empty;
defer words.deinit(alloc);
var it = std.mem.tokenizeScalar(u8, s, ' ');
while (it.next()) |w| try words.append(alloc, w);
```

---

```zig
std.mem.reverse([]const u8, words.items);
return std.mem.join(alloc, " ", words.items);
```

`join` выделит буфер и вернёт `[]u8` — это и есть результат, его освобождает вызывающий.
