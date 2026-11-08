# Дженерики в Zig — это просто функции

В Zig нет ключевых слов `generic`, `template` или `class<T>`. Вместо этого: **тип — это comptime-значение**, а значит, функция может принимать тип как аргумент и возвращать тип как результат.

```zig
pub fn Stack(comptime T: type) type {
    return struct {
        items: std.ArrayList(T) = .empty,

        pub fn push(self: *@This(), alloc: std.mem.Allocator, item: T) !void {
            try self.items.append(alloc, item);
        }
    };
}
```

`Stack` — обычная функция. Параметр `comptime T: type` — значение типа «тип». Возвращаемое значение `type` — тоже тип. `struct { ... }` — анонимная структура, которую функция «собирает» под конкретный `T`.

## Инстанцирование

```zig
const IntStack = Stack(i32);   // вызов функции при компиляции → тип
var s: IntStack = .{};
// или сразу:
var s2: Stack(i32) = .{};
```

`Stack(i32)` — это вызов функции на этапе компиляции. Каждый уникальный `T` даёт **отдельный тип**: `Stack(i32)` и `Stack(u8)` — разные несовместимые структуры. Компилятор кэширует инстанцирования — `Stack(i32)` в двух файлах будет одним и тем же типом.

## Структура внутри функции

Внутри возвращаемой структуры `T` доступен как обычное имя — поля, параметры методов, всё работает:

- `items: std.ArrayList(T)` — тип параметризован через внешний `T`.
- `push(self: *@This(), ...)` — `@This()` внутри структуры означает «тип этой структуры», удобно когда имя анонимное.
- `ArrayList(T)` — сам `ArrayList` устроен ровно так же: `fn ArrayList(comptime T: type) type`.

## Жизненный цикл

`std.ArrayList` в Zig 0.17 unmanaged — аллокатор передаётся в каждый метод:

```zig
var s: Stack(i32) = .{};
defer s.items.deinit(alloc);          // ArrayList освобождаем через deinit(alloc)

try s.push(alloc, 42);                // alloc — первый аргумент
const top = s.pop();                  // ?T — null, если пусто
```

## Почему так, а не шаблоны?

- **Единый механизм**: тот же comptime, что считает факториалы, строит и типы. Учить одну систему, а не две.
- **Типы можно комбинировать**: `Stack(Stack(i32))` — валидно, это просто вызов от вызова.
- **Нет скрытой магии**: дженерик виден в сигнатуре, ошибки компиляции ведут прямо в тело `struct`.

## Что почитать

- [Zig Language Reference 0.17.1 — Generic Data Structures](https://ziglang.org/documentation/0.17.1/#Generic-Data-Structures)
- [zig.guide — Generics](https://zig.guide/language-basics/generics/)
