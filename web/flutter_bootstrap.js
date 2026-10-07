{{flutter_js}}
{{flutter_build_config}}

(async function () {
  const buildVersionStorageKey = 'devplanner.web.build_version';

  function withVersion(url, version) {
    if (!url || !version) {
      return url;
    }

    const separator = url.includes('?') ? '&' : '?';
    return `${url}${separator}v=${encodeURIComponent(version)}`;
  }

  async function fetchBuildVersion() {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 5000);
    try {
      const response = await fetch(`version.json?t=${Date.now()}`, {
        cache: 'no-store',
        signal: controller.signal,
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
    } finally {
      clearTimeout(timeout);
    }
  }

  function readStoredVersion() {
    try {
      return localStorage.getItem(buildVersionStorageKey);
    } catch (error) {
      console.warn('Build version storage is unavailable.', error);
      return null;
    }
  }

  function storeVersion(version) {
    try {
      localStorage.setItem(buildVersionStorageKey, version);
    } catch (error) {
      console.warn('Build version storage is unavailable.', error);
    }
  }

  function reportStartupFailure(error) {
    console.error('App initialization failed.', error);
    window.dispatchEvent(new Event('devplanner-startup-error'));
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

  try {
    const buildVersion = await fetchBuildVersion();
    const previousBuildVersion = readStoredVersion();

    if (buildVersion) {
      for (const build of _flutter.buildConfig.builds) {
        build.mainJsPath = withVersion(build.mainJsPath, buildVersion);
        build.mainWasmPath = withVersion(build.mainWasmPath, buildVersion);
        build.jsSupportRuntimePath = withVersion(
          build.jsSupportRuntimePath,
          buildVersion,
        );
      }

      storeVersion(buildVersion);

      if (previousBuildVersion && previousBuildVersion !== buildVersion) {
        await clearOldWebCaches();
      }
    }

    await _flutter.loader.load({
      onEntrypointLoaded: async (engineInitializer) => {
        try {
          const appRunner = await engineInitializer.initializeEngine();
          await appRunner.runApp();
        } catch (error) { reportStartupFailure(error); }
      },
      serviceWorkerSettings: {
        serviceWorkerVersion: {{flutter_service_worker_version}},
      },
    });
  } catch (error) { reportStartupFailure(error); }
})();
