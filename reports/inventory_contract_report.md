# Raport zgodnosci kontraktu

## Podsumowanie

- Endpointy w app: **14**
- Klasy modeli: **36**
- Enumy modeli: **2**
- Bledy: **0**
- Ostrzezenia: **32**

## WARN

- [GET /api/v1/inwentaryzacja] Pole GetInwentaryzacjeItem.komisjaCount jest non-null; w Swagger nie jest required
- [GET /api/v1/inwentaryzacja] Pole GetInwentaryzacjeItem.arkuszeCount jest non-null; w Swagger nie jest required
- [POST /api/v1/inwentaryzacja] Brak parametru w Swagger (potencjalny brak opisu backend): query:firma
- [POST /api/v1/inwentaryzacja] Brak parametru w Swagger (potencjalny brak opisu backend): query:numer
- [POST /api/v1/inwentaryzacja] Brak parametru w Swagger (potencjalny brak opisu backend): query:komisja_user_ids
- [POST /api/v1/inwentaryzacja] Brak parametru w Swagger (potencjalny brak opisu backend): query:data_od
- [POST /api/v1/inwentaryzacja] Brak parametru w Swagger (potencjalny brak opisu backend): query:data_do
- [POST /api/v1/inwentaryzacja] Brak parametru w Swagger (potencjalny brak opisu backend): query:uwagi
- [POST /api/v1/inwentaryzacja] Brak parametru w Swagger (potencjalny brak opisu backend): query:status
- [POST /api/v1/inwentaryzacja] Pole PostInwentaryzacjaResponseData.success jest non-null; w Swagger nie jest required
- [GET /api/v1/inwentaryzacja/{inwentaryzacja_id}] Pole GetInwentaryzacjaDetailsArkuszItem.elementyCount jest non-null; w Swagger nie jest required
- [GET /api/v1/inwentaryzacja/{inwentaryzacja_id}] Pole GetInwentaryzacjaDetailsArkuszItem.komisja jest non-null; w Swagger nie jest required
- [DELETE /api/v1/inwentaryzacja/{inwentaryzacja_id}] Pole DeleteInwentaryzacjaResponseData.success jest non-null; w Swagger nie jest required
- [PATCH /api/v1/inwentaryzacja/{inwentaryzacja_id}/status] Brak parametru w Swagger (potencjalny brak opisu backend): query:status
- [PATCH /api/v1/inwentaryzacja/{inwentaryzacja_id}/status] Pole PatchInwentaryzacjaStatusResponseData.success jest non-null; w Swagger nie jest required
- [POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/arkusze] Brak parametru w Swagger (potencjalny brak opisu backend): query:id_miejsca
- [POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/arkusze] Brak parametru w Swagger (potencjalny brak opisu backend): query:scope
- [POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/arkusze] Brak parametru w Swagger (potencjalny brak opisu backend): query:komisja_user_ids
- [POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/arkusze] Pole PostArkuszResponseData.success jest non-null; w Swagger nie jest required
- [DELETE /api/v1/inwentaryzacja/arkusze/{arkusz_id}] Pole DeleteArkuszResponseData.success jest non-null; w Swagger nie jest required
- [PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}] Brak parametru w Swagger (potencjalny brak opisu backend): query:stan_inwent
- [PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}] Brak parametru w Swagger (potencjalny brak opisu backend): query:likwidacja
- [PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}] Brak parametru w Swagger (potencjalny brak opisu backend): query:nadwyzka
- [PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}] Brak parametru w Swagger (potencjalny brak opisu backend): query:nowy_kod_kreskowy
- [PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}] Brak parametru w Swagger (potencjalny brak opisu backend): query:nowa_osoba
- [PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}] Brak parametru w Swagger (potencjalny brak opisu backend): query:nowa_nazwa
- [PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}] Brak parametru w Swagger (potencjalny brak opisu backend): query:uwagi_loc
- [PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}] Pole PatchArkuszElementResponseData.success jest non-null; w Swagger nie jest required
- [POST /api/v1/inwentaryzacja/firmy] Brak parametru w Swagger (potencjalny brak opisu backend): query:id_firmy
- [POST /api/v1/inwentaryzacja/firmy] Brak parametru w Swagger (potencjalny brak opisu backend): query:nazwa
- [POST /api/v1/inwentaryzacja/firmy] Brak parametru w Swagger (potencjalny brak opisu backend): query:aktywna
- [DELETE /api/v1/inwentaryzacja/firmy/{firma_id}] Pole DeleteFirmaResponseData.success jest non-null; w Swagger nie jest required

## OK

Kontrakt zgodny ze Swagger dla endpointow uzywanych w app.
