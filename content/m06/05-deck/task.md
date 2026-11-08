## Задание

Мини-модель карточной игры. Типы объявлены — реализуй `beats`.

```zig
pub const Suit = enum { spades, hearts, diamonds, clubs };

pub const Rank = enum(u8) {
    two = 2, three = 3, four = 4, five = 5, six = 6, seven = 7,
    eight = 8, nine = 9, ten = 10,
    jack = 11, queen = 12, king = 13, ace = 14,
};

pub const Card = struct {
    rank: Rank,
    suit: Suit,
};

/// Бьёт ли карта a карту b при козыре trump?
pub fn beats(a: Card, b: Card, trump: Suit) bool
```

Правила:

- **Одинаковая масть**: бьёт та, у которой rank старше (`@intFromEnum` даёт 2..14).
- **Разные масти**: `a` бьёт `b` только если `a.suit == trump` и `b.suit != trump`.
- Козырь против козыря — обычное сравнение старшинства (у них «одна масть» по смыслу: `a.suit == b.suit`).
- Равные карты (одна масть, один rank): `a` не бьёт `b` — строгое `>`.

### Примеры

| Вызов | Результат |
|-------|-----------|
| `beats(♠A, ♠K, ♥)` | `true` — старше в своей масти |
| `beats(♦2, ♠A, ♥)` | `false` — чужая масть, не козырь |
| `beats(♥2, ♠A, ♥)` | `true` — козырная двойка бьёт некозырного туза |
| `beats(♥2, ♥A, ♥)` | `false` — туз старше даже среди козырей |
