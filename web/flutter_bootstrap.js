{{flutter_js}}
{{flutter_build_config}}

(async function () {
  const buildVersionStorageKey = 'ready_next.web.build_version';

  function withVersion(url, version) {
    if (!url || !version) {
      return url;
    }

    const separator = url.includes('?') ? '&' : '?';
    return `${url}${separator}v=${encodeURIComponent(version)}`;
  }

  async function fetchBuildVersion() {
    try {
      const response = await fetch(`version.json?t=${Date.now()}`, {
        cache: 'no-store',
      });
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      const payload = await response.json();
      const version = [payload.version, payload.build_number]
        .filter((value) => typeof value === 'string' && value.length > 0)
        .join('+');

      return version || null;
    } catch (error) {
      console.warn('Failed to fetch fresh build version.', error);
      return null;
    }
  }

  async function clearOldWebCaches() {
    if ('serviceWorker' in navigator) {
      try {
        const registrations = await navigator.serviceWorker.getRegistrations();
        await Promise.allSettled(
          registrations.map((registration) => registration.unregister()),
        );
      } catch (error) {
        console.warn('Failed to unregister old service workers.', error);
      }
    }

    if ('caches' in window) {
      try {
        const cacheKeys = await caches.keys();
        await Promise.allSettled(
          cacheKeys.map((cacheKey) => caches.delete(cacheKey)),
        );
      } catch (error) {
        console.warn('Failed to clear old cache storage.', error);
      }
    }
  }

  const buildVersion = await fetchBuildVersion();
  const previousBuildVersion = localStorage.getItem(buildVersionStorageKey);

  if (buildVersion) {
    for (const build of _flutter.buildConfig.builds) {
      build.mainJsPath = withVersion(build.mainJsPath, buildVersion);
      build.mainWasmPath = withVersion(build.mainWasmPath, buildVersion);
      build.jsSupportRuntimePath = withVersion(
        build.jsSupportRuntimePath,
        buildVersion,
      );
    }

    localStorage.setItem(buildVersionStorageKey, buildVersion);

    if (previousBuildVersion && previousBuildVersion !== buildVersion) {
      await clearOldWebCaches();
    }
  }

  await _flutter.loader.load({
    serviceWorkerSettings: {
      serviceWorkerVersion: {{flutter_service_worker_version}},
    },
  });
})();
