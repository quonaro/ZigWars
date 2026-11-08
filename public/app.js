import { EditorView, keymap, lineNumbers, highlightActiveLine } from "https://esm.sh/@codemirror/view@6";
import { EditorState } from "https://esm.sh/@codemirror/state@6";
import { defaultKeymap, history, historyKeymap, indentWithTab } from "https://esm.sh/@codemirror/commands@6";
import { bracketMatching, indentOnInput, syntaxHighlighting, HighlightStyle } from "https://esm.sh/@codemirror/language@6";
import { tags as t } from "https://esm.sh/@lezer/highlight@1";
import { closeBrackets } from "https://esm.sh/@codemirror/autocomplete@6";
import { lintGutter, setDiagnostics } from "https://esm.sh/@codemirror/lint@6";
import { zigLanguage } from "/zig-lang.mjs";
import { marked } from "https://esm.sh/marked@12";

const $ = (s) => document.querySelector(s);

// приглушённая подсветка под «field manual» тему
const zwHighlight = HighlightStyle.define([
  { tag: t.keyword, color: "#e0a458" },
  { tag: [t.typeName, t.className], color: "#8fc1d4" },
  { tag: [t.string, t.character], color: "#a8c98a" },
  { tag: [t.number, t.bool, t.null], color: "#d9a5c0" },
  { tag: [t.comment, t.lineComment, t.blockComment], color: "#75808f", fontStyle: "italic" },
  { tag: [t.function(t.variableName), t.function(t.propertyName)], color: "#e8dfc8" },
  { tag: t.propertyName, color: "#e8dfc8" },
  { tag: t.variableName, color: "#dce1ea" },
  { tag: t.definition(t.variableName), color: "#dce1ea" },
  { tag: [t.operator, t.punctuation], color: "#9aa4b6" },
  { tag: t.macroName, color: "#c4a6d4" },
  { tag: t.special(t.string), color: "#e0a458" },
  { tag: t.standard(t.variableName), color: "#c4a6d4" },
  { tag: t.macroName, color: "#c4a6d4" },
]);

const mkEditor = (el, doc, { readOnly = false } = {}) => new EditorView({
  state: EditorState.create({
    doc,
    extensions: [
      EditorView.editable.of(!readOnly),
      EditorState.readOnly.of(readOnly),
      lineNumbers(), history(), indentOnInput(), bracketMatching(), closeBrackets(),
      highlightActiveLine(), zigLanguage,
      ...(readOnly ? [] : [lintGutter()]),
      syntaxHighlighting(zwHighlight, { fallback: true }),
      keymap.of([indentWithTab, ...defaultKeymap, ...historyKeymap]),
      EditorView.theme({ "&": { height: "100%" }, ".cm-scroller": { overflow: "auto" } }),
    ],
  }),
  parent: el,
});

let state = { modules: [], flat: [], current: null, solvedSet: new Set() };

const edSolution = mkEditor($("#editor-solution"), "// загрузка…\n");
const edTests = mkEditor($("#editor-tests"), "// загрузка…\n", { readOnly: true });

const setDoc = (view, text) =>
  view.dispatch({ changes: { from: 0, to: view.state.doc.length, insert: text } });
const getDoc = (view) => view.state.doc.toString();

// ---------- загрузка данных ----------
async function loadModules() {
  const { modules } = await fetch("/api/modules").then((r) => r.json());
  state.modules = modules;
  state.flat = modules.flatMap((m) => m.katas.map((k) => ({ module: m.id, ...k })));
  state.solvedSet = new Set(state.flat.filter((k) => k.solved).map((k) => `${k.module}/${k.dir}`));
  renderSidebar();
  updateGlobalProgress();
}

function renderSidebar() {
  const nav = $("#sidebar");
  const prevScroll = nav.scrollTop;
  nav.innerHTML = "";
  for (const m of state.modules) {
    const h = document.createElement("div");
    h.className = "module-head";
    const done = m.katas.filter((k) => state.solvedSet.has(`${m.id}/${k.dir}`)).length;
    h.innerHTML = `<span>${escapeHtml(m.title)}</span><span class="mp">${done}/${m.katas.length}</span>`;
    nav.appendChild(h);
    for (const k of m.katas) {
      const el = document.createElement("div");
      const key = `${m.id}/${k.dir}`;
      const solved = state.solvedSet.has(key);
      el.className = "kata-item" + (solved ? " solved" : "") +
        (state.current && state.current.module === m.id && state.current.dir === k.dir ? " active" : "");
      el.innerHTML = `<span class="check">${solved ? "✓" : ""}</span><span class="t">${escapeHtml(k.title)}</span><span class="kkyu">${k.kyu}</span>`;
      el.onclick = () => openKata(m.id, k.dir);
      el.tabIndex = 0;
      el.title = `${k.title} (Alt+P / Alt+N — предыдущая/следующая kata)`;
      el.onkeydown = (e) => { if (e.key === "Enter" || e.key === " ") { e.preventDefault(); openKata(m.id, k.dir); } };
      nav.appendChild(el);
    }
  }
  nav.scrollTop = prevScroll;
}

function updateGlobalProgress() {
  const done = state.solvedSet.size, total = state.flat.length;
  $("#global-progress").textContent = total ? `${done}⁄${total} · ${Math.round(done / total * 100)}%` : "";
  $("#progress-bar i").style.width = total ? `${(done / total) * 100}%` : "0";
}

async function openKata(module, dir) {
  const data = await fetch(`/api/kata/${module}/${dir}`).then((r) => r.json());
  if (data.error) return;
  state.current = { module, dir, data };

  $("#kata-kyu").textContent = `${data.meta.kyu} kyu`;
  $("#kata-title").textContent = data.meta.title;
  $("#kata-meta").textContent = renderKataMeta(data);
  $("#tab-reference").disabled = !data.reference;

  renderDoc("theory");
  setDoc(edSolution, data.draft || data.solution);
  setDoc(edTests, data.tests);
  $("#output").innerHTML = `<div class="out-empty">${data.solved ? "✓ Уже решено — можно улучшить решение." : "Нажми «запустить тесты» или Ctrl+Enter."}</div>`;
  $("#out-status").textContent = data.solved ? "решено" : "";
  $("#out-status").className = data.solved ? "ok" : "";
  renderSidebar();
  const activeEl = document.querySelector(".kata-item.active");
  if (activeEl) activeEl.scrollIntoView({ block: "nearest" });
  updateNavButtons();
  location.hash = `${module}/${dir}`;
}

function renderKataMeta(d) {
  const parts = [];
  if (d.hasHidden) parts.push("есть скрытые тесты");
  if (d.attempts) parts.push(`попыток: ${d.attempts}`);
  if (d.solvedAt) {
    const dt = new Date(d.solvedAt);
    parts.push(`решено ${dt.toLocaleDateString("ru-RU")} ${String(dt.getHours()).padStart(2, "0")}:${String(dt.getMinutes()).padStart(2, "0")}`);
  }
  return parts.join(" · ");
}

function currentIndex() {
  return state.flat.findIndex((k) => state.current && k.module === state.current.module && k.dir === state.current.dir);
}
function updateNavButtons() {
  const i = currentIndex();
  $("#btn-prev").disabled = i <= 0;
  $("#btn-next").disabled = i < 0 || i >= state.flat.length - 1;
}
$("#btn-prev").onclick = () => { const i = currentIndex(); if (i > 0) openKata(state.flat[i - 1].module, state.flat[i - 1].dir); };
$("#btn-next").onclick = () => { const i = currentIndex(); const k = state.flat[i + 1]; if (k) openKata(k.module, k.dir); };

// ---------- вкладки документации ----------
let activeTab = "theory";
function renderDoc(tab) {
  activeTab = tab;
  document.querySelectorAll(".tab").forEach((t) => t.classList.toggle("active", t.dataset.tab === tab));
  const d = state.current?.data;
  const box = $("#doc-content");
  if (!d) { box.innerHTML = ""; return; }
  let md = "";
  if (tab === "theory") md = d.theory || "_Нет материала._";
  else if (tab === "task") md = (d.solved ? `<div class="solved-banner">✓ Kata решена</div>\n\n` : "") + (d.task || "_Нет условия._");
  else if (tab === "hint") md = d.hint || "_Подсказок нет. Ты справишься._";
  else if (tab === "reference") md = "```zig\n" + (d.reference || "") + "\n```";
  box.innerHTML = marked.parse(md);
  box.scrollTop = 0;
}
document.querySelectorAll(".tab").forEach((t) => (t.onclick = () => renderDoc(t.dataset.tab)));

// ---------- вывод ----------
// зачищаем stderr от стектрейсов: оставляем header'ы тестов, expected-строки,
// локации ошибок и compile errors — всё, что читается за секунды
function cleanStderr(stderr) {
  return stderr.split("\n").filter((l) => {
    if (/the following test command failed/.test(l)) return false;   // шум zig при любом фейле
    if (/^\d+ passed|^All \d+ tests passed/.test(l)) return false;   // дублирует summary-блок
    if (/^\d+\/\d+\s/.test(l)) return true;                          // "1/5 name...expected X, found Y"
    if (/^(OK|FAIL|SKIP)\b/.test(l)) return true;
    if (/\S+\.zig:\d+:\d+/.test(l) && !l.includes("/lib/zig/") && !l.includes("/usr/lib/zig/")) return true; // только свои файлы
    if (/\berror:/.test(l) && !/error return trace/i.test(l)) return true;
    if (/^\s*note:/.test(l)) return true;
    if (/expected/.test(l)) return true;
    if (/^\d+ passed|All \d+ tests passed/.test(l)) return true;
    return false;
  }).join("\n").replace(/\n{2,}/g, "\n").trim();
}

// zig пишет локации как "path/to/solution.zig:12:34: error: msg" —
// разворачиваем их в диагностику редактора (подчёркивание + тултип).
function extractDiagnostics(stderr) {
  const diags = [];
  const re = /(?:^|\s)[^\s:]*solution\.zig:(\d+):(\d+):\s*(error|warning|note):\s*(.*)$/gm;
  let m;
  while ((m = re.exec(stderr || ""))) {
    const lineNo = +m[1], col = +m[2], sev = m[3] === "warning" ? "warning" : m[3] === "note" ? "info" : "error";
    if (lineNo < 1 || lineNo > edSolution.state.doc.lines) continue;
    const line = edSolution.state.doc.line(lineNo);
    const pos = Math.min(line.from + Math.max(0, col - 1), line.to);
    const to = Math.max(pos, Math.min(line.to, pos + 8)); // ширину токена zig не отдаёт
    diags.push({ from: pos, to, severity: sev, message: m[4].trim() });
  }
  return diags;
}

function renderOutput(r) {
  const out = $("#output");
  let html = "";
  if (r.stderr !== undefined)
    edSolution.dispatch(setDiagnostics(edSolution.state, extractDiagnostics(r.stderr)));
  if (r.tests?.length) {
    for (const t of r.tests)
      html += `<div class="test-line"><span class="st-${t.status}">${t.status === "OK" ? "✓" : t.status === "FAIL" ? "✗" : "—"}</span> <span class="name">${escapeHtml(t.name)}</span> ${t.hidden ? '<span class="hidden-badge">скрытый</span> ' : ""}<span class="st-${t.status}">${t.status}</span></div>`;
  }
  const cleaned = r.stderr ? cleanStderr(r.stderr)
    .replace(/\s*0x[0-9a-f]+ in .*$/gm, "")                          // адрес + имя фрейма
    .replace(/\/tmp\/zigwars-[^/]+\//g, "")                          // временные пути
    .replace(/:\s*$/gm, "")                                          // хвостовые двоеточия
    .replace(/^\s+$/gm, "").replace(/\n{2,}/g, "\n").trim() : "";
  if (cleaned) html += `<div class="out-stderr">${escapeHtml(cleaned).replace(/(\S+\.zig:\d+:\d+)/g, '<span class="loc">$1</span>')}</div>`;
  if (r.summary || r.kind !== "tests")
    html += `<div class="out-summary ${r.ok ? "ok" : "bad"}">${r.kind === "timeout" ? "⏱ таймаут (20с)" : r.kind === "compile" ? "ошибка компиляции — см. выше" : escapeHtml(r.summary || (r.ok ? "пройдено" : "не пройдено"))}</div>`;
  if (!html) html = `<div class="out-empty">Нет вывода.</div>`;
  out.innerHTML = html;
  out.scrollTop = out.scrollHeight;
}
const escapeHtml = (s) => s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

// ---------- действия ----------
let saveTimer = null;
function queueDraftSave() {
  clearTimeout(saveTimer);
  saveTimer = setTimeout(() => {
    if (!state.current) return;
    fetch("/api/draft", { method: "POST", headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ module: state.current.module, kata: state.current.dir, solution: getDoc(edSolution) }) });
  }, 1200);
}
edSolution.dom.addEventListener("keyup", queueDraftSave);

$("#btn-run").onclick = async () => {
  if (!state.current) return;
  const btn = $("#btn-run");
  btn.disabled = true; btn.textContent = "⏳ zig test…";
  $("#out-status").textContent = "компиляция…"; $("#out-status").className = "";
  try {
    const r = await fetch("/api/run", { method: "POST", headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ module: state.current.module, kata: state.current.dir,
        solution: getDoc(edSolution) }) }).then((x) => x.json());
    renderOutput(r);
    $("#out-status").textContent = r.ok ? "пройдено" : r.kind === "compile" ? "ошибка" : "не пройдено";
    $("#out-status").className = r.ok ? "ok" : "bad";
    if (r.ok && r.passed > 0) {
      state.solvedSet.add(`${state.current.module}/${state.current.dir}`);
      state.current.data.solved = true;
      renderSidebar(); updateGlobalProgress();
      const d = await fetch(`/api/kata/${state.current.module}/${state.current.dir}`).then((x) => x.json());
      if (d.reference) { state.current.data.reference = d.reference; $("#tab-reference").disabled = false; }
      state.current.data.solvedAt = d.solvedAt;
    }
    state.current.data.attempts = (state.current.data.attempts || 0) + 1;
    $("#kata-meta").textContent = renderKataMeta(state.current.data);
  } finally {
    btn.disabled = false; btn.textContent = "запустить тесты";
  }
};

$("#btn-reset").onclick = async () => {
  if (!state.current) return;
  if (!confirm("Сбросить решение к заготовке?")) return;
  const r = await fetch(`/api/reset/${state.current.module}/${state.current.dir}`, { method: "POST" }).then((x) => x.json());
  setDoc(edSolution, r.solution);
};

// Ctrl+Enter = тест; Alt+N / Alt+P — следующая/предыдущая kata
document.addEventListener("keydown", (e) => {
  if ((e.ctrlKey || e.metaKey) && e.key === "Enter") return void $("#btn-run").click();
  if (e.altKey && !e.ctrlKey && !e.metaKey) {
    const k = e.key.toLowerCase();
    if (k === "n" || k === "т") { e.preventDefault(); $("#btn-next").click(); }
    else if (k === "p" || k === "з") { e.preventDefault(); $("#btn-prev").click(); }
  }
});

// ---------- старт / роутер ----------
async function route() {
  if (location.hash.length > 1) {
    const [m, k] = location.hash.slice(1).split("/");
    const target = state.flat.find((x) => x.module === m && x.dir === k);
    if (target) {
      if (!(state.current && state.current.module === m && state.current.dir === k)) await openKata(m, k);
      return;
    }
  }
  if (!state.current && state.flat.length) await openKata(state.flat[0].module, state.flat[0].dir);
}
window.addEventListener("hashchange", route);

// ---------- live-reload (dev): SSE от сервера ----------
// "style" — только css, без перезагрузки; "page" — полный reload;
// "content" — перечитываем модули и текущую kata (черновик решения не трогаем);
// "hello" с новым boot-id — сервер перезапустился (node --watch) → reload.
if (typeof EventSource !== "undefined") {
  const es = new EventSource("/api/dev-events");
  let bootId = null;
  const refreshStyle = () => {
    document.querySelectorAll('link[rel="stylesheet"]').forEach((l) => {
      l.href = l.href.split("?")[0] + "?t=" + Date.now();
    });
  };
  es.addEventListener("style", refreshStyle);
  es.addEventListener("page", () => location.reload());
  es.addEventListener("content", async () => {
    await loadModules();
    updateNavButtons();
    if (!state.current) return;
    const doc = getDoc(edSolution); // неизменённый черновик мог быть не сохранён
    await openKata(state.current.module, state.current.dir);
    renderDoc(activeTab);
    if (doc !== getDoc(edSolution)) setDoc(edSolution, doc);
  });
  es.addEventListener("hello", (e) => {
    if (bootId && bootId !== e.data) location.reload();
    bootId = e.data;
  });
}

await loadModules();
await route();
