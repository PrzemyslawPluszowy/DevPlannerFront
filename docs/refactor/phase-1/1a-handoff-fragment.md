## Fragment do wspólnego handoffu — 1A (Frontend)

**Status: COMPLETE — lokalna tożsamość i izolacja runtime (2026-09-16).**
Frontend nie wprowadza zmian runtime w tym pakiecie; backend dostarczył lokalne
Identity, role/permissions, `LocalIdentityDbContext` i świeży schemat
`devplanner_identity`. Startup/DI/config nie rejestrują Core directory,
zewnętrznego JWKS, chat scope/workera ani DataBus.

Dowody Gate 1A: świeży lokalny PostgreSQL reset/migracja/seed, skrypt idempotentny
trzy razy, custom-format backup/restore schematu, oraz negative network proof z
fake Ready/Core/DataBus/JWKS wyłącznie na `127.0.0.1:59999`; startup zakończył się
przed rejestracją usług, listener miał 0 bajtów i brak połączeń. Backup 39 KiB,
SHA-256 `df02623909bbd231dcdd37d2b0fda14aff30283bd03bb2073bde9791d802b78b`;
restore odtworzył 14 tabel, 2 role, 3 permissions i 3 role-permissions.

EXIT 1A dotyczy aktywnego runtime i jego rejestracji, nie wymaga natychmiastowego
zera tekstowych referencji. Dormant klasy, statyczne referencje i fixtures są
zakresem pakietów 1C/5/7; nie wolno ich rejestrować ani dopuścić do zewnętrznego
połączenia. 1B i 1C mogą się rozpocząć. Ostateczne Gate 7A/7D nadal wymaga
pełnego zero-reference `CoreDirectory*`, zewnętrznego JWKS, Ready DTO/handlerów,
DataBus i zakazanych sekretów. Zachować ścisły
no-registration/no-external-network regression guard.
