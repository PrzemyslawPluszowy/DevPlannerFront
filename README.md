# ready_next

Aplikacja `Ready Next` w Flutterze dla Web i desktopu.

## Lokalny build

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
./deploy_ready_custom_flutter.sh
```

Skrypt wysyła pliki do:

```text
root@192.168.170.20:/var/www/ready_custom_flutter
```

## Produkcyjny build z Veloryn Core

Produkcja używa osobnego, ignorowanego przez Git pliku `.env.production`.
Przygotuj go na podstawie bezpiecznego szablonu:

```bash
cp .env.production.example .env.production
```

Następnie uruchom:

```bash
./scripts/build_web_production.sh
```

Skrypt przekazuje produkcyjne adresy przez `--dart-define` i buduje Flutter Web
z adresami `b2b8101`, `b2b8103` i `b2b8104`. Lokalny `.env` pozostaje bez zmian.
Gotowy katalog `build/web` można wysłać dotychczasowym
`deploy_ready_custom_flutter.sh`.

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

- `/inventory`
- `/inventory/stock`
- `/orders`

Fallback jest skonfigurowany w `ready-custom-flutter.conf`.

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
- Aktualna konfiguracja release trafia do projektu Sentry `ready-next-web`.

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

## Bootstrap DevPlannerFront

To repozytorium zostało utworzone jako pełny snapshot frontendu Ready Next, aby
zachować punkt wyjścia do migracji. Kolejny etap obejmie wydzielenie
samodzielnego modułu Workspaces/DevPlanner; ten commit celowo nie usuwa modułów
ani nie przebudowuje uwierzytelniania.
