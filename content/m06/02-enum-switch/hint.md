`toDegrees` — это `switch (d)` с четырьмя стрелками, прямо `return switch (d) { ... };`.

---

Для `turn` удобно перевести направление в число: `@intFromEnum(d)` даст 0..3. Поворот вправо — `+1`, влево — `+3` (то же, что `-1` без отрицательных чисел).

---

```zig
const i: u8 = @intFromEnum(d);
const j: u8 = switch (side) {
    .right => @mod(i + 1, 4),
    .left => @mod(i + 3, 4),
};
return @enumFromInt(j);
```

Альтернатива без арифметики — вложенный `switch`: `switch (side) { .right => switch (d) {...}, .left => ... }`.
