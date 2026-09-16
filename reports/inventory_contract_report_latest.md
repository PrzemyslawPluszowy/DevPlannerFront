# Raport zgodnosci kontraktu

## Podsumowanie

- Endpointy w app: **16**
- Klasy modeli: **40**
- Enumy modeli: **4**
- Bledy: **0**
- Ostrzezenia: **13**

## WARN

- [GET /api/v1/inwentaryzacja] Pole GetInwentaryzacjeItem.komisjaCount jest non-null; w Swagger nie jest required
- [GET /api/v1/inwentaryzacja] Pole GetInwentaryzacjeItem.arkuszeCount jest non-null; w Swagger nie jest required
- [POST /api/v1/inwentaryzacja] Pole PostInwentaryzacjaResponseData.success jest non-null; w Swagger nie jest required
- [GET /api/v1/inwentaryzacja/{inwentaryzacja_id}] Pole GetInwentaryzacjaDetailsArkuszItem.elementyCount jest non-null; w Swagger nie jest required
- [GET /api/v1/inwentaryzacja/{inwentaryzacja_id}] Pole GetInwentaryzacjaDetailsArkuszItem.komisja jest non-null; w Swagger nie jest required
- [DELETE /api/v1/inwentaryzacja/{inwentaryzacja_id}] Pole DeleteInwentaryzacjaResponseData.success jest non-null; w Swagger nie jest required
- [PUT /api/v1/inwentaryzacja/{inwentaryzacja_id}/komisja] Pole KomisjaUpdateData.success jest non-null; w Swagger nie jest required
- [POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/zamknij] Pole ZamknijInwentaryzacjeResponseData.success jest non-null; w Swagger nie jest required
- [POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/arkusze] Pole PostArkuszResponseData.success jest non-null; w Swagger nie jest required
- [DELETE /api/v1/inwentaryzacja/arkusze/{arkusz_id}] Pole DeleteArkuszResponseData.success jest non-null; w Swagger nie jest required
- [PUT /api/v1/inwentaryzacja/arkusze/{arkusz_id}/komisja] Pole KomisjaUpdateData.success jest non-null; w Swagger nie jest required
- [PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}] Pole PatchArkuszElementResponseData.success jest non-null; w Swagger nie jest required
- [DELETE /api/v1/inwentaryzacja/firmy/{firma_id}] Pole DeleteFirmaResponseData.success jest non-null; w Swagger nie jest required

## OK

Kontrakt zgodny ze Swagger dla endpointow uzywanych w app.
