import 'package:flutter/material.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Lokalny kontroler współdzielonego formularza pracownika BHP.
class BhpUserFormController {
  /// Tworzy kontroler formularza pracownika.
  BhpUserFormController();

  /// Klucz formularza.
  final formKey = GlobalKey<FormState>();

  /// Kontroler pola imienia.
  final imieController = TextEditingController();

  /// Kontroler pola nazwiska.
  final nazwiskoController = TextEditingController();

  /// Kontroler pola numeru PESEL.
  final peselController = TextEditingController();

  /// Kontroler pola numeru telefonu.
  final numerTelefonuController = TextEditingController();

  /// Kontroler pola miejsca zamieszkania.
  final miejsceController = TextEditingController();

  /// Kontroler pola wzrostu.
  final wzrostController = TextEditingController();

  /// Kontroler pola obwodu klatki piersiowej.
  final klatkaController = TextEditingController();

  /// Kontroler pola obwodu pasa.
  final pasController = TextEditingController();

  /// Kontroler pola obwodu głowy.
  final glowaController = TextEditingController();

  /// Kontroler pola długości stopy.
  final stopaController = TextEditingController();

  /// Kontroler pola uwag.
  final uwagiController = TextEditingController();

  /// Data rozpoczęcia pracy.
  DateTime? dataRozpoczecia;

  /// Data zakończenia pracy.
  DateTime? dataZakonczenia;

  /// Wybrane stanowisko.
  int? stanowiskoId;

  /// Id użytkownika READY zachowywane podczas edycji.
  int? readyId;

  /// Czy formularz był już wysłany.
  bool submitted = false;

  bool _initialized = false;

  /// Czy daty zatrudnienia są nieprawidłowe.
  bool get hasInvalidEmploymentDates {
    if (dataRozpoczecia == null || dataZakonczenia == null) {
      return false;
    }

    return dataZakonczenia!.isBefore(dataRozpoczecia!);
  }

  /// Czy data zakończenia pracy już minęła.
  bool get hasExpiredEmploymentEndDate {
    if (dataZakonczenia == null) {
      return false;
    }

    final selectedEndDate = DateUtils.dateOnly(dataZakonczenia!);
    final today = DateUtils.dateOnly(DateTime.now());

    return selectedEndDate.isBefore(today);
  }

  /// Uzupełnia formularz danymi istniejącego pracownika.
  void hydrateFromDetail(
    GetBhpUserDetail detail,
    List<GetBhpPositionListItem> positions,
  ) {
    if (_initialized) {
      return;
    }

    imieController.text = detail.imie?.trim() ?? '';
    nazwiskoController.text = detail.nazwisko?.trim() ?? '';
    peselController.text = detail.pesel?.trim() ?? '';
    numerTelefonuController.text = detail.numerTelefonu?.trim() ?? '';
    miejsceController.text = detail.miejsceZamieszkania?.trim() ?? '';
    wzrostController.text = detail.wzrost?.trim() ?? '';
    klatkaController.text = detail.obwodKlatkiPiers?.trim() ?? '';
    pasController.text = detail.obwodPasa?.trim() ?? '';
    glowaController.text = detail.obwodGlowy?.trim() ?? '';
    stopaController.text = detail.dlStopy?.trim() ?? '';
    uwagiController.text = detail.uwagi?.trim() ?? '';
    dataRozpoczecia = DateTime.tryParse(detail.dataRozpPracy ?? '');
    dataZakonczenia = DateTime.tryParse(detail.dataZakPracy ?? '');
    readyId = detail.readyId;
    stanowiskoId = positions.any((item) => item.id == detail.stanowiskoId)
        ? detail.stanowiskoId
        : null;
    _initialized = true;
  }

  /// Buduje żądanie API z aktualnej zawartości formularza.
  PostBhpUserRequest buildRequest() {
    final selectedPositionId = stanowiskoId;
    if (selectedPositionId == null) {
      throw StateError('Brak wybranego stanowiska dla formularza pracownika.');
    }

    return PostBhpUserRequest(
      imie: imieController.text.trim(),
      nazwisko: nazwiskoController.text.trim(),
      stanowiskoId: selectedPositionId,
      pesel: _nullableText(peselController),
      numerTelefonu: _nullableText(numerTelefonuController),
      readyId: readyId,
      dataRozpPracy: _formatDate(dataRozpoczecia),
      dataZakPracy: _formatDate(dataZakonczenia),
      miejsceZamieszkania: _nullableText(miejsceController),
      wzrost: _nullableText(wzrostController),
      obwodKlatkiPiers: _nullableText(klatkaController),
      obwodPasa: _nullableText(pasController),
      obwodGlowy: _nullableText(glowaController),
      dlStopy: _nullableText(stopaController),
      uwagi: _nullableText(uwagiController),
    );
  }

  /// Buduje uproszczone żądanie do lokalnego sprawdzania podobnych rekordów.
  PostBhpUserRequest buildDuplicateCheckRequest() {
    return PostBhpUserRequest(
      imie: imieController.text.trim(),
      nazwisko: nazwiskoController.text.trim(),
      stanowiskoId: stanowiskoId ?? 0,
      pesel: _nullableText(peselController),
    );
  }

  /// Zwalnia kontrolery formularza.
  void dispose() {
    imieController.dispose();
    nazwiskoController.dispose();
    peselController.dispose();
    numerTelefonuController.dispose();
    miejsceController.dispose();
    wzrostController.dispose();
    klatkaController.dispose();
    pasController.dispose();
    glowaController.dispose();
    stopaController.dispose();
    uwagiController.dispose();
  }

  String? _nullableText(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  String? _formatDate(DateTime? date) {
    if (date == null) {
      return null;
    }

    return date.toApiDate();
  }
}
