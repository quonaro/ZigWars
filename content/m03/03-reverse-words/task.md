## Задание

Реализуй `reverseWords` — переворот порядка слов в строке. Слова разделены пробелами.

```zig
pub fn reverseWords(alloc: std.mem.Allocator, s: []const u8) ![]u8
```

Возвращаемый слайс выделен через `alloc` — вызывающий освобождает его через `alloc.free`.

### Примеры

| Вызов | Результат |
|-------|-----------|
| `reverseWords(a, "hello zig")` | `"zig hello"` |
| `reverseWords(a, "one")` | `"one"` |
| `reverseWords(a, "")` | `""` |
| `reverseWords(a, "  a  b ")` | `"b a"` — лишние пробелы схлопываются |

Нормализация: в результате слова разделены ровно одним пробелом.
