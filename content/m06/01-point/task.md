## Задание

Допиши структуру `Point` и функцию `distance`. Скелет уже дан — реализуй тела, помеченные `// TODO`.

```zig
pub const Point = struct {
    x: f64,
    y: f64,

    /// Сложение векторов: новая точка (x + other.x, y + other.y).
    pub fn add(self: Point, other: Point) Point
};

/// Евклидово расстояние между точками a и b.
pub fn distance(a: Point, b: Point) f64
```

- `add` — метод: вызывается как `p.add(q)` и **не изменяет** `self`.
- `distance` — свободная функция: `sqrt((a.x - b.x)² + (a.y - b.y)²)`. Используй `@sqrt` или `std.math.sqrt`.

### Примеры

| Вызов | Результат |
|-------|-----------|
| `distance(.{ .x = 0, .y = 0 }, .{ .x = 3, .y = 4 })` | `5.0` |
| `Point{ .x = 1, .y = 2 }.add(.{ .x = 10, .y = -5 })` | `Point{ .x = 11, .y = -3 }` |
| `distance(p, p)` | `0.0` |
