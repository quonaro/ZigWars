Разбей на два случая: `a.suit == b.suit` → сравнивай `@intFromEnum(a.rank)` с `@intFromEnum(b.rank)`; иначе — проверяй козырь.

---

При разных мастях `a` выигрывает ровно тогда, когда `a.suit == trump and b.suit != trump`. Если `b` тоже козырь — это уже «одна масть» по смыслу и обрабатывается первой веткой.

---

```zig
if (a.suit == b.suit) {
    return @intFromEnum(a.rank) > @intFromEnum(b.rank);
}
return a.suit == trump and b.suit != trump;
```
