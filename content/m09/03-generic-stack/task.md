## Задание

Реализуй `Stack` — функцию от типа, возвращающую структуру-стек.

```zig
pub fn Stack(comptime T: type) type
```

Возвращаемая структура должна содержать:

- **поле** `items: std.ArrayList(T)` — со значением по умолчанию `.empty`;
- **метод** `push(self: *@This(), alloc: std.mem.Allocator, item: T) !void` — добавить элемент;
- **метод** `pop(self: *@This()) ?T` — снять верхний элемент или `null`, если пуст;
- **метод** `isEmpty(self: *const @This()) bool` — пуст ли стек.

### Примеры

```zig
var s: Stack(i32) = .{};
defer s.items.deinit(alloc);

try s.push(alloc, 1);
try s.push(alloc, 2);
s.pop();       // 2
s.pop();       // 1
s.pop();       // null
s.isEmpty();   // true
```

### Ограничения

- Не пиши отдельные реализации для разных типов — одна функция `Stack` должна работать для `i32`, `u8`, `[]const u8` и любого другого `T`.
- Используй `@This()` в сигнатурах методов, а не имя структуры (её нет — она анонимная).
- `pop` на пустом стеке обязан вернуть `null`, не паниковать.
