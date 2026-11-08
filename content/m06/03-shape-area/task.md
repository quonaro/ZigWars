## Задание

Дан размеченный union `Shape`. Реализуй `area` — площадь фигуры.

```zig
pub const Shape = union(enum) {
    circle: f64,                    // радиус
    rect: struct { w: f64, h: f64 },// стороны
    square: f64,                    // сторона
};

/// Площадь фигуры.
pub fn area(s: Shape) f64
```

- `circle` → `π · r²` (используй `std.math.pi`)
- `rect` → `w · h`
- `square` → `a²`

Один `switch` с захватом payload через `|v|` — и задача решена.

### Примеры

| Вызов | Результат |
|-------|-----------|
| `area(.{ .circle = 1 })` | `π ≈ 3.14159…` |
| `area(.{ .rect = .{ .w = 3, .h = 4 } })` | `12.0` |
| `area(.{ .square = 5 })` | `25.0` |
