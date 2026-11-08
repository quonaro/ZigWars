# ArrayList: динамический массив по-зиговски

## Unmanaged — что это значит

В Zig 0.17 `std.ArrayList(T)` — это **unmanaged**-список: он **не хранит** аллокатор внутри себя. Поэтому каждый метод, которому может понадобиться память, принимает аллокатор первым аргументом:

```zig
var list: std.ArrayList(u64) = .empty;   // не init(alloc)!
defer list.deinit(alloc);

try list.append(alloc, 42);              // alloc — первым аргументом
try list.appendSlice(alloc, &.{1, 2, 3});
const owned = try list.toOwnedSlice(alloc);
```

Когда-то существовала «managed»-версия (`ArrayList.init(alloc)`, методы без аллокатора). От неё отказались: спрятанный аллокатор — это спрятанная стоимость. Теперь на каждый `append` ты видишь, откуда берётся память, а одна и та же структура данных может переиспользовать разные аллокаторы в разных операциях.

## Модель памяти

У списка есть `items` (видимые элементы) и `capacity` (сколько места выделено). `append` пишет в `items` и при нехватке места делает реаллокацию с ростом ~вдвое — амортизированный O(1). `toOwnedSlice(alloc)` «отдаёт» буфер наружу: обрезает ёмкость до длины и передаёт владение тебе. После него `deinit` делать **не нужно** — список пуст, а срез освобождается через `alloc.free`.

```zig
var list: std.ArrayList(u64) = .empty;
try list.append(alloc, 1);
try list.append(alloc, 2);

list.items;      // []u64 — текущее содержимое
list.items.len;  // 2
list.last();     // ?u64 — последний элемент или null
const x = list.pop();  // ?u64 — снял последний
```

## Типичный жизненный цикл

```zig
var list: std.ArrayList(T) = .empty;
defer list.deinit(alloc);          // страховка на все пути выхода

// ... append'ы ...

return try list.toOwnedSlice(alloc); // владение ушло вызывающему —
                                     // deinit выше безопасен, он ничего не освободит
```

`deinit` + `toOwnedSlice` вместе — не двойной free: `toOwnedSlice` забирает буфер и обнуляет список. Если же результат не «отдаётся», `deinit` прибирает всё.

## Когда нужен `toOwnedSlice`

Когда функция должна вернуть срез фиксированной длины, а собирался он постепенно — `toOwnedSlice` делает «финальный монтаж»: вызывающий получает чистый `[]T` без лишней ёмкости и может освободить его одним `free`.

## Частые ошибки

- `list.append(x)` — забыл аллокатор: не скомпилируется, и хорошо.
- `var list: std.ArrayList(T) = .init(alloc)` — managed-стиль мёртв.
- `list.getLast()` — метода больше нет: `list.last()` возвращает `?T`.
- Держать указатель/`items` через `append`: реаллокация инвалидирует старый `items` — читай его заново после добавлений.

## Что почитать

- [std 0.17.1 — std.ArrayList](https://ziglang.org/documentation/0.17.1/std/#std.ArrayList)
- [std 0.17.1 — std.mem.Allocator](https://ziglang.org/documentation/0.17.1/std/#std.mem.Allocator)
