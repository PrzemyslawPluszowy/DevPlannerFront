# Hosting Flutter Web — wymagany fallback SPA

## Dlaczego

AutoRoute obsługuje trasy workspace’ów, projektów i zasobów po stronie
przeglądarki. Serwer musi więc zwrócić `index.html` dla nieistniejącej ścieżki
aplikacji. Bez tego wejście bezpośrednio w adres projektu albo odświeżenie
strony kończy się serwerowym 404, zanim uruchomi się Flutter.

## Nginx

W katalogu publikacji `build/web` należy użyć reguły:

```nginx
root /srv/ready-next/build/web;

location / {
    try_files $uri $uri/ /index.html;
}
```

Pliki statyczne (w tym `flutter.js`, manifest i assety) są sprawdzane przed
fallbackiem. Nie należy przekierowywać wszystkich żądań bezpośrednio do
`index.html`, ponieważ ukryłoby to błędy brakujących assetów.

## CDN / hosting statyczny

Skonfiguruj rewrite `/*` → `/index.html` jako odpowiedź dla ścieżek, których
plik nie istnieje. Reguła musi zachować query string, bo deep linki mogą
przenosić `messageId`, `cursor` albo `redirect`.

## Kontrola wdrożenia

Po publikacji należy sprawdzić w zalogowanej sesji:

1. wejście w nowej karcie na `/workspaces/{workspaceId}`;
2. wejście bezpośrednio na trasę zasobu projektu;
3. odświeżenie obu adresów;
4. Back/Forward oraz query i fragment URL.

Ta instrukcja nie zastępuje testu konkretnego serwera — w repozytorium nie ma
jeszcze jego konfiguracji. Checklistę można odznaczyć dopiero po takim teście.
