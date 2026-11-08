import http from "node:http";
import { readFile, readdir, stat } from "node:fs/promises";
import { existsSync, watch } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { runTests } from "./runner.mjs";

const ROOT = path.dirname(fileURLToPath(import.meta.url));
const PUBLIC = path.join(ROOT, "public");
const CONTENT = path.join(ROOT, "content");
const PROGRESS_FILE = path.join(ROOT, "progress.json"); // legacy: разово отдаём клиенту для миграции в IndexedDB
const PORT = process.env.PORT || 7100;

const MIME = {
  ".html": "text/html; charset=utf-8", ".js": "text/javascript; charset=utf-8",
  ".mjs": "text/javascript; charset=utf-8", ".css": "text/css; charset=utf-8",
  ".json": "application/json", ".md": "text/markdown; charset=utf-8",
  ".zig": "text/plain; charset=utf-8", ".svg": "image/svg+xml", ".png": "image/png",
};

async function loadProgress() {
  try { return JSON.parse(await readFile(PROGRESS_FILE, "utf8")); }
  catch { return null; }
}

// Сканирует content/: модули → kata (сортирует по имени каталога)
async function scanContent() {
  const modules = [];
  if (!existsSync(CONTENT)) return modules;
  for (const modDir of (await readdir(CONTENT)).sort()) {
    const mp = path.join(CONTENT, modDir);
    if (!(await stat(mp)).isDirectory()) continue;
    const katas = [];
    for (const kataDir of (await readdir(mp)).sort()) {
      const kp = path.join(mp, kataDir);
      if (!(await stat(kp)).isDirectory()) continue;
      try {
        const meta = JSON.parse(await readFile(path.join(kp, "meta.json"), "utf8"));
        katas.push({ dir: kataDir, ...meta });
      } catch { /* неполная kata — пропускаем */ }
    }
    let title = modDir, description = "";
    try {
      const mi = JSON.parse(await readFile(path.join(mp, "module.json"), "utf8"));
      title = mi.title || modDir; description = mi.description || "";
    } catch {}
    if (katas.length) modules.push({ id: modDir, title, description, katas });
  }
  return modules;
}

async function kataFiles(moduleId, kataDir) {
  const base = path.join(CONTENT, moduleId, kataDir);
  const read = (f) => readFile(path.join(base, f), "utf8").catch(() => "");
  const [meta, theory, task, solution, tests, hint, reference, testsHidden] = await Promise.all([
    read("meta.json"), read("theory.md"), read("task.md"),
    read("solution.zig"), read("tests.zig"), read("hint.md"), read("reference.zig"),
    read("tests_hidden.zig"),
  ]);
  return { meta: JSON.parse(meta || "{}"), theory, task, solution, tests, hint, reference, testsHidden };
}

function json(res, code, obj) {
  const body = JSON.stringify(obj);
  res.writeHead(code, { "Content-Type": "application/json", "Content-Length": Buffer.byteLength(body) });
  res.end(body);
}

async function readBody(req) {
  let b = "";
  for await (const c of req) b += c;
  try { return JSON.parse(b); } catch { return {}; }
}

// ---------- dev live-reload (SSE) ----------
// public/*.css → "style" (без перезагрузки), остальной public/ → "page",
// content/** → "content" (перечитываем модули/текущую kata без reload).
const BOOT_ID = String(Date.now());
const sseClients = new Set();
const sseTimers = new Map();
const sseSend = (event, ms = 500) => {
  clearTimeout(sseTimers.get(event));
  sseTimers.set(event, setTimeout(() => {
    for (const r of sseClients) r.write(`event: ${event}\ndata: {}\n\n`);
  }, ms));
};
try {
  watch(PUBLIC, { recursive: true }, (_e, f) =>
    sseSend(f && f.endsWith(".css") ? "style" : "page"));
  watch(CONTENT, { recursive: true }, (_e, f) => f && sseSend("content"));
} catch { /* recursive watch недоступен — live-reload просто не работает */ }

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://localhost:${PORT}`);
  const p = url.pathname;

  try {
    // ---------- API ----------
    if (p === "/api/modules") {
      return json(res, 200, { modules: await scanContent() });
    }

    // разовая выгрузка legacy progress.json → клиент импортирует в IndexedDB
    if (p === "/api/progress-export") {
      return json(res, 200, (await loadProgress()) || {});
    }

    const kataMatch = p.match(/^\/api\/kata\/([\w-]+)\/([\w-]+)$/);
    if (kataMatch && req.method === "GET") {
      const [, mod, kataDir] = kataMatch;
      const files = await kataFiles(mod, kataDir);
      if (!files.meta.id) return json(res, 404, { error: "kata not found" });
      return json(res, 200, {
        module: mod, dir: kataDir, ...files,
        testsHidden: undefined,
        hasHidden: !!files.testsHidden,
        hasReference: !!files.reference,
        // прогресс живёт на клиенте (IndexedDB) — эталон отдаём отдельным эндпоинтом
        reference: undefined,
      });
    }

    // эталонное решение; "unlock" реализован на клиенте — локальный тренажёр, читерить бессмысленно
    const refMatch = p.match(/^\/api\/reference\/([\w-]+)\/([\w-]+)$/);
    if (refMatch && req.method === "GET") {
      const [, mod, kataDir] = refMatch;
      const files = await kataFiles(mod, kataDir);
      if (!files.meta.id) return json(res, 404, { error: "kata not found" });
      return json(res, 200, { reference: files.reference });
    }

    if (p === "/api/run" && req.method === "POST") {
      const { module: mod, kata, solution } = await readBody(req);
      if (typeof solution !== "string" || solution.length > 200_000)
        return json(res, 400, { error: "bad payload" });
      // тесты берём ТОЛЬКО с диска — пользовательские правки не принимаем
      const { tests, testsHidden } = await kataFiles(mod, kata);
      if (!tests) return json(res, 400, { error: "kata tests not found" });
      return json(res, 200, await runTests(solution, tests, { hiddenSrc: testsHidden || null }));
    }

    if (p === "/api/dev-events") {
      res.writeHead(200, { "Content-Type": "text/event-stream", "Cache-Control": "no-cache", Connection: "keep-alive" });
      res.write(`event: hello\ndata: ${BOOT_ID}\n\nretry: 1000\n\n`);
      sseClients.add(res);
      req.on("close", () => sseClients.delete(res));
      return;
    }

    // ---------- static ----------
    let filePath = path.join(PUBLIC, p === "/" ? "index.html" : decodeURIComponent(p));
    if (!filePath.startsWith(PUBLIC)) return json(res, 403, { error: "forbidden" });
    try {
      const data = await readFile(filePath);
      res.writeHead(200, { "Content-Type": MIME[path.extname(filePath)] || "application/octet-stream" });
      res.end(data);
    } catch {
      json(res, 404, { error: "not found" });
    }
  } catch (e) {
    json(res, 500, { error: String(e.stack || e) });
  }
});

server.listen(PORT, () => console.log(`ZigWars: http://localhost:${PORT}`));
