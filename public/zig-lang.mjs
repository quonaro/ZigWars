// Минимальный StreamLanguage-парсер для Zig (подсветка в CodeMirror 6)
import { StreamLanguage } from "https://esm.sh/@codemirror/language@6";

const keywords = new Set((
  "addrspace align allowzero and anyframe anytype asm async await break callconv " +
  "catch comptime const continue defer dyn else enum errdefer error export extern " +
  "fn for if inline linksection noalias noinline nosuspend opaque orelse packed " +
  "pub resume return struct suspend switch test threadlocal try union unreachable " +
  "usingnamespace var volatile while"
).split(" "));

const typeRe = /^[iu](?:8|16|32|64|128|size)$|^(?:f16|f32|f64|f80|f128|c_int|c_uint|c_long|c_ulong|c_char|bool|void|usize|isize|type|noreturn|comptime_int|comptime_float|anyerror)$/;

export const zigLanguage = StreamLanguage.define({
  name: "zig",
  startState() { return { inBlockComment: 0 }; },
  token(stream, state) {
    if (state.inBlockComment > 0) { stream.skipToEnd(); return "comment"; } // zig не имеет /* */ — safety
    if (stream.eatSpace()) return null;
    if (stream.match("//")) { stream.skipToEnd(); return "comment"; }

    if (stream.match(/"(?:[^"\\]|\\.)*"?/)) return "string";
    if (stream.match(/'(?:[^'\\]|\\.)+'/)) return "character";
    if (stream.match(/\\\\[^\n]*/)) return "string"; // multiline string literal \\

    if (stream.match(/@[A-Za-z_]\w*/)) return "macroName";         // @import, @intCast… (tags.builtin нет)
    if (stream.match(/\$[A-Za-z_]\w*/)) return "variableName";

    if (stream.match(/0b[01_]+|0o[0-7_]+|0x[0-9a-fA-F_]+|\d[\d_]*(?:\.\d[\d_]*)?(?:[eE][+-]?\d+)?/))
      return "number";

    const word = stream.match(/[A-Za-z_]\w*/);
    if (word) {
      const w = word[0];
      if (keywords.has(w)) return "keyword";
      if (typeRe.test(w)) return "typeName";
      if (/^[A-Z]/.test(w)) return "typeName";
      if (stream.string[stream.pos] === "(") return "function(variableName)";
      return "variableName";
    }

    if (stream.match(/[+\-*\/%!&|^~=<>?]+/)) return "operator";
    stream.next();
    return null;
  },
  languageData: {
    commentTokens: { line: "//" },
    closeBrackets: { brackets: ["(", "[", "{", "'", '"'] },
    indentOnInput: /^\s*[\}\]\)]$/,
  },
});
