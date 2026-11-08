Попробуй цепочку `if … else if … else` — в Zig она сама возвращает значение, можно сразу `return`.

---

```zig
return if (x < lo) lo else if (x > hi) hi else x;
```

Альтернатива: `@min(@max(x, lo), hi)` — тоже одна строка.
