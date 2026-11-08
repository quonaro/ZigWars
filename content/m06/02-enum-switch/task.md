## Задание

Реализуй повороты компаса. Перечисления уже объявлены — напиши тела функций.

```zig
pub const Dir = enum { north, east, south, west };

/// Поворот на 90°: .left — против часовой, .right — по часовой.
pub fn turn(d: Dir, side: enum { left, right }) Dir

/// Направление в градусах: north=0, east=90, south=180, west=270.
pub fn toDegrees(d: Dir) u16
```

Порядок по часовой: `north → east → south → west → north`. Поворот `.right` идёт по этому кольцу вперёд, `.left` — назад.

### Примеры

| Вызов | Результат |
|-------|-----------|
| `turn(.north, .right)` | `.east` |
| `turn(.north, .left)` | `.west` |
| `turn(.south, .left)` | `.east` |
| `toDegrees(.west)` | `270` |

Подсказка по стилю: можно решить через `@intFromEnum` + арифметику по модулю 4, а можно честным `switch` на пары `(d, side)` — второй вариант длиннее, но надёжнее. Оба приемлемы.
