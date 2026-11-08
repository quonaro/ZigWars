## Задание

Реализуй `countVowels` — счётчик строчных ASCII-гласных (`a`, `e`, `i`, `o`, `u`) в строке.

```zig
pub fn countVowels(s: []const u8) usize
```

### Примеры

| Вызов | Результат |
|-------|-----------|
| `countVowels("zig")` | `1` |
| `countVowels("hello")` | `2` |
| `countVowels("rhythm")` | `0` |
| `countVowels("")` | `0` |
| `countVowels("AEIOU")` | `0` — заглавные **не** считаем |
| `countVowels("мама")` | `0` — русские буквы не в списке |

Учитываются только строчные `a e i o u` — байты `0x61`, `0x65`, `0x69`, `0x6F`, `0x75`.
