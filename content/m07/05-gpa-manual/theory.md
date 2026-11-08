# DebugAllocator и как выбирать аллокатор

## DebugAllocator (бывший GPA)

`std.heap.DebugAllocator(.{})` — «параноидальный» аллокатор для разработки. Вне тестов его поднимают вручную:

```zig
var gpa: std.heap.DebugAllocator(.{}) = .init;
defer _ = gpa.deinit();
const alloc = gpa.allocator();
```

Что он умеет сверх обычного:

- **Утечки**: `deinit()` возвращает `.leak` и печатает стектрейсы аллокаций, которым не нашлось `free`.
- **Двойной free / free чужого среза**: мгновенная паника с диагностикой.
- **Use-after-free**: освобождённая память заполняется мусором (`0xaa`), обращение к ней быстро падает.
- **Out-of-bounds** в конце аллокации: канареечные байты ловят запись «чуть за краем».

Цена — скорость и расход памяти. В ReleaseFast DebugAllocator всё ещё работает, но медленнее оптимизированных аллокаторов; в проде его часто заменяют на `std.heap.smp_allocator` или `c_allocator` (при линковке libc).

`std.testing.allocator` — это тот же DebugAllocator, поднятый тест-раннером. Поэтому утечки в тестах валятся сами.

## Меняем размер: `resize` и `realloc`

```zig
const buf = try alloc.alloc(i32, 100);
// resize — попытаться изменить размер НА МЕСТЕ; вернёт false, если не вышло
if (alloc.resize(buf, 50)) {
    // buf[0..50] теперь корректен
}
// realloc — изменить размер, разрешено переехать в другое место
const buf2 = try alloc.realloc(buf, 200);
```

`realloc` может переместить данные — старый указатель после него использовать нельзя. Тонкость тестового аллокатора: после уменьшения размера освобождать нужно **срез новой длины** — `free` проверяет и указатель, и размер.

## Выбор аллокатора: шпаргалка

| Ситуация | Аллокатор |
|---|---|
| Тест | `std.testing.allocator` |
| Много временных объектов с общим концом жизни | `ArenaAllocator` |
| Нет кучи / жёсткий лимит / горячий путь | `FixedBufferAllocator` |
| Большие редкие блоки (страницы) | `std.heap.page_allocator` |
| Долгоживущая разнородная память в проде | `smp_allocator`, `c_allocator` |
| Отладка утечек и порчи памяти | `DebugAllocator` |

Главная идея Zig: **функция не выбирает аллокатор — его выбирает вызывающий**. Одна и та же `filterAlloc` может работать и на арене, и на FBA, и на GPA — в зависимости от контекста. Поэтому API принимает `std.mem.Allocator` параметром, а не прячет `malloc` внутри.

## Паттерн «два прохода»

Когда размер результата заранее неизвестен, есть два пути: `ArrayList` (следующий модуль!) или два прохода — сначала посчитать, потом выделить ровно столько и заполнить. Второй путь делает ровно одну аллокацию и не держит лишней ёмкости:

```zig
var n: usize = 0;
for (xs) |x| n += @intFromBool(pred(x));
const out = try alloc.alloc(i32, n);
var w: usize = 0;
for (xs) |x| if (pred(x)) { out[w] = x; w += 1; };
return out;
```

## Что почитать

- [std 0.17.1 — std.heap.DebugAllocator](https://ziglang.org/documentation/0.17.1/std/#std.heap.DebugAllocator)
- [std 0.17.1 — std.mem.Allocator](https://ziglang.org/documentation/0.17.1/std/#std.mem.Allocator)
- [Langref 0.17.1 — Memory](https://ziglang.org/documentation/0.17.1/#Memory)
