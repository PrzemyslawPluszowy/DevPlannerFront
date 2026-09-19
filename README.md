# DevPlanner

Samodzielna aplikacja `DevPlanner` w Flutterze dla Web i desktopu.

## Lokalny build

### Desktop macOS ze stagingiem

Domyślna konfiguracja VS Code **DevPlanner macOS — staging** łączy aplikację
z backendem wdrożonym pod `https://devnote.flutter-dev.pl`. Nie wymaga to
uruchamiania lokalnego API, PostgreSQL ani MinIO:

```bash
flutter run -d macos --dart-define=DEVPLANNER_API_BASE_URL=https://devnote.flutter-dev.pl
```

Staging ma wspólny origin dla Flutter Web, BFF, API, OpenIddict i SignalR.
Adres należy przekazywać przez `--dart-define`; plik `.env` nie jest ładowany
przez `flutter run`.

### Desktop macOS z lokalnym backendem

Do logowania desktop używa lokalnego HTTPS backendu DevPlanner. Uruchom backend
zgodnie z jego README, a następnie wystartuj Front z jednoznacznym originem:

```bash
flutter run -d macos --dart-define=DEVPLANNER_API_BASE_URL=https://localhost:5173
```

W VS Code wybierz konfigurację **DevPlanner macOS — lokalny HTTPS** z
`.vscode/launch.json`; przekazuje ona tę samą flagę. Nie uruchamiaj desktopu
bez `DEVPLANNER_API_BASE_URL`: domyślny adres `http://localhost:5072` jest
celowo bezpieczny dla świeżego checkoutu, ale lokalny serwer autoryzacji wymaga
HTTPS i odmówi żądania logowania po HTTP.

Standardowy build release (rekomendowany):

```bash
flutter build web --source-maps --no-tree-shake-icons
```

> [!NOTE]
> Flaga `--no-tree-shake-icons` jest konieczna, ponieważ domyślne usuwanie nieużywanych ikon (tree-shaking) w Flutter Web powoduje niewyświetlanie ikon dynamicznych (np. pogodowych) oraz nowo dodanych ikon z powodu agresywnej optymalizacji czcionek i pamięci podręcznej przeglądarki.

> [!IMPORTANT]
> Flaga `--source-maps` jest wymagana dla poprawnej symbolikacji błędów Web w Sentry. Bez niej nie powstaje `build/web/main.dart.js.map`, więc stack trace z produkcyjnego Weba nie będą poprawnie mapowane do kodu Dart.

Build WebAssembly:

```bash
flutter build web --wasm --source-maps --no-tree-shake-icons
```

Wynik builda:

```text
build/web
```

## Deploy na serwer testowy

Skrypt kopiujący build na serwer:

```bash
./scripts/build_web_production.sh
```

Skrypt wysyła pliki do:

```text
root@192.168.170.20:/var/www/ready_custom_flutter
```

## Produkcyjny build DevPlanner

Produkcja używa osobnego, ignorowanego przez Git pliku `.env.production`.
Przygotuj go na podstawie bezpiecznego szablonu:

```bash
cp .env.production.example .env.production
```

Następnie uruchom:

```bash
./scripts/build_web_production.sh
```

Skrypt przekazuje jeden adres standalone API przez `--dart-define=
DEVPLANNER_API_BASE_URL=...`. Lokalny `.env` pozostaje bez zmian; domyślny
development origin to loopback, więc świeży checkout nie łączy się z dawnymi
usługami.

W buildzie desktopowym, który ma generować linki publiczne do plików, należy
dodatkowo przekazać publiczny adres aplikacji webowej:

```bash
flutter build macos --dart-define=PUBLIC_APP_BASE_URL=https://adres-aplikacji.example
```

Bez tej wartości desktop celowo nie tworzy niepełnego ani lokalnego linku.
Flutter Web/Wasm wyznacza ten adres z aktualnego `Uri.base` i nie korzysta z
`dart:html`.

## Gdzie to stoi na serwerze

Pliki aplikacji:

```text
/var/www/ready_custom_flutter
```

Apache vhost:

```text
/etc/apache2/sites-available/ready-custom-flutter.conf
```

Apache backup portow:

```text
/etc/apache2/ports.conf.bak-ready-custom-flutter
```

Aplikacja jest wystawiona testowo pod:

```text
http://192.168.170.20:8088
```

## Przydatne komendy serwerowe

Sprawdzenie konfiguracji Apache:

```bash
apache2ctl configtest
```

Przeladowanie Apache:

```bash
systemctl reload apache2
```

Sprawdzenie, czy Apache slucha na 8088:

```bash
ss -tulpn | grep 8088
```

## Routing

Aplikacja uzywa path-based routingu Flutter Web, wiec Apache musi oddawac `index.html` dla tras typu:

- `/workspaces`
- `/workspaces/:workspaceId`
- `/storage/public/:shareToken`

Fallback musi zwracać `index.html` dla tras aplikacji DevPlanner.

## Typowy update

1. `flutter build web --source-maps --no-tree-shake-icons`
2. `./deploy_ready_custom_flutter.sh`
3. Twarde odświeżenie przeglądarki

## Uwaga

Wcześniej stosowany build z flagą `--wasm` generował błędy kompilacji ze względu na biblioteki niekompatybilne z Wasm GC. Domyślny build JS działa stabilnie i w pełni obsługuje aplikację.

## Sentry

### Web

- Upload sourcemapów działa dla release builda Web.
- Wymagany build: `flutter build web --source-maps --no-tree-shake-icons`.
- Aktualna konfiguracja release trafia do projektu Sentry `devplanner-web`.

### Windows

- Runtime Sentry jest podpięty także dla desktopowego Windows.
- Plugin `sentry_flutter` jest zarejestrowany w `windows/flutter/generated_plugin_registrant.cc`.
- `sentry_dart_plugin` zna standardowe ścieżki symboli Windows, między innymi:
  - `build/windows/runner/Release`
  - `build/windows/x64/runner/Release`
  - `build/windows/arm64/runner/Release`
  - `windows/flutter/ephemeral/flutter_windows.dll.pdb`
- Do raportowania błędów z Windows wymagany jest build `release`.
- End-to-end upload symboli Windows wymaga wykonania `flutter build windows --release` na Windows i sprawdzenia wygenerowanych `.pdb`.

## Stan refaktoryzacji

Pakiet 6A ustanowił standalone foundation, branding i fail-closed konfigurację
jednego originu API. Legacy feature’y są jeszcze obecne jako przejściowy graf i
zostaną odłączane pionowymi slice’ami zgodnie z planem w `docs/refactor/phase-6`.
