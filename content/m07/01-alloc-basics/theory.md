# Аллокатор — сердце Zig

## Зачем вообще аллокатор?

В большинстве языков выделение памяти спрятано: `new`, `make`, конструктор списка — память берётся «откуда-то». В Zig всё наоборот: **любой код, которому нужна память из кучи, получает аллокатор явным параметром**. Нет глобального `malloc` за кулисами.

`std.mem.Allocator` — это интерфейс (vtable с методами `alloc`/`resize`/`remap`/`free`). Конкретные реализации: `std.heap.page_allocator`, `DebugAllocator`, `ArenaAllocator`, `FixedBufferAllocator` — о них в следующих kata.

## Три операции, которые нужны в 90% случаев

```zig
const alloc = std.heap.page_allocator; // или любой другой

// выделить срез из n элементов
const buf = try alloc.alloc(u8, 1024);
defer alloc.free(buf);            // free получает тот же срез

// скопировать существующий срез в новую память
const copy = try alloc.dupe(u8, "hello");
defer alloc.free(copy);

// строка в куче
const s = try alloc.print("число: {d}", .{42});
defer alloc.free(s);
```

Всё это возвращает `!T` — выделение может обвалиться с `error.OutOfMemory`, и Zig заставляет это обработать (или честно пробросить `try`).

## Владение: кто освобождает?

Контракт простой: **тот, кто получил срез из функции, владеет им и обязан освободить**. Поэтому сигнатуры вида

```zig
pub fn dupSlice(alloc: std.mem.Allocator, xs: []const i32) ![]i32
```

читаются так: «дайте мне аллокатор и данные — верну вам новый буфер, за освобождение которого отвечаете вы».

Важно: `free` нужен **тот же срез** — тот же указатель и та же длина, что вернул `alloc`/`dupe`. Отдать `buf[0..3]` вместо `buf[0..10]` — баг, который детекторы памяти ловят мгновенно.

## `defer` — лучший друг памяти

Память освобождается при выходе из области видимости:

```zig
fn work(alloc: std.mem.Allocator) !void {
    const tmp = try alloc.alloc(u8, 256);
    defer alloc.free(tmp);   // выполнится при любом выходе — и по return, и по ошибке
    // ... работаем ...
}
```

Это заменяет и деструкторы, и `finally`. Правило большого пальца: `defer free` пишется **сразу под успешным выделением** — тогда его невозможно забыть.

## Тестовый аллокатор

В тестах используй `std.testing.allocator` — это `DebugAllocator`, который на выходе из теста проверяет, что всё выделенное освобождено. Утечка = красный тест. Удобно: забытый `free` ловится автоматически.

## Что почитать

- [Langref 0.17.1 — Memory](https://ziglang.org/documentation/0.17.1/#Memory)
- [std 0.17.1 — std.mem.Allocator](https://ziglang.org/documentation/0.17.1/std/#std.mem.Allocator)
- [Langref 0.17.1 — defer](https://ziglang.org/documentation/0.17.1/#defer)
