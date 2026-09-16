import 'package:flutter/material.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Lokalny kontroler współdzielonego formularza stanowiska BHP.
class BhpPositionFormController {
  /// Tworzy kontroler formularza stanowiska.
  BhpPositionFormController();

  /// Klucz formularza.
  final formKey = GlobalKey<FormState>();

  /// Kontroler pola nazwy.
  final nameController = TextEditingController();

  /// Kontroler pola uwag.
  final notesController = TextEditingController();

  bool _initialized = false;

  /// Uzupełnia formularz danymi istniejącego stanowiska.
  void hydrateFromItem(GetBhpPositionListItem item) {
    if (_initialized) {
      return;
    }

    nameController.text = item.nazwa.trim();
    notesController.text = item.uwagi?.trim() ?? '';
    _initialized = true;
  }

  /// Buduje żądanie API z aktualnej zawartości formularza.
  PostBhpPositionRequest buildRequest() {
    return PostBhpPositionRequest(
      nazwa: nameController.text.trim(),
      uwagi: _nullableText(notesController.text),
    );
  }

  /// Zwalnia kontrolery formularza.
  void dispose() {
    nameController.dispose();
    notesController.dispose();
  }

  String? _nullableText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
