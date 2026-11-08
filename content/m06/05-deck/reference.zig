const std = @import("std");

pub const Suit = enum { spades, hearts, diamonds, clubs };

pub const Rank = enum(u8) {
    two = 2,
    three = 3,
    four = 4,
    five = 5,
    six = 6,
    seven = 7,
    eight = 8,
    nine = 9,
    ten = 10,
    jack = 11,
    queen = 12,
    king = 13,
    ace = 14,
};

pub const Card = struct {
    rank: Rank,
    suit: Suit,
};

/// Бьёт ли карта a карту b при козыре trump?
pub fn beats(a: Card, b: Card, trump: Suit) bool {
    if (a.suit == b.suit) {
        return @intFromEnum(a.rank) > @intFromEnum(b.rank);
    }
    return a.suit == trump and b.suit != trump;
}
