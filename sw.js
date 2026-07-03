const CACHE_NAME = 'vitrina-v4';
const STATIC_ASSETS = [
  '/lib/vitrina-tokens.css',
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(STATIC_ASSETS).catch(() => {}))
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);

  // NUNCA cachear APIs dinámicas
  if (
    url.hostname.includes('supabase') ||
    url.hostname.includes('workers.dev') ||
    url.hostname.includes('anthropic') ||
    url.pathname.includes('/api/')
  ) {
    return;
  }

  // HTML y JS: SIEMPRE frescos (el panel y lib/*.js no deben quedar cacheados/viejos).
  // Bypassa el caché del navegador; si no hay red, cae al caché como fallback.
  if (event.request.mode === 'navigate' || url.pathname.endsWith('.html') || url.pathname.endsWith('.js')) {
    event.respondWith(
      fetch(event.request, { cache: 'no-store' }).catch(() => caches.match(event.request))
    );
    return;
  }

  // Assets estáticos: cache first
  if (STATIC_ASSETS.some(a => event.request.url.includes(a))) {
    event.respondWith(
      caches.match(event.request).then(r => r || fetch(event.request))
    );
  }
  // Todo lo demás: network first (datos del menú siempre frescos)
});
