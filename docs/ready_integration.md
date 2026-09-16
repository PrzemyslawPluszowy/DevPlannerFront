# Integracja z Ready

## Jak to działa

`Ready`:
- ustawia dane usera w `sessionStorage`
- otwiera Fluttera na odpowiedniej trasie

`Ready Next`:
- czyta trasę z URL
- czyta sesję z `sessionStorage`
- jeśli trzeba, może poprosić hosta o nowy token przez `postMessage`

## Co przekazać

Do `sessionStorage` zapisujemy:

```json
{
  "accessToken": "Bearer ...",
  "userId": "42",
  "userDisplayName": "Jan Kowalski"
}
```

Klucz:

```text
ready_next_launch_context
```

## Jak otworzyć moduł

Przykład dla `inventory`:

```js
sessionStorage.setItem(
  'ready_next_launch_context',
  JSON.stringify({
    accessToken: bearer,
    userId: currentUser.id,
    userDisplayName: currentUser.displayName,
  }),
);
window.location.href = '/ready-next/inventory';
```

Przykład dla `orders`:

```js
window.location.href = '/ready-next/orders';
```

## Dostępne trasy

- `/ready-next/inventory`
- `/ready-next/orders`

## Refresh tokena

Flutter może wysłać do hosta:

```json
{ "type": "ready-next:refresh-token" }
```

Host odpowiada:

```json
{
  "type": "ready-next:refresh-token-response",
  "accessToken": "Bearer nowy-token"
}
```

## Gdzie to jest w kodzie

- [host_bridge_web.dart](/Users/przemyslawnowak/Desktop/dev/Excellent/ready_next/lib/core/host/host_bridge_web.dart)
- [host_launch_context.dart](/Users/przemyslawnowak/Desktop/dev/Excellent/ready_next/lib/bootstrap/host_launch_context.dart)
- [app_route_paths.dart](/Users/przemyslawnowak/Desktop/dev/Excellent/ready_next/lib/app/router/app_route_paths.dart)
