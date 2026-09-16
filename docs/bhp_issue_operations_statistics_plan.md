# Plan statystyk BHP dla zakładki operacji

Cel: zbudować od nowa zakładkę statystyk BHP jako jeden ekran z górnym przełącznikiem segmentów i zwartymi kartami z najważniejszymi danymi.

## Założenia produktu

- Zakładka `Statystyki` pozostaje jedną sekcją w module BHP.
- Wewnątrz sekcji ma być górny przełącznik segmentów w stylu Cupertino.
- Każdy segment pokazuje inny typ statystyk, ale bez długiego pionowego scrolla.
- Widok ma być bardziej analityczny i "excelowy": zwarte karty, porównania, tabele pomocnicze.
- Zakres danych powinien wspierać porównania typu rok do roku, miesiąc do miesiąca i zakres do zakresu.

## Segmenty docelowe

### 1. Wydania

- Główne KPI operacyjne
- Porównanie okresów
- Top wydawanych elementów
- Top pracowników
- Rozkład po miesiącach lub dniach

### 2. Struktura

- Udział typów operacji
- Zestawienie według stanowisk
- Zestawienie według kart wyposażenia
- Dodatkowe grupowania, jeśli backend zwróci agregaty

### 3. Braki

- Osoby z niepełnym wyposażeniem
- Liczba braków na osobę
- Najczęściej brakujące elementy
- Największe luki względem standardu

### 4. Porównania

- Rok do roku
- Miesiąc do miesiąca
- Wzrosty i spadki dla wydań
- Wzrosty i spadki dla ilości

## Dane backendowe

- Obecny `GET /api/v1/bhp/dashboard/issue-operations` wystarczy głównie do segmentów `Wydania` i części `Struktura`.
- Segment `Braki` najpewniej wymaga osobnego endpointu agregującego brakujące wyposażenie globalnie.
- Segment `Porównania` może wymagać albo nowego endpointu, albo wydajnej agregacji po stronie backendu.

## Kolejność wdrożenia

1. [ ] Zbudować nowy pusty shell statystyk z przełącznikiem segmentów
2. [ ] Dopracować pierwszy kafel wizualny segmentu `Wydania`
3. [ ] Dodać sekcję KPI dla `Wydania`
4. [ ] Dodać kolejne segmenty i ich kontrakty danych
5. [ ] Ustalić brakujące endpointy backendowe
