# Сортировка в std и идиома dedup

## `std.mem.sort` и компаратор

Сортировка в Zig идёт через функцию-компаратор — предикат «a строго меньше b»:

```zig
fn lessThan(_: void, a: i32, b: i32) bool {
    return a < b;
}

std.mem.sort(i32, items, {}, lessThan);
```

Сигнатура компаратора фиксированная: `fn (context, lhs: T, rhs: T) bool`. Контекст — произвольное значение, прокидываемое третьим аргументом: для простых случаев `{}` и `void` в сигнатуре. Если нужна сортировка по убыванию — компаратор `a > b`; по полю структуры — сравнивай поля.

`std.mem.sort` — это `std.sort.insertion` (устойчивая, отлична на маленьких/почти отсортированных массивах). Более «тяжёлые» варианты в `std.sort`:

- `std.sort.pdq` — pattern-defeating quicksort, O(n log n), нестабильный, дефолтный рабочий конь для больших данных.
- `std.sort.heap` — heapsort, гарантированный O(n log n) без рекурсии.
- `std.sort.insertion` — O(n²), но устойчивый и быстрый на малых n.

Все с одинаковой сигнатурой — меняется только имя.

## Идиома: sort + dedup

Стандартный трюк для «уникальные отсортированные»: скопировать → отсортировать → схлопнуть дубли **in-place**:

```zig
const dup = try alloc.dupe(i32, xs);
std.mem.sort(i32, dup, {}, lessThan);

var w: usize = 0;                 // позиция записи
for (dup) |v| {
    if (w == 0 or dup[w - 1] != v) {
        dup[w] = v;
        w += 1;
    }
}
// в dup[0..w] — уникальные отсортированные
```

Читаем указателем `v`, пишем указателем `w`. Так как `w <=` текущей позиции чтения, перезапись не портит ещё непрочитанные элементы — чистый «two pointers».

## `realloc`: ужать буфер до факта

После dedup хвост `dup[w..]` — мёртвая ёмкость. `alloc.realloc(dup, w)` ужимает срез до фактической длины (обычно in-place для shrink). Возвращает новый срез — **старый после этого не трогай**.

Западня: `alloc.resize` (не `realloc`!) умеет только «на месте» и честно ответит `false`, если аллокатор не может. Тестовый аллокатор часто именно так и делает при shrink — поэтому fallback: `alloc` нового среза + копия + `free` старого, либо `realloc`, который сам умеет переехать.

Ещё один нюанс: освобождать нужно срез **итоговой длины** — `free` у детектирующих аллокаторов проверяет и указатель, и len. Если вернул `dup[0..w]` не ужав аллокацию — `free` упадёт с «free of invalid memory». Поэтому либо `realloc`, либо `toOwnedSlice`, который обрезает capacity до длины сам.

## Как собрать `uniqueSorted`

1. `dupe` входа — мутировать `xs` нельзя, он `const`.
2. `std.mem.sort` — теперь дубли стоят рядом.
3. In-place dedup в `dup[0..w]`.
4. `realloc` до `w` (или `alloc` + `@memcpy` + `free` если realloc не сработал) → `return`.

Краевые случаи: пустой вход → пустой срез (realloc до 0 работает), все дубли → срез длины 1.

## Что почитать

- [std 0.17.1 — std.mem.sort](https://ziglang.org/documentation/0.17.1/std/#std.mem.sort)
- [std 0.17.1 — std.sort](https://ziglang.org/documentation/0.17.1/std/#std.sort)
- [std 0.17.1 — std.mem.Allocator.realloc](https://ziglang.org/documentation/0.17.1/std/#std.mem.Allocator.realloc)
