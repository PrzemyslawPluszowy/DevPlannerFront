# R3b — regresja globalnych paneli Chat i Powiadomień

Data: 2026-09-18  
Status: **36/36 PASS w testach automatycznych; live realtime nadal wymagany**

## Potwierdzony zakres częściowy

Chat i Powiadomienia są globalnymi overlayami, a nie trasami lub ekranami.
Testy potwierdzają, że:

- otwarcie/zamknięcie panelu nie zmienia widoku ani URI pod spodem;
- globalny host udostępnia resolver kontekstu pliku dla rozmowy;
- Chat czyści historię po 401 i nie ujawnia poprzedniego zakresu;
- lista rozmów zachowuje jawny błąd Backend;
- Inbox obsługuje cursor, licznik nieprzeczytanych, błąd i retry;
- odpowiedź z powiadomienia do Chat ma pojedynczy client UUID i fail-closed
  czyszczenie tekstu/Delta po 401/403.

```text
flutter test devplanner_global_panels_host_test.dart chat_*_cubit_test.dart \
  notifications_*_cubit_test.dart notification_reply_cubit_test.dart
36/36 PASS
```

To nie jest dowód dwóch zalogowanych użytkowników, prawdziwego SignalR ani
dostarczenia powiadomienia przez Backend. Te kroki pozostają częścią odbioru
desktop/staging.
