const {readFileSync} = require('node:fs');
const {resolve} = require('node:path');
const vm = require('node:vm');
const {test} = require('node:test');
const assert = require('node:assert/strict');
const source = readFileSync(resolve(__dirname, '../../lib/workspaces/data/storage/transport/onlyoffice_editor_html_builder.dart'), 'utf8');
const script = source.split('<body><div id="editor"></div><script>')[1].split('</script></body>')[0]
  .replace('$safeConfiguration', JSON.stringify({document: {}, editorConfig: {}}))
  .replace('${_escapeAttribute(apiUrl)}', 'https://office.example/api.js');

function host(channelInitiallyAvailable) {
  const messages = [];
  const timers = new Set();
  const listeners = {};
  let now = 0;
  const bridge = {postMessage: value => messages.push(JSON.parse(value))};
  const window = {location: {origin: 'https://app.example'},
    addEventListener: (name, action) => {listeners[name] = action;}};
  if (channelInitiallyAvailable) window.storageBridge = bridge;
  const context = {window, Date: {now: () => now},
    setInterval: action => {timers.add(action); return action;},
    clearInterval: action => timers.delete(action),
    DocsAPI: {DocEditor: function (id, config) {
      config.events.onAppReady();
      config.events.onDocumentReady();
    }},
    document: {createElement: () => ({}), head: {appendChild: element => element.onload()}}};
  window.DocsAPI = context.DocsAPI;
  vm.runInNewContext(script, context);
  return {window, bridge, messages, timers, listeners,
    emit: (type, data) => context.send(type, data),
    tick: () => [...timers].forEach(action => action()),
    advance: value => {now += value;}};
}

test('late channel replays editor readiness in order exactly once', () => {
  const h = host(false);
  assert.deepEqual(h.messages, []);
  h.window.storageBridge = h.bridge;
  h.tick(); h.tick();
  assert.deepEqual(h.messages.map(x => x.type), ['apiLoaded', 'appReady', 'ready', 'editorCreated']);
  assert.equal(h.timers.size, 0);
});
test('native channel delivers immediately without polling', () => {
  const h = host(true);
  assert.deepEqual(h.messages.map(x => x.type), ['apiLoaded', 'appReady', 'ready', 'editorCreated']);
  assert.equal(h.timers.size, 0);
});
test('missing channel and page disposal stop pending polling', () => {
  const h = host(false);
  h.advance(30000); h.tick();
  assert.equal(h.timers.size, 0);
  assert.deepEqual(h.messages, []);
  const disposed = host(false);
  disposed.listeners.pagehide();
  assert.equal(disposed.timers.size, 0);
});

test('an unavailable bridge keeps only a bounded pending queue', () => {
  const h = host(false);
  for (let i=0;i<1000;i++) h.emit('warning', i);
  h.window.storageBridge = h.bridge;
  h.tick();
  assert.equal(h.messages.length, 64);
  assert.deepEqual(h.messages.slice(0,4).map(x=>x.type), ['apiLoaded','appReady','ready','editorCreated']);
});
