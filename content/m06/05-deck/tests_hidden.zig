const std = @import("std");
const sol = @import("solution.zig");

fn card(rank: sol.Rank, suit: sol.Suit) sol.Card {
    return .{ .rank = rank, .suit = suit };
}

const suits = [_]sol.Suit{ .spades, .hearts, .diamonds, .clubs };
const ranks = [_]sol.Rank{ .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king, .ace };

test "в одной масти бьёт только старший — вся таблица" {
    for (suits) |s| {
        for (ranks) |ra| {
            for (ranks) |rb| {
                const want = @intFromEnum(ra) > @intFromEnum(rb);
                // козырь здесь не влияет: масти равны
                try std.testing.expectEqual(want, sol.beats(card(ra, s), card(rb, s), s));
            }
        }
    }
}

test "любой козырь бьёт любой некозырь — вся таблица" {
    for (suits) |t| {
        for (suits) |s| {
            if (s == t) continue;
            for (ranks) |ra| {
                for (ranks) |rb| {
                    try std.testing.expect(sol.beats(card(ra, t), card(rb, s), t));
                    try std.testing.expect(!sol.beats(card(rb, s), card(ra, t), t));
                }
            }
        }
    }
}

test "beats антисимметричен — обе карты не бьют друг друга" {
    const few_ranks = [_]sol.Rank{ .two, .seven, .jack, .ace };
    for (suits) |t| {
        for (suits) |sa| {
            for (suits) |sb| {
                for (few_ranks) |ra| {
                    for (few_ranks) |rb| {
                        const ab = sol.beats(card(ra, sa), card(rb, sb), t);
                        const ba = sol.beats(card(rb, sb), card(ra, sa), t);
                        try std.testing.expect(!(ab and ba));
                    }
                }
            }
        }
    }
}

test "две некозырные масти — false при любом старшинстве" {
    for (suits) |t| {
        for (suits) |sa| {
            for (suits) |sb| {
                if (sa == t or sb == t or sa == sb) continue;
                try std.testing.expect(!sol.beats(card(.ace, sa), card(.two, sb), t));
                try std.testing.expect(!sol.beats(card(.two, sa), card(.ace, sb), t));
            }
        }
    }
}
