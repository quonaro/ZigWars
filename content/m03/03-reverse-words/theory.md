# Разбиваем и собираем строки

## Зачем аллокатор

До сих пор функции возвращали числа и булевы — они живут в регистрах и на стеке. Но строка «слова в обратном порядке» — новая память, размер которой известен только в рантайме. Откуда её взять? У **аллокатора** — объекта, который выдаёт и забирает память.

В Zig нет сборщика мусора и нет глобального `malloc` по умолчанию: аллокатор передают **явным параметром**. Сигнатура `fn f(alloc: std.mem.Allocator, ...) ![]u8` читается как «функции понадобится память, вернёт она выделенный слайс или ошибку». Кто выделил — того и ответственность освободить: твоя функция выделяет, вызывающий освобождает через `alloc.free(result)`.

```zig
const alloc = std.testing.allocator;      // тестовый: сам ловит утечки
const s = try reverseWords(alloc, "a b");
defer alloc.free(s);                      // без этого тест упадёт с leak
```

Подробнее про аллокаторы — модуль 7. Сейчас достаточно: пришёл `alloc`, корми его в std-функции.

## `tokenize` vs `split`

Разбить строку на слова — итератором:

```zig
var it = std.mem.tokenizeScalar(u8, "  a  b c ", ' ');
while (it.next()) |word| {
    // word: []const u8 — слайс ИСХОДНОЙ строки, копий нет
}
// a, b, c — пустые куски пропускаются
```

`tokenizeScalar` пропускает повторяющиеся разделители — идеален для слов. Его брат `splitScalar` выдаёт **все** куски, включая пустые (`"a,,b"` → `a`, ``, `b`) — он нужен для CSV и точного парсинга. Ещё есть `tokenizeAny`/`tokenizeSequence` для набора разделителей и разделителя-строки.

## `std.ArrayList` — unmanaged

В Zig 0.17 `ArrayList` — **unmanaged**: сам не хранит аллокатор, тот передаётся в каждый метод:

```zig
var list: std.ArrayList(u8) = .empty;     // нет .init(alloc)!
defer list.deinit(alloc);
try list.append(alloc, 'x');
try list.appendSlice(alloc, "yz");
list.items                               // текущий слайс элементов
```

Нам нужен список **строк**: `std.ArrayList([]const u8)` — соберём туда слова.

## Переворот и склейка

```zig
std.mem.reverse([]const u8, words.items);  // переворот слайса на месте

const out = try std.mem.join(alloc, " ", words.items);
// join выделит ровно нужный буфер и склеит сепаратором — вернёт []u8
```

`std.mem.join` возвращает владение вызывающему — это и есть наш результат. Обрати внимание: `join` делегирует аллокатору ровно один `alloc`, никаких временных буферов.

## План решения

1. `tokenizeScalar` → собрать слова в `ArrayList([]const u8)`.
2. `std.mem.reverse` списка.
3. `std.mem.join(alloc, " ", items)` → результат.

Края: пустая строка → ноль слов → `join` вернёт пустой слайс. Повторные пробелы и пробелы по краям `tokenize` схлопнет сам — результат нормализуется к одинарным пробелам.

## Что почитать

- [Langref 0.17.1 — Allocators](https://ziglang.org/documentation/0.17.1/#Allocators)
- [std.mem](https://ziglang.org/documentation/0.17.1/std/#std.mem)
- [std.ArrayList](https://ziglang.org/documentation/0.17.1/std/#std.ArrayList)
