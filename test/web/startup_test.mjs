import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import { test } from 'node:test';

const indexSource = readFileSync(new URL('../../web/index.html', import.meta.url), 'utf8');
const startupSource = indexSource.match(/<script id="startup-controller"[^>]*>([\s\S]*?)<\/script>/)[1];
const bootstrapSource = readFileSync(new URL('../../web/flutter_bootstrap.js', import.meta.url), 'utf8')
  .replace('{{flutter_js}}', '')
  .replace('{{flutter_build_config}}', '')
  .replace('{{flutter_service_worker_version}}', 'null');

function harness({ language = 'pl-PL', storageBlocked = false, loadError = false, metadataHangs = false } = {}) {
  const events = new Map();
  const timers = new Map();
  const elements = new Map();
  let timerId = 0;
  let appended;
  let options;
  let reloads = 0;
  function element() {
    return {
      textContent: '', hidden: true, removed: false, events: new Map(),
      addEventListener(name, callback) { this.events.set(name, callback); },
      remove() { this.removed = true; },
    };
  }
  for (const id of ['app-startup', 'startup-title', 'startup-message', 'startup-retry']) {
    elements.set(id, element());
  }
  const progress = element();
  elements.get('app-startup').querySelector = () => progress;
  const build = { mainWasmPath: 'main.dart.wasm', jsSupportRuntimePath: 'main.dart.mjs' };
  const context = vm.createContext({
    document: {
      documentElement: {}, currentScript: { dataset: { bootstrap: 'flutter_bootstrap.js?release=qa' } },
      getElementById: (id) => elements.get(id),
      createElement: () => element(),
      body: { appendChild(script) { appended = script; } },
    },
    navigator: { language },
    window: {
      location: { reload() { reloads++; } },
      addEventListener(name, callback) { events.set(name, callback); },
      dispatchEvent(event) { events.get(event.type)?.(event); },
    },
    Event, AbortController,
    console: { warn() {}, error() {} },
    setTimeout(callback, delay) { const id = ++timerId; timers.set(id, { callback, delay }); return id; },
    clearTimeout(id) { timers.delete(id); },
    localStorage: {
      getItem() { if (storageBlocked) throw Error('Storage blocked'); return null; },
      setItem() { if (storageBlocked) throw Error('Storage blocked'); },
    },
    fetch: (_, { signal }) => metadataHangs
      ? new Promise((_, reject) => signal.addEventListener('abort', () => reject(Error('Aborted'))))
      : Promise.resolve({ ok: true, json: async () => ({ version: '1', build_number: 'qa' }) }),
    _flutter: {
      buildConfig: { builds: [build] },
      loader: { async load(value) { options = value; if (loadError) throw Error('Private loader trace'); } },
    },
  });
  vm.runInContext(startupSource, context);
  return {
    elements, progress, build, context,
    script: () => appended, options: () => options, reloads: () => reloads,
    fire(name) { events.get(name)?.(); },
    timeout(delay) { for (const { callback, delay: actual } of [...timers.values()]) if (actual === delay) callback(); },
    start: () => vm.runInContext(bootstrapSource, context),
  };
}

test('startup recovery is inline and has no external script dependency', () => {
  assert.ok(startupSource.includes("flutter-first-frame"));
  assert.equal(/<script[^>]+src=/.test(indexSource), false);
});

const tick = () => new Promise((resolve) => setImmediate(resolve));

test('startup stays through engine/runApp and disappears only at first frame', async () => {
  const h = harness();
  assert.equal(h.script().src, 'flutter_bootstrap.js?release=qa');
  await h.start();
  await h.options().onEntrypointLoaded({ initializeEngine: async () => ({ runApp: async () => {} }) });
  assert.equal(h.elements.get('app-startup').removed, false);
  h.fire('flutter-first-frame');
  assert.equal(h.elements.get('app-startup').removed, true);
  h.timeout(45000);
  assert.equal(h.elements.get('startup-retry').hidden, true);
});

test('slow start offers recovery without claiming a network failure', () => {
  const h = harness({ language: 'en-US' });
  h.timeout(45000);
  assert.equal(h.elements.get('startup-title').textContent, 'Starting is taking longer');
  assert.equal(h.elements.get('startup-retry').hidden, false);
  h.elements.get('startup-retry').events.get('click')();
  assert.equal(h.reloads(), 1);
  h.fire('flutter-first-frame');
  assert.equal(h.elements.get('app-startup').removed, true);
});

test('missing bootstrap shows an understandable failure and preserves retry', () => {
  const h = harness();
  h.script().events.get('error')();
  assert.equal(h.elements.get('startup-title').textContent, 'Nie udało się uruchomić aplikacji');
  assert.equal(h.elements.get('startup-retry').hidden, false);
  assert.equal(h.progress.hidden, true);
});

test('blocked local storage does not prevent versioned startup', async () => {
  const h = harness({ storageBlocked: true });
  await h.start();
  assert.ok(h.options());
  assert.equal(h.build.mainWasmPath, 'main.dart.wasm?v=1%2Bqa');
});

test('metadata timeout aborts fetch and still starts the app', async () => {
  const h = harness({ metadataHangs: true });
  const start = h.start();
  h.timeout(5000);
  await start;
  assert.ok(h.options());
  assert.equal(h.build.mainWasmPath, 'main.dart.wasm');
});

test('loader, engine and runApp failures reach the recovery UI without raw errors', async () => {
  const loader = harness({ loadError: true });
  await loader.start();
  assert.equal(loader.elements.get('startup-title').textContent, 'Nie udało się uruchomić aplikacji');
  for (const stage of ['engine', 'runApp']) {
    const h = harness();
    await h.start();
    await h.options().onEntrypointLoaded({ initializeEngine: async () => {
      if (stage === 'engine') throw Error('Private engine trace');
      return { runApp: async () => { throw Error('Private app trace'); } };
    } });
    await tick();
    assert.equal(h.elements.get('startup-retry').hidden, false);
    assert.equal(h.elements.get('startup-message').textContent.includes('Private'), false);
  }
});
