import 'package:flutter/material.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Lokalny kontroler współdzielonego formularza wyposażenia BHP.
class BhpEquipmentFormController {
  /// Tworzy kontroler formularza wyposażenia.
  BhpEquipmentFormController();

  /// Klucz formularza.
  final formKey = GlobalKey<FormState>();

  /// Kontroler pola symbolu.
  final symbolController = TextEditingController();

  /// Kontroler pola nazwy.
  final nazwaController = TextEditingController();

  /// Kontroler pola procentu przydatności.
  final procentPrzydatnosciController = TextEditingController();

  /// Kontroler pola okresu użytkowania.
  final okresUzywalnosciController = TextEditingController();

  /// Kontroler pola jednostki miary.
  final jmController = TextEditingController();

  /// Kontroler pola numeru dowodu wydania.
  final nrDowoduWydaniaController = TextEditingController();

  /// Kontroler pola ilości domyślnej.
  final iloscDomyslnaController = TextEditingController();

  /// Kontroler pola ekwiwalentu.
  final ekwiwalentController = TextEditingController();

  /// Kontroler pola ceny.
  final cenaController = TextEditingController();

  bool _initialized = false;

  /// Uzupełnia formularz danymi istniejącej karty wyposażenia.
  void hydrateFromDetail(GetBhpEquipmentDetails detail) {
    if (_initialized) {
      return;
    }

    symbolController.text = detail.symbol.trim();
    nazwaController.text = detail.nazwa.trim();
    procentPrzydatnosciController.text =
        detail.procentPrzydatnosci?.toString() ?? '';
    okresUzywalnosciController.text = detail.okresUzywalnosci?.trim() ?? '';
    jmController.text = detail.jm?.trim() ?? '';
    nrDowoduWydaniaController.text = detail.nrDowoduWydania?.trim() ?? '';
    iloscDomyslnaController.text = detail.iloscDomyslna?.trim() ?? '';
    ekwiwalentController.text = detail.ekwiwalent?.trim() ?? '';
    cenaController.text = detail.cena?.trim() ?? '';
    _initialized = true;
  }

  /// Buduje żądanie API z aktualnej zawartości formularza.
  PostBhpEquipmentRequest buildRequest() {
    return PostBhpEquipmentRequest(
      symbol: symbolController.text.trim(),
      nazwa: nazwaController.text.trim(),
      procentPrzydatnosci: _nullableInt(procentPrzydatnosciController.text),
      okresUzywalnosci: _nullableText(okresUzywalnosciController.text),
      jm: _nullableText(jmController.text),
      nrDowoduWydania: _nullableText(nrDowoduWydaniaController.text),
      iloscDomyslna: _nullableNumberText(iloscDomyslnaController.text),
      ekwiwalent: _nullableNumberText(ekwiwalentController.text),
      cena: _nullableNumberText(cenaController.text),
    );
  }

  /// Zwalnia kontrolery formularza.
  void dispose() {
    symbolController.dispose();
    nazwaController.dispose();
    procentPrzydatnosciController.dispose();
    okresUzywalnosciController.dispose();
    jmController.dispose();
    nrDowoduWydaniaController.dispose();
    iloscDomyslnaController.dispose();
    ekwiwalentController.dispose();
    cenaController.dispose();
  }

  String? _nullableText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String? _nullableNumberText(String value) {
    final trimmed = value.trim().replaceAll(',', '.');
    return trimmed.isEmpty ? null : trimmed;
  }

  int? _nullableInt(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    return int.tryParse(trimmed);
  }
}
