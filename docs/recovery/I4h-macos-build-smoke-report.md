# I4h — smoke test macOS po odzyskaniu powiadomień

## Cel

Zweryfikować, że bieżące zmiany w Front nie cofają naprawy startupu i można
zbudować oraz otworzyć natywną aplikację macOS.

## Wynik

```text
flutter build macos --debug
```

Wynik: PASS. Powstał
`build/macos/Build/Products/Debug/DevPlanner.app`.

Uruchomiono świeżo zbudowaną aplikację. Natywne okno `DevPlanner` pokazało
widoczny ekran logowania z przyciskiem `Zaloguj`, zamiast wcześniejszego
czarnego/pustego okna. W chwili smoke testu widoczny był też komunikat
`Nie udało się wykonać logowania.` — jest to wynik nieukończonej sesji albo
lokalnego połączenia, a nie potwierdzenie udanego logowania.

## Granice dowodu

Smoke test nie wpisuje danych użytkownika i nie dowodzi przepływu
login → callback PKCE → `/me` → SignalR → logout. Ten scenariusz pozostaje
osobnym ręcznym desktopowym E2E z działającym backendem.
