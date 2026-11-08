const std = @import("std");
const sol = @import("solution.zig");
const Card = sol.Card;

fn card(rank: sol.Rank, suit: sol.Suit) Card {
    return .{ .rank = rank, .suit = suit };
}

test "одна масть — решает старшинство" {
    try std.testing.expect(sol.beats(card(.ace, .spades), card(.king, .spades), .hearts));
    try std.testing.expect(sol.beats(card(.ten, .diamonds), card(.six, .diamonds), .clubs));
    try std.testing.expect(!sol.beats(card(.seven, .clubs), card(.queen, .clubs), .spades));
}

test "равные карты не бьют друг друга" {
    const a = card(.jack, .hearts);
    try std.testing.expect(!sol.beats(a, a, .clubs));
    try std.testing.expect(!sol.beats(a, a, .hearts));
}

test "козырь бьёт некозырь при разных мастях" {
    try std.testing.expect(sol.beats(card(.two, .hearts), card(.ace, .spades), .hearts));
    try std.testing.expect(sol.beats(card(.six, .clubs), card(.king, .diamonds), .clubs));
}

test "некозырь козыря не бьёт" {
    try std.testing.expect(!sol.beats(card(.ace, .spades), card(.two, .hearts), .hearts));
    try std.testing.expect(!sol.beats(card(.ace, .clubs), card(.seven, .diamonds), .diamonds));
}

test "козырь против козыря — старшинство" {
    try std.testing.expect(sol.beats(card(.ace, .hearts), card(.nine, .hearts), .hearts));
    try std.testing.expect(!sol.beats(card(.eight, .hearts), card(.ace, .hearts), .hearts));
}

test "разные некозырные масти — ничья для a" {
    try std.testing.expect(!sol.beats(card(.ace, .spades), card(.two, .diamonds), .hearts));
}
