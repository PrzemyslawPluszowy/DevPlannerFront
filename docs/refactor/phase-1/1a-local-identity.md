# Pakiet 1A — lokalne Identity (kontekst Frontend)

**Status: COMPLETE — lokalna tożsamość i izolacja runtime**
**Data:** 2026-09-16

Backend zakończył implementację modelu i fundamentów lokalnego ASP.NET Core
Identity, świeżego schematu `devplanner_identity` oraz usunięcie z runtime
startup/DI/config zewnętrznych rejestracji auth/directory/JWKS. Frontend nie
wprowadza w tym pakiecie zmian runtime; ten mirror zachowuje kontrakt statusu
dla obu repozytoriów.

Dowody backendu: restore/build, 7 testów `LocalIdentityFoundationTests`,
idempotent EF migration script (473 linii), format verify i `git diff --check`
— PASS. Zakres twierdzenia jest ograniczony do runtime startup/DI/config;
historyczne/dormant referencje i fixtures nie są deklarowane jako zero.

Gate 1A zamknięto 2026-09-16 w zakresie lokalnego modelu Identity, fresh
PostgreSQL reset/reprovision, restore drill i izolacji runtime. Dowód negative
network skierował fake Ready/Core/DataBus/JWKS na `127.0.0.1:59999`; startup
zakończył się przed rejestracją usług, a listener miał 0 bajtów. 1B i 1C mogą
się rozpocząć. Statyczne/dormant referencje i fixtures przechodzą do 1C/5/7;
finalne 7A/7D nadal wymagają pełnego zero-reference. Zachować ścisły
no-registration/no-external-network regression guard. Nie implementować
bootstrapu HTTP ani OIDC w zakresie 1A.
