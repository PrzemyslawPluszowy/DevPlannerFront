# Veloryn Core — wzorzec architektury na podstawie DevNoteBackend

## Decyzja

`veloryn-core` warto zbudować jako osobne **ASP.NET Core Minimal API**, w stylu
repozytorium `DevNoteBackend`: mały `Program.cs`, endpointy pogrupowane według
funkcji, warstwa serwisów, repozytoria i modele rozdzielone od kontraktów HTTP.

Nie należy kopiować całego mechanizmu autoryzacji DevNote 1:1. DevNote ma jeden
refresh token przechowywany bezpośrednio na użytkowniku; dla centralnego logowania
Ready Next jest to za mało, bo użytkownik będzie miał kilka urządzeń i modułów.

## Co w DevNote jest dobre i zostaje

| Element DevNote | Zastosowanie w Veloryn Core |
| --- | --- |
| `Program.cs` z metodami rozszerzającymi | Czytelny composition root; bez logiki biznesowej w `Program.cs`. |
| `Endpoints/<obszar>` | Osobne endpointy dla `Auth`, `Users`, `Permissions`, `Admin`, `Health`. |
| `Services/<obszar>` | Reguły logowania, odświeżania sesji i mapowania praw poza endpointami. |
| `Data/<obszar>` i interfejsy repozytoriów | Jedno miejsce na EF Core/PostgreSQL oraz osobny adapter tylko-do-odczytu do Ready. |
| `Models/Entities` + `Models/DTOs` | Encje bazy Core nie wyciekają do API; request/response są osobnymi typami. |
| `Configuration/*MappingProfile.cs` | AutoMapper dla prostych mapowań encja ↔ odpowiedź API. |
| `Validators` + FluentValidation | Walidacja wejścia przed wywołaniem serwisu. |
| `Result` + wspólne mapowanie błędów | Jeden przewidywalny format błędów HTTP. |
| `Extensions/InitProgram` | Rejestracja DI, bazy, auth i OpenAPI w małych plikach. |

Przykład z DevNote `Configuration/AuthMappingProfile.cs` jest właściwym wzorcem:
profil zawiera tylko deklaracje `CreateMap(...)`, bez reguł biznesowych. W Core
mapowanie może wyglądać np. tak:

```csharp
public sealed class AuthMappingProfile : Profile
{
    public AuthMappingProfile()
    {
        CreateMap<CoreUser, CurrentUserResponse>();
        CreateMap<ReadyUserRecord, CoreUser>()
            .ForMember(x => x.Id, options => options.Ignore())
            .ForMember(x => x.ReadyUserId, options => options.MapFrom(x => x.UserId));
    }
}
```

Mapowanie nie powinno zapisywać hasła, hashy ani tokenów Ready do encji Core.

## Proponowana struktura katalogów

```text
veloryn-core/
├── Attributes/
├── Configuration/
│   ├── AuthMappingProfile.cs
│   └── CoreOptions.cs
├── Data/
│   ├── Core/
│   │   ├── CoreDbContext.cs
│   │   ├── ICoreUserRepository.cs
│   │   └── RefreshSessionRepository.cs
│   └── Ready/
│       ├── IReadyIdentityProvider.cs
│       └── ReadyPostgresIdentityProvider.cs
├── Endpoints/
│   ├── Auth/AuthEndpoints.cs
│   ├── Users/UserEndpoints.cs
│   ├── Permissions/PermissionEndpoints.cs
│   └── Admin/AdminEndpoints.cs
├── Extensions/
│   ├── InitProgram/DatabaseExtensions.cs
│   ├── InitProgram/DiExtensions.cs
│   ├── AuthenticationExtensions.cs
│   └── ResultExtensions.cs
├── Middleware/
├── Models/
│   ├── Common/
│   ├── DTOs/
│   │   ├── Auth/
│   │   ├── Users/
│   │   └── Permissions/
│   └── Entities/
├── Services/
│   ├── Auth/
│   ├── Ready/
│   ├── Permissions/
│   └── Sessions/
├── Validators/
├── Tests/
└── Program.cs
```

Nazwy mogą pozostać takie jak w DevNote. Najważniejsze rozdzielenie to `Data/Core`
(własna baza) oraz `Data/Ready` (wyłącznie odczyt użytkownika i jego praw).

## Modele domenowe Core

Nie tworzymy kopii tabeli `public.users` ani nie pobieramy z Ready hasła. Minimalny
model własnej bazy:

```csharp
public sealed class CoreUser
{
    public Guid Id { get; init; } = Guid.NewGuid();
    public required int ReadyUserId { get; init; }
    public required string Login { get; set; }
    public string? DisplayName { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAtUtc { get; init; } = DateTime.UtcNow;
    public DateTime LastReadySyncAtUtc { get; set; }
    public ICollection<RefreshSession> RefreshSessions { get; set; } = [];
}

public sealed class RefreshSession
{
    public Guid Id { get; init; } = Guid.NewGuid();
    public required Guid CoreUserId { get; init; }
    public required string TokenHash { get; set; }
    public DateTime ExpiresAtUtc { get; set; }
    public DateTime? RevokedAtUtc { get; set; }
    public DateTime? ReplacedAtUtc { get; set; }
    public string? DeviceName { get; set; }
    public DateTime CreatedAtUtc { get; init; } = DateTime.UtcNow;
}

public sealed class ReadyPermissionSnapshot
{
    public Guid Id { get; init; } = Guid.NewGuid();
    public required Guid CoreUserId { get; init; }
    public required string Permission { get; init; }
    public DateTime ReceivedAtUtc { get; init; } = DateTime.UtcNow;
}
```

`CoreUser` to lokalny profil i stabilne `sub` tokenu. Źródłem konta oraz praw nadal
jest Ready/eDokumenty. Snapshot służy audytowi i diagnostyce, a nie przejęciu
zarządzania rolami z Ready.

### Kontrakty HTTP

DTO powinny być małe i jawne, najlepiej jako immutable `record`:

```csharp
public sealed record ReadyLoginRequest(string Login, string Password);

public sealed record TokenResponse(
    string AccessToken,
    DateTime AccessTokenExpiresAtUtc,
    IReadOnlyCollection<string> Permissions
);

public sealed record CurrentUserResponse(
    Guid Id,
    int ReadyUserId,
    string Login,
    string? DisplayName,
    IReadOnlyCollection<string> Permissions
);
```

Hasło występuje wyłącznie w `ReadyLoginRequest` podczas logowania i nie może trafić
do logów, odpowiedzi API ani encji.

## Przepływ odpowiedzialności

```text
AuthEndpoints
  -> AuthService
       -> IReadyIdentityProvider       (Ready: weryfikacja konta, tylko odczyt)
       -> IReadyPermissionProvider     (Ready: grupy/prawa, tylko odczyt)
       -> ICoreUserRepository           (Core: profil, sesje, audyt)
       -> ITokenService                 (Core: podpisany JWT)
  -> TokenResponse
```

Endpoint nie wykonuje SQL ani nie buduje tokenu. Serwis nie zna HTTP. Adapter Ready
nie zna modeli API Core. To jest zgodne z ideą DevNote, ale wyraźniej oddziela
zewnętrzny system tożsamości od własnej bazy.

## Autoryzacja i sesje — lepiej niż w DevNote

1. `POST /auth/ready/login` przekazuje login i hasło tylko do dostawcy Ready.
2. Core odczytuje przypisane prawa Ready i mapuje je, np.
   `bswfms.custom_modules.inwentaryzacja` → `inventory.read`.
3. Core tworzy/aktualizuje `CoreUser`, tworzy wiersz `RefreshSession` i wydaje
   krótki JWT (5–10 minut).
4. Do bazy zapisujemy **hash** refresh tokenu, nigdy sam token.
5. `POST /auth/refresh` sprawdza sesję, ponownie odczytuje stan i prawa z Ready,
   rotuje refresh token oraz wydaje nowy access token.
6. Backend BHP/Inwentaryzacji sprawdza podpis JWT lokalnie przez klucz publiczny
   Core/JWKS — nie pyta Ready ani Core przy każdym żądaniu.

Ważna różnica wobec `AuthUser.RefreshToken` z DevNote: osobna tabela pozwala mieć
równocześnie komputer, telefon i przeglądarkę, wylogować jedno urządzenie oraz
wykrywać użycie starego tokenu po rotacji.

## Co zmienić względem DevNote

| Fragment DevNote | Decyzja dla Core | Powód |
| --- | --- | --- |
| Hasło w `AuthUser` | Nie przechowywać hasła Ready. Opcjonalne hasło Core dopiero jako osobna, jawna funkcja. | Ready pozostaje źródłem tożsamości. |
| Jeden `RefreshToken` na użytkowniku | Tabela `RefreshSessions`, hash i rotacja. | Wiele urządzeń, odwołanie pojedynczej sesji i bezpieczeństwo. |
| JWT HMAC z jednym sekretem | Asymetryczne klucze RSA/ECDSA, `issuer`, `audience` i JWKS. | PHP i kolejne moduły walidują token bez poznawania sekretu Core. |
| Kod HTTP `498` | Standardowe `401 Unauthorized` z kodem błędu w body. | Lepsza zgodność klientów, proxy i OpenAPI. |
| `HtmlResponses` | Niepotrzebne w pierwszej wersji. Można użyć tylko dla przyszłego resetu lokalnego hasła. | Core zaczyna jako API, bez ekranów HTML. |
| `ISimplePermissionService` z dziedziczeniem zasobów | `IReadyPermissionProvider` + jawna mapa praw modułowych. | Prawa są administracyjne w Ready, nie zależą od workspace/board. |

## Granice bezpieczeństwa

- Adapter Ready ma osobne dane połączenia i konto bazy tylko do odczytu.
- Core nie zapisuje nic do tabel Ready: użytkowników, grup, praw ani tokenów.
- JWT zawiera wyłącznie identyfikator Core, `ready_user_id`, prawa, `iss`, `aud`,
  `iat` i `exp`; nie zawiera haseł, danych połączenia ani pełnego rekordu Ready.
- Zmiana/odebranie prawa w Ready jest widoczne przy najbliższym refreshu; ważność
  starego access tokenu ogranicza jego krótki czas życia.
- Usunięty lub zablokowany użytkownik Ready nie odnowi sesji; Core unieważni jego
  lokalne sesje i zachowa jedynie ślad audytowy.

## Pierwszy zakres implementacji

1. Szkielet katalogów, `CoreDbContext`, migracja i konfiguracja Docker/PostgreSQL.
2. Adapter Ready tylko do odczytu użytkownika oraz jego grup/praw.
3. Endpointy `login`, `refresh`, `logout`, `me` oraz JWKS.
4. Mapa praw dla Inwentaryzacji; BHP jako kolejny moduł.
5. Middleware walidujący JWT Core w BHP i Inwentaryzacji w trybie przejściowym
   (akceptacja starego tokenu Ready i nowego Core).

IQC oraz obecne endpointy DataBus pozostają w tej fazie bez zmian.
